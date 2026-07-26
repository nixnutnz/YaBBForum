###############################################################################
# MoveThread.pl                                                               #
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

$movethreadplver="1 Gold - Release";

sub MoveThread {
	if((!exists $moderators{$username}) && $settings[7] ne "Administrator") { &fatal_error("$txt{'134'}"); }
	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);
	$yytitle = "$txt{'132'}";
	$boardlist="";
	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		fopen(CAT, "$boardsdir/$curcat.cat");
		@catinfo = <CAT>;
		fclose(CAT);
		$catinfo[1] =~ s/[\n\r]//g;
		$curcatname="$catinfo[0]";
		foreach $curboard (@catinfo) {
			$curboard =~ s/[\n\r]//g;
			fopen(BOARD, "$boardsdir/$curboard.dat");
			@boardinfo = <BOARD>;
			fclose(BOARD);
			chomp @boardinfo;
			$curboardname = $boardinfo[0];
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
				$curboard =~ s/[\n\r]//g;
				$boardlist .= "<option value=\"$curboard\">$curboardname";
			}
		}
	}
	############################
	&header;
	print <<"EOT";
<table border="0" width="400" cellspacing="1" bgcolor="$color{'bordercolor'}" class="bordercolor" cellpadding="4" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'132'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>
    <form action="$cgi&action=movethread2&thread=$INFO{'thread'}" method="POST"><BR>
    <b>$txt{'133'}:</b> <select name="toboard">$boardlist</select>
    <input type=submit value="$txt{'132'}">
    </form>
    </font></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub MoveThread2 {
	if((!exists $moderators{$username}) && $settings[7] ne "Administrator") { &fatal_error("$txt{'134'}"); }
	my( $thread, $toboard, @threads, $a, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach, $checknum, $mobilenum, $mobiledate, $mobileposts, $threadcount, $messagecount, $lastposttime, $lastposter, $mnuma, $tmpa, $mtime, $mobiletime );
	$thread=$INFO{'thread'};
	if( $thread =~ /\D/ ) { &fatal_error($txt{'337'}); }
	$toboard = $FORM{'toboard'};
	if ($toboard =~ m~/~){ &fatal_error($txt{'224'}); }
	if ($toboard =~ m~\\~){ &fatal_error($txt{'225'}); }
	fopen(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	@threads = <FILE>;
	fclose(FILE);
	
	($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$yyThreadLine);
	$threads[$yyThreadPosition] = '';
	$checknum = $yyThreadPosition + 1;
	$mobilenum = $mnum;
	$mobiledate = $mdate;
	$mobiletime = stringtotime($mdate);
	$mobileposts = $mreplies + 1;

	fopen(FILE, ">$boardsdir/$currentboard.txt", 1) || &fatal_error("$txt{'23'} $currentboard.txt");
	print FILE @threads;
	fclose(FILE);

	unless( $checknum ) {
		&fatal_error(qq~$txt{'472'}: $thread $currentboard -&gt; $toboard~);
	}
	( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
	--$threadcount;
	$messagecount -= $mobileposts;
	if( $checknum == 1 ) {
		$_ = $threads[1];
		chomp;
		($mnuma, $tmpa, $tmpa, $tmpa, $lastposttime) = split(/\|/, $_);
		if( $mnuma ) {
			fopen(FILE, "$datadir/$mnuma.data");
			$tmpa = <FILE>;
			fclose(FILE);
			($tmpa, $lastposter) = split(/\|/, $tmpa);
		}
		else {
			$lastposttime = 'N/A';
			$lastposter = 'N/A';
		}
	}
	&BoardCountSet( $currentboard, $threadcount, $messagecount, $lastposttime, $lastposter );

	fopen(FILE, "$boardsdir/$toboard.txt") || &fatal_error("$txt{'23'} $toboard.txt");
	@threads = <FILE>;
	fclose(FILE);

	for ($a = 0; $a < @threads; $a++) {
		$_ = $threads[$a];
		chomp;
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$_);
		$mtime = stringtotime($mdate);
		if ($mobiletime >= $mtime) { last; }
	}

	( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($toboard);
	++$threadcount;
	$messagecount += $mobileposts;
	if( $a == 0 ) {
		if( $mobilenum ) {
			fopen(FILE, "$datadir/$mobilenum.data");
			$tmpa = <FILE>;
			fclose(FILE);
			($tmpa, $lastposter) = split(/\|/, $tmpa);
			$lastposttime = $mobiledate;
		}
		else {
			$lastposttime = 'N/A';
			$lastposter = 'N/A';
		}
	}
	$threads[$a] = "$yyThreadLine\n$threads[$a]";
	&BoardCountSet( $toboard, $threadcount, $messagecount, $lastposttime, $lastposter );

	fopen(FILE, ">$boardsdir/$toboard.txt", 1) || &fatal_error("$txt{'23'} $toboard.txt");
	print FILE @threads;
	fclose(FILE);

	$yySetLocation = qq~$scripturl?board=$toboard&action=display&num=$thread&start=0~;
	&redirectexit;
}

1;