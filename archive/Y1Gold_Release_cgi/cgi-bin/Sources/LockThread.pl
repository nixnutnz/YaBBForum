###############################################################################
# LockThread.pl                                                               #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Project started by Zef Hemel (zef@zefnet.com)                   #
# Software Version: YaBB 1 Gold - Release                                     #
# =========================================================================== #
# Software Distributed by:    http://yabb.xnull.com                           #
# Support, News, Updates at:  http://yabb.xnull.com/community/                #
# =========================================================================== #
# Copyright (c) 2000-2001 X-Null - All Rights Reserved                        #
# Software by: The YaBB Development Team                                      #
###############################################################################

$lockthreadplver="1 Gold - Release";

sub LockThread {
	if((!exists $moderators{$username}) && $settings[7] ne "Administrator") { &fatal_error("$txt{'93'}"); }
	my( @threads, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate );
	
	fopen(BOARDFILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	@threads = <BOARDFILE>;
	fclose(BOARDFILE);
	
	($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$yyThreadLine);
	$mstate = $mstate ? 0 : 1;
	$threads[$yyThreadPosition] = "$mnum|$msub|$mname|$memail|$mdate|$mreplies|$musername|$micon|$mstate\n";
	
	fopen(BOARDFILE, ">$boardsdir/$currentboard.txt", 1) || &fatal_error("$txt{'23'} $currentboard.txt");
	print BOARDFILE @threads;
	fclose(BOARDFILE);
	
	my $start = $INFO{'start'} || 0;
	$yySetLocation = qq~$cgi&action=display&num=$INFO{'thread'}&start=$start~;
	&redirectexit;
}

1;