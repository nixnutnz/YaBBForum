###############################################################################
# LockThread.pl                                                               #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Community Software for Webmasters                               #
# Version:        YaBB 1 Gold - SP 1.1                                        #
# Released:       December 2001; Updated March 22, 2002                       #
# Distributed by: http://www.yabbforum.com                                    #
# =========================================================================== #
# Copyright (c) 2000-2002 Xnull (www.xnull.com) - All Rights Reserved.        #
# Software by: The YaBB Development Team                                      #
#              with assistance from the YaBB community.                       #
###############################################################################

$lockthreadplver = "1 Gold - SP 1.1";

sub LockThread {
	my $threadid = $INFO{'thread'};
	fopen(BOARDFILE, "+<$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	seek BOARDFILE, 0, 0;
	my $buffer = 1;
	my $found = 0;
	while ($buffer) {
		$offset = tell BOARDFILE;
		$buffer = <BOARDFILE>;
		if($buffer =~ m~\A$threadid\|~o) {
			$found = 1;
			last;
		}
	}
	if ($found) {
		seek BOARDFILE, $offset, 0;
		chomp $buffer;
		my( $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate );
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$buffer);
		if((exists $moderators{$username}) || $settings[7] eq "Administrator" || ($username eq $mname && $username ne 'Guest')) {
			$mstate = $mstate ? 0 : 1;
			if ($mstate == 1) { $yySetLocation = qq~$cgi~; }
			else { $yySetLocation = qq~$cgi;action=display;num=$INFO{'thread'};start=$start;mstate=$mstate~; }
			print BOARDFILE "$mnum|$msub|$mname|$memail|$mdate|$mreplies|$musername|$micon|$mstate\n";
			fclose(BOARDFILE);
		} else { fclose(BOARDFILE); &fatal_error("$txt{'93'}"); }
	}
	
	my $start = $INFO{'start'} || 0;

	&redirectexit;
}

1;
