###############################################################################
# RemoveThread.pl                                                             #
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

$removethreadplver="1 Gold - Release";

sub RemoveThread {
	$yytitle = "$txt{'246'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
<tr>
	<td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'63'}</b></font></td>
</tr>
<tr>
	<td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>
$txt{'162'}<br>
<b><a href="$cgi&action=removethread2&thread=$INFO{'thread'}">$txt{'163'}</a> - <a href="$cgi&action=display&num=$INFO{'thread'}">$txt{'164'}</a></b>
</font></td>
</tr>
</table>
EOT
	&footer;
	exit;

}

sub RemoveThread2 {
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
	&dumplog($currentboard);
	$yySetLocation = qq~$cgi~;
	&redirectexit;
}

1;