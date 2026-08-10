###############################################################################
# SetStatus.pl                                                                #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Community Software for Webmasters                               #
# Version:        YaBB 2.1                                                    #
# Released:       November 8, 2005                                            #
# Distributed by: http://www.yabbforum.com                                    #
# =========================================================================== #
# Copyright (c) 2000-2005 YaBB (www.yabbforum.com) - All Rights Reserved.     #
# Software by: The YaBB Development Team                                      #
#              with assistance from the YaBB community.                       #
# Sponsored by: Xnull Internet Media, Inc. - http://www.ximinc.com            #
#               Your source for web hosting, web design, and domains.         #
###############################################################################

$setstatusplver = 'YaBB 2.1 $Revision: 1.1 $';
if ($action eq 'detailedversion') { return 1; }

sub SetStatus {
	my $buffer;
	my $start      = $INFO{'start'} || 0;
	my $ctbid      = $INFO{'thread'};
	my $thisstatus = "";
	my $status     = substr($INFO{'action'}, 0, 1) || substr($FORM{'action'}, 0, 1);
	my $ref        = $INFO{'ref'};
	if ($iammod || $iamadmin || $iamgmod) {
		my $threadid = $INFO{'thread'};
		if (!$currentboard) {
			&MessageTotals("load", $threadid);
			$currentboard = ${$threadid}{'board'};
		}
		my $found = 0;
		fopen(BOARDFILE, "$boardsdir/$currentboard.txt") || &fatal_error("test $txt{'23'} $currentboard.txt", 1);
		@boardfile = <BOARDFILE>;
		fclose(BOARDFILE);
		fopen(BOARDFILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt", 1);

		foreach my $line (@boardfile) {
			chomp $line;
			if ($line =~ m~\A$threadid\|~) {
				$buffer = $line;
				my ($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate);
				($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/, $buffer);

				if ($mstate !~ /0/) {
					$mstate .= "0";
					$line = qq~$mnum|$msub|$mname|$memail|$mdate|$mreplies|$musername|$micon|$mstate~;
				}

				$yydebug .= "Checking status of $threadid with the state of $mstate";
				if ($mstate =~ /$status/) {
					$yydebug .= " It was '$status'. removing<br />";
					$mstate =~ s/$status//ig;

					# Sticky-ing redirects to messageindex always
					if ($status eq "s") {
						$yySetLocation = qq~$scripturl?board=$currentboard~;
					} else {
						$yySetLocation = qq~$scripturl?num=$INFO{'thread'}/$start~;
					}
				} else {
					$yydebug .= " It wasn't '$status'. adding<br />";
					$mstate  .= "$status";
					$yySetLocation = qq~$scripturl?board=$currentboard~;
				}
				$thisstatus = qq~$mstate~;
				print BOARDFILE "$mnum|$msub|$mname|$memail|$mdate|$mreplies|$musername|$micon|$mstate\n";
			} elsif ($line =~ /\|/i) {
				print BOARDFILE $line . "\n";
			} else {

				#this is a bad line
				next;
			}
		}
		fclose(BOARDFILE);
	} else {
		&fatal_error("$txt{'93'}");
	}
	fopen(CTBFILE, "$datadir/$ctbid.ctb");
	@ctbfile = <CTBFILE>;
	fclose(CTBFILE);
	$ctbfile[5] = qq~$thisstatus\n~;
	fopen(CTBFILE, ">$datadir/$ctbid.ctb");
	print CTBFILE @ctbfile;
	fclose(CTBFILE);
	fopen(BOARDFILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt", 1);
	@boardfile = <BOARDFILE>;
	fclose(BOARDFILE);
	fopen(BOARDFILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt", 1);

	foreach my $line (@boardfile) {
		if ($line =~ /\|/ig) {
			print BOARDFILE $line;
		}
	}
	fclose(BOARDFILE);
	if (!$INFO{'moveit'}) {
		&redirectexit;
	}
}

1;
