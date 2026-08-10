###############################################################################
# RemoveThread.pl                                                             #
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

$removethreadplver = "1 Gold - SP 1.1";

sub RemoveThread {
	my( $threadcount, $messagecount, $lastposttime, $lastposter, $tmpa, $tmpb, $checknum, $a, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach, $thread, @threads, $mnum2 );
	$thread = $INFO{'thread'};
	if ($thread =~ m~/~){ &fatal_error($txt{'224'}); }
	if ($thread =~ m~\\~){ &fatal_error($txt{'225'}); }
	if((!exists $moderators{$username}) && $settings[7] ne "Administrator") {
		&fatal_error("$txt{'73'}");
	}

	fopen(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("7542 $txt{'23'} $currentboard.txt");
	@threads = <FILE>;
	fclose(FILE);

	($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$yyThreadLine);
	$tmpb = $mreplies + 1;

	( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
	--$threadcount;
	$messagecount -= $tmpb;

	if( $yyThreadPosition == 0 ) {
		($mnum2, $tmpb, $tmpb, $tmpb, $lastposttime) = split(/\|/, $threads[1]);
		if( $mnum2 ) {
			fopen(FILE, "$datadir/$mnum2.data");
			$tmpa = <FILE>;
			fclose(FILE);
			($tmpa, $lastposter) = split(/\|/, $tmpa);
		}
		else {
			$lastposttime = 'N/A';
			$lastposter = 'N/A';
		}
	}

	$threads[$yyThreadPosition] = '';
	fopen(FILE, ">$boardsdir/$currentboard.txt", 1) || &fatal_error("7543 $txt{'23'} $currentboard.txt");
	print FILE @threads;
	fclose(FILE);

	&BoardCountSet( $currentboard, $threadcount, $messagecount, $lastposttime, $lastposter );

	unlink("$datadir/$thread.txt");
	unlink("$datadir/$thread.mail");
	unlink("$datadir/$thread.data");
	&Sticky_remove($thread);
	
	&dumplog($currentboard);
	$yySetLocation = qq~$cgi~;
	&redirectexit;
}

1;