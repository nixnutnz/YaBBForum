###############################################################################
# Admin.pl                                                                    #
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

$adminplver = "1 Gold - SP 1.1";

sub Admin {
	&is_admin;

	# Load data for the 'remove old messages' feature, get totals, and get moderators
	fopen(FILE, "$vardir/oldestmes.txt");
	$maxdays = <FILE>;
	fclose(FILE);

	$yymain .= qq~
<map NAME="egg">
<AREA SHAPE="poly" COORDS="33,63,37,60,44,60,45,62,39,64" HREF="http://yabb.xnull.com/01g.php">
</MAP>
<table border="0" cellpadding="0" cellspacing="0" align="center" width="100%">
  <tr>
    <td valign="top" colspan="3" align="center">
    <table border="0" cellpadding="4" cellspacing="1" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
        <td bgcolor="$color{'titlebg'}" height="24" class="titlebg" align="center"><font size="3"><B>$txt{'208'}</B></font></td>
      </tr>
    </table>
    </td>
  </tr><tr>
    <td valign="top"><BR>
    <table border="0" cellpadding="4" cellspacing="1" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
        <td bgcolor="$color{'catbg'}" height="19" class="catbg"><img src="$imagesdir/board.gif" alt="" border="0"> <font size="2"><b>$txt{'428'}</b></font></td>
      </tr><tr>
        <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="1">
        - <a href="$cgi;action=modsettings">$txt{'222'}</a><br>
        - <a href="$cgi;action=editnews">$txt{'7'}</a><br>
        - <a href="$cgi;action=modtemp">$txt{'216'}</a><br>
        - <a href="$cgi;action=modagreement">$txt{'764'}</a><br>
        - <a href="$cgi;action=setcensor">$txt{'135'}</a>
        </font></td>
      </tr>
    </table><BR>
    <table border="0" cellpadding="4" cellspacing="1" bgcolor="#6394BD" class="bordercolor" width="100%">
      <tr>
        <td bgcolor="$color{'catbg'}" height="19" class="catbg"><img src="$imagesdir/board.gif" alt="" border="0"> <font size="2"><b>$txt{'427'}</b></font></td>
      </tr><tr>
        <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="1">
        - <a href="$cgi;action=managecats">$txt{'3'}</a><br>
        - <a href="$cgi;action=manageboards">$txt{'4'}</a>
        </font></td>
      </tr>
    </table><BR>
    <table border="0" cellpadding="4" cellspacing="1" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
        <td bgcolor="$color{'catbg'}" height="19" class="catbg"><img src="$imagesdir/board.gif" alt="" border="0"> <font size="2"><b>$txt{'426'}</b></font></td>
      </tr><tr>
        <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="1">
        - <a href="$cgi;action=viewmembers">$txt{'5'}</a><br>
        - <a href="$cgi;action=modmemgr">$txt{'8'}</a><br>
        - <a href="$cgi;action=mailing">$txt{'6'}</a><br>
        - <a href="$cgi;action=ipban">$txt{'206'}</a><br>
        - <a href="$cgi;action=setreserve">$txt{'207'}</a>
        </font></td>
      </tr>
    </table><BR>
    <table border="0" cellpadding="4" cellspacing="1" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
        <td bgcolor="$color{'catbg'}" height="19" class="catbg"><img src="$imagesdir/board.gif" alt="" border="0"> <font size="2"><b>$txt{'501'}</b></td>
      </tr><tr>
        <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="1">
        - <a href="$cgi;action=clean_log">$txt{'202'}</a><br>
        - <a href="$cgi;action=boardrecount">$txt{'502'}</a><br>
        - <a href="$cgi;action=membershiprecount">$txt{'504'}</a><br>
        - <a href="$cgi;action=rebuildmemlist">$txt{'593'}</a><BR>
        - <font size="1">($txt{'595'})</font>
        <form action="$cgi;action=removeoldthreads" method="POST">
        $txt{'124'} <input type=text name="maxdays" size="2" value="$maxdays"> $txt{'579'}
        <input type=submit value="$txt{'31'}"></form>
        </font></td>
      </tr>
    </table>
    </td>
    <td width="6">&nbsp;</td>
    <td valign="top"><BR>
    <table border="0" cellpadding="5" cellspacing="1" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
        <td class="windowbg2" bgcolor="$color{'windowbg2'}" width="100%">
        <table width="100%" cellpadding="4">
          <tr>
            <td class="windowbg2" bgcolor="$color{'windowbg2'}" valign="middle" align="center" width="50"><img src="$imagesdir/administrator.gif" border="0" alt="" usemap="#egg"></td>
            <td class="windowbg2" bgcolor="$color{'windowbg2'}">
            <font size="1"><B>$txt{'248'} $settings[1] ($username)!</B><BR><BR>
            $txt{'644'}</font></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    <BR>
    <table border="0" cellpadding="5" cellspacing="1" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
	<td class="catbg" bgcolor="$color{'catbg'}" colspan="2"><img src="$imagesdir/info.gif" alt="" border="0"> <font size="2"><B>$txt{'645'}</B></font></td>
      </tr><tr>
        <td class="windowbg2" bgcolor="$color{'windowbg2'}" colspan="2"><font size="1">
        <a href="$scripturl?action=stats">$txt{'795'}</a><BR>
        <a href="$scripturl?action=showclicks">$txt{'693'}</a>
        <BR><b>$txt{'425'}:</b> $YaBBversion/<img src="http://yabb.xnull.com/images/versioninfo/versioncheck.gif">
        <BR>(<a href="$cgi;action=detailedversion">$txt{'429'}</a>)
        </font></td>
      </tr>
    </table><BR>
    <table border="0" cellpadding="5" cellspacing="1" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
	<td class="catbg" bgcolor="$color{'catbg'}" colspan="2"><img src="$imagesdir/info.gif" alt="" border="0"> <font size="2"><B>$txt{'571'}</B></font></td>
      </tr><tr>
        <td class="windowbg2" bgcolor="$color{'windowbg2'}" colspan="2">
        <font size="1"><BR><i><B>Service Pack l:</B></i> Special thanks to Corey Chapman, Bjoern Berg, Dave Baughman, Tim
        Ceuppens, Jay Silverman and Gunther Meyer.
        <BR><BR><i><B>YaBB 1 Gold:</B></i> Corey Chapman, Darya Misse, Popeye, Michael Prager, Dave Baughman,
        Dave G, Carey P, Christian Land, Tim Ceuppens, ejdmoo, StarSaber, Parham and the rest for helping out with
        graphics, code and other things :-)
        <BR><BR><i><B>YaBB 1 Final:</B></i> Zef Hemel, Jeff Lewis, Christian Land, Corey Chapman, Peter Crouch
        and a bunch of others we want to thank!</font>
        </font></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
~;
	$yytitle = "$txt{'208'}";
	&template;
	exit;
}

sub FullStats {
	&is_admin;
	my($numcats, $numboards, @categories, @catboards, @curcataccess, $curcat, $curcatname, $curcataccess, $curboard, $threadcount, $messagecount, $maxdays, $totalt, $totalm, $avgt, $avgm);
	my($memcount, $latestmember) = &MembershipGet;
	&LoadUser($latestmember);
	$thelatestmember = qq~<font size="2"><B>$txt{'656'}</B></font> <font size="1"><a href="$scripturl?action=viewprofile;username=$useraccount{$latestmember}">$userprofile{$latestmember}->[1]</a></font>~;
	$memcount ||= 1;

	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);
	$numcats = @categories; # get the number of categories
	foreach $curcat (@categories) {
		chomp $curcat;
		fopen(CATFILE, "$boardsdir/$curcat.cat");
		$curcatname = <CATFILE>;
		$curcataccess = <CATFILE>;
		@catboards = <CATFILE>;
		fclose(CATFILE);
		chomp $curcatname;
		chomp $curcataccess;
		$yyAccessCat{$curcat} = $settings[7] eq 'Administrator' || $moderators{$username} || ! $curcataccess;
		unless( $yyAccessCat{$curcat} ) {
			foreach ( split(/\,/, $curcataccess) ) {
				if( $_ && $_ eq $settings[7] ) { $yyAccessCat{$curcat} = 1; last; }
			}
		}
		foreach $curboard (@catboards) {
			chomp $curboard;
			$numboards++;
			( $threadcount, $messagecount ) = &BoardCountGet($curboard);
			$totalt += $threadcount;
			$totalm += $messagecount;
		}
	}
	$avgt = $totalt / $memcount;
	$avgm = $totalm / $memcount;
	&LoadAdmins;
	&LoadLogCount;

	$yymain .= qq~
<table border="0" width="70%" cellspacing="1" cellpadding="3" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <img src="$imagesdir/info.gif" alt="">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'645'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><img src="$imagesdir/cat.gif" alt="" border="0"> <font size="2"><B>$txt{'94'}</B></font></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2">
    <table border="0" cellpadding="3" cellspacing="0">
      <tr>
        <td><font size="2"><b>$txt{'488'}</b></font></td>
        <td><font size="1">$memcount</font></td>
      </tr><tr>
        <td><font size="2"><b>$txt{'489'}</b></font></td>
        <td><font size="1">$totalm</font><BR></td>
      </tr><tr>
        <td><font size="2"><b>$txt{'490'}</b></font></td>
        <td><font size="1">$totalt</font></td>
      </tr><tr>
        <td><font size="2"><b>$txt{'658'}</b></font></td>
        <td><font size="1">$numcats</font></td>
      </tr><tr>
        <td><font size="2"><b>$txt{'665'}</b></font></td>
        <td><font size="1">$numboards</font></td>
      </tr><tr>
        <td><font size="2"><b>$txt{'691'} <font size="1">($txt{'692'})</font>:</b></font></td>
        <td><font size="1">$yyclicks</font> &nbsp;<font size="2">(<a href="$scripturl?action=showclicks">$txt{'693'}</a>)</font></td>
      </tr>
    </table>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg'}" class="windowbg" height="21">
    <img src="$imagesdir/cat.gif" alt="" border="0"> <font size="2"><B>$txt{'657'}</B></font><BR></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2">
    $thelatestmember<BR>
    <font size="2"><B>$txt{'659'}</b></font><font size="1">
~;
	require "$sourcedir/Recent.pl";
	$recentsender = "admin";
	&LastPost;
	$yymain .= qq~
    </font><BR><BR>
    <font size="2"><B>$txt{'684'}:</B></font> <font size="1">$administrators</font><BR><BR>
    <font size="2"><b>$txt{'425'}:</b></font>
    <font size="1">$YaBBversion</font>/<img src="http://yabb.xnull.com/images/versioninfo/versioncheck.gif">
    <BR><font size="2">(<a href="$cgi;action=detailedversion">$txt{'429'}</a>)</font></center><BR></td>
  </tr>
</table>~;
	$yytitle = "$txt{'208'}";
	&template;
	exit;
}

sub ShowClickLog {
	&is_admin;
	my($totalip,$totalclick,$totalbrow,$totalos,@log,@iplist,$date,@to,@from,@info,@os,@browser,@newiplist,@newbrowser,@newoslist,@newtolist,@newfromlist,$i,$curentry);
	fopen(LOG, "$vardir/clicklog.txt");
	@log = <LOG>;
	fclose(LOG);

	$i = 0;
	foreach $curentry (@log) {
		($iplist[$i],$date,$to[$i],$from[$i],$info[$i]) = split(/\|/, $curentry);
		$i++;
	}
	$i = 0;
	foreach $curentry (@info) {
		if ($curentry !~ /\s\(Win/i || $curentry !~ /\s\(mac/) { $curentry =~ s/\s\((compatible;\s)*/ - /ig; }
		else { $curentry =~ s/(\S)*\(/; /g; }
		if ($curentry =~ /\s-\sWin/i) { $curentry =~ s/\s-\sWin/; win/ig; }
		if ($curentry =~ /\s-\sMac/i) { $curentry =~ s/\s-\sMac/; mac/ig; }
		($browser[$i],$os[$i]) = split(/\;\s/, $curentry);
		if($os[$i] =~ /\)\s\S/) { ($os[$i],$browser[$i]) = split(/\)\s/, $os[$i]); }
		$os[$i] =~ s/\)//g;
		$i++;
	}

	$yymain .= qq~
<table border=0 cellspacing=1 cellpadding="5" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td bgcolor="$color{'titlebg'}" class="titlebg">
    <img src="$imagesdir/info.gif" alt="" border="0">&nbsp;
    <font size=2 color="$color{'titletext'}"><b>$txt{'693'}</b></font></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg'}" class="windowbg">
    <BR><font size="1">$txt{'697'}</font><BR><BR></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>$txt{'694'}</B></center></font>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
~;
for($i = 0; $i < @iplist; $i++) { $iplist{$iplist[$i]}++; }
$i = 0;
while(($key, $val ) = each(%iplist)) {
	$newiplist[$i] = [ $key, $val ];
	$i++;
}
$totalclick = @iplist;
$totalip = @newiplist;
$yymain .=  qq~<i>$txt{'742'}: $totalclick</i><BR>~;
$yymain .=  qq~<i>$txt{'743'}: $totalip</i><BR><BR>~;
for($i = 0; $i < @newiplist; $i++) {
	if($newiplist[$i]->[0] =~ /\S+/) { $yymain .= "$newiplist[$i]->[0] &nbsp;(<i>$newiplist[$i]->[1]</i>)<BR>\n"; }
}
$yymain .= qq~
    </font></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>$txt{'695'}</B>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
~;
for($i = 0; $i < @browser; $i++) { $browser{$browser[$i]}++; }
$i = 0;
while(($key, $val ) = each(%browser)) {
	$newbrowser[$i] = [ $key, $val ];
	$i++;
}
$totalbrow = @newbrowser;
$yymain .=  qq~<i>$txt{'744'}: $totalbrow</i><BR><BR>~;
for($i = 0; $i < @newbrowser; $i++) {
	if($newbrowser[$i]->[0] =~ /\S+/) { $yymain .= "$newbrowser[$i]->[0] &nbsp;(<i>$newbrowser[$i]->[1]</i>)<BR>\n"; }
}
$yymain .= qq~
    </font></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>$txt{'696'}</B>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
~;
for($i = 0; $i < @os; $i++) { $os{$os[$i]}++; }
$i = 0;
while(($key, $val ) = each(%os) ) {
	$newoslist[$i] = [ $key, $val ];
	$i++;
}
$totalos = @newoslist;
$yymain .=  qq~<i>$txt{'745'}: $totalos</i><BR><BR>~;
for($i = 0; $i < @newoslist; $i++) {
	if($newoslist[$i]->[0] =~ /\S+/) { $yymain .= "$newoslist[$i]->[0] &nbsp;(<i>$newoslist[$i]->[1]</i>)<BR>\n"; }
}
$yymain .= qq~
    </font></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>Pages Visited</B>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
~;
for($i = 0; $i < @to; $i++) { $to{$to[$i]}++; }
$i = 0;
while(($key, $val ) = each(%to)) {
	$newtolist[$i] = [ $key, $val ];
	$i++;
}
for($i = 0; $i < @newtolist; $i++) {
	if($newtolist[$i]->[0] =~ /\S+/) { $yymain .= "<a href=$newtolist[$i]->[0] target=_blank>$newtolist[$i]->[0]</a> &nbsp;(<i>$newtolist[$i]->[1]</i>)<BR>\n"; }
}
$yymain .= qq~
    </font></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>Referring Pages</B>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
~;
for($i = 0; $i < @from; $i++) { $from{$from[$i]}++; }
$i = 0;
while(($key, $val ) = each(%from)) {
	$newfromlist[$i] = [ $key, $val ];
	$i++;
}
for($i = 0; $i < @newfromlist; $i++) {
	if($newfromlist[$i]->[0] =~ /\S+/ && $newfromlist[$i]->[0] !~ m~$boardurl~i) { $yymain .= "<a href=$newfromlist[$i]->[0] target=_blank>$newfromlist[$i]->[0]</a> &nbsp;(<i>$newfromlist[$i]->[1]</i>)<BR>\n"; }
}
$yymain .= qq~
    </font></td>
  </tr>
</table>
~;
	$yytitle = $txt{'693'};
	&template;
	exit;
}

sub AdminMembershipRecount {
	&is_admin;
	&MembershipCountTotal;
	$yymain .= qq~<b>$txt{'505'}</b>~;
	$yytitle = $txt{'504'};
	&template;
	exit;
}

sub AdminBoardRecount {
	&is_admin;
	my( $curcat, $curcatname, $curcataccess );
	my( @categories, @catboards );
	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);
	foreach $curcat (@categories) {
		chomp $curcat;
		fopen(FILE, "$boardsdir/$curcat.cat");
		chomp( $curcatname = <FILE> );
		chomp( $curcataccess = <FILE> );
		@catboards = <FILE>;
		fclose(FILE);
		foreach (@catboards) {
			chomp;
			&BoardCountTotals($_);
		}
	}
	$yymain .= qq~<b>$txt{'503'}</b>~;
	$yytitle = $txt{'502'};
	&template;
	exit;
}

sub RebuildMemList {
	&is_admin;
	opendir(DIR, "$memberdir") || die "$txt{'230'} ($memberdir) :: $!";
	@contents = readdir(DIR);
	closedir(DIR);
	fopen(MEMLIST, ">$memberdir/memberlist.txt", 1);
	foreach $line (sort @contents){
		$line =~ m~(.+)\.(.+)~;
		if ($2 eq 'dat'){ print MEMLIST "$1\n"; }
	}
	fclose(MEMLIST);
	$yymain .= qq~<b>$txt{'594'}</b>~;
	$yytitle = "$txt{'593'}";
	&template;
	exit;
}

sub ViewMembers {
	&is_admin;
	# Load member list
	fopen(FILE, "$memberdir/memberlist.txt");
	@memberlist = <FILE>;
	fclose(FILE);
	$yymain .= qq~
<table border=0 width="300" cellspacing=1 cellpadding="2" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <img src="$imagesdir/guest.gif" alt="" border="0">&nbsp;
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'9'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" align="left" width="95%">
    <form action="$cgi;action=deletemultimembers" method="POST">
    <table border=0 cellspacing="4" cellspacing="0" align="center" width="95%">
~;
	$count = 0;
	foreach $curmem (@memberlist) {
		$curmem =~ s/[\n\r]//g;
		&FormatUserName($curmem);
                if ($curmem eq "admin") {
			$yymain .= qq~      <tr>\n        <td><font size=2><a href="$cgi;action=viewprofile;username=$useraccount{$curmem}">$curmem</a></font></td><td> &nbsp;&nbsp;</td>\n      </tr>\n~;
		} else {
			$yymain .= qq~      <tr>\n        <td><font size=2><a href="$cgi;action=viewprofile;username=$useraccount{$curmem}">$curmem</a></font></td><td> &nbsp;&nbsp;<input type="checkbox" name="member$count" value="$curmem"></td>\n      </tr>\n~;
		}
		$count++;
	}
	$yymain .= qq~
    </table>
    </td>
  </tr><tr>
	<td class="windowbg" bgcolor="$color{'windowbg'}" align="center"><input type=submit value="$txt{'608'}"></td>
  </tr>
</table>
</form>
~;
	$yytitle = "$txt{'9'}";
	&template;
	exit;
}

sub DeleteMultiMembers {
&is_admin;
my($count, $memnum, $currentmem);

fopen(FILE, "$memberdir/memberlist.txt");
@memnum = <FILE>;
fclose(FILE);

$count = 0;
while (@memnum > $count) {
$currentmem = $FORM{"member$count"};
if (exists $FORM{"member$count"}) {
	fopen(FILE, "$memberdir/$currentmem.dat");
	@memsettings=<FILE>;
	fclose(FILE);
	foreach (@memsettings) {
		$_ =~ s~[\n\r]~~g;
	}

	unlink("$memberdir/$currentmem.dat");
	unlink("$memberdir/$currentmem.msg");
	unlink("$memberdir/$currentmem.log");
	unlink("$memberdir/$currentmem.outbox");
	unlink("$memberdir/$currentmem.imconfig");

	opendir (DIRECTORY,"$datadir");
	@dirdata = readdir(DIRECTORY);
	closedir (DIRECTORY);
	$umail = $memsettings[2];

	foreach $filename (@dirdata) {
		unless( $filename =~ m~mail\A~ ) { next; }
		fopen(FILE, "$datadir/$filename");
		@entries = <FILE>;
		fclose(FILE);

		fopen(FILE, ">$datadir/$filename");
		foreach $entry (@entries) {
			$entry =~ s/[\n\r]//g;
			if ($entry ne $umail) {
				print FILE "$entry\n";
			}
		}
		fclose(FILE);

	}

	fopen(FILE, "$memberdir/memberlist.txt");
	@members = <FILE>;
	fclose(FILE);
	fopen(FILE, ">$memberdir/memberlist.txt", 1);
	my $memberfound = 0;
	my $lastvalidmember = '';
	foreach $curmem (@members) {
		chomp $curmem;
		if($curmem ne $currentmem) { print FILE "$curmem\n"; $lastvalidmember = $curmem; }
		else { ++$memberfound; }
	}
	fclose(FILE);
	my $membershiptotal = @members - $memberfound;
	fopen(FILE, "+>$memberdir/members.ttl");
	print FILE qq~$membershiptotal|$lastvalidmember~;
	fclose(FILE);

	# For security, remove username from mod position
	fopen(FILE, "$vardir/cat.txt"); @categories = <FILE>; fclose(FILE);

	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		fopen(CAT, "$boardsdir/$curcat.cat"); @catinfo = <CAT>; fclose(CAT);

		foreach $curboard (@catinfo) {
				$curboard =~ s/[\n\r]//g; chomp $curboard;

				fopen(BOARD, "$boardsdir/$curboard.dat"); @boardinfo = <BOARD>; fclose(BOARD);

				$boardinfo[2] =~ s/[\n\r]//g; $boardinfo[2] =~ /^\|(.*?)\|$/;
				$mods = $1 or $mods = $boardinfo[2];
				$mods =~ s/\|(\S?)/,$1/g;

				$mods_changed=0;
				if($currentmem && $mods =~ /(,*)$currentmem(,*)/g) {$mods =~ s~(,*)$currentmem(,*)~~; $mods_changed=1;}

				if ($mods_changed == 1)
				{
					$boardinfo[2] = $mods;
					fopen(BOARD, ">$boardsdir/$curboard.dat", 1);
					print BOARD @boardinfo;
					fclose(BOARD);
				}
		}
	}
}
	$count++;
}

$yySetLocation = qq~$scripturl?action=viewmembers~;
&redirectexit;
}

sub MailingList {
	&is_admin;
	fopen(FILE, "$memberdir/memberlist.txt");
	@memberlist = <FILE>;
	fclose(FILE);
	$yymain .= qq~
<table border="0" width="600" cellspacing="1" cellpadding="4" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    &nbsp;<img src="$imagesdir/email.gif" alt="" border="0">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'6'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}">
    <BR><font size="1">$txt{'735'}</font><BR><BR></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}">
    <form action="$cgi;action=ml" method="POST">
    <textarea cols="70" rows="7" name="emails">
~;
	foreach $curmem (@memberlist) {
		$curmem =~ s/[\n\r]//g;
		fopen(FILE, "$memberdir/$curmem.dat");
		@memsettings = <FILE>;
		fclose(FILE);
		$email = $memsettings[2];
		$email =~ tr/\r//d;
		$email =~ tr/\n//d;
		$yymain .= "$email; ";
	}
	$yymain .= qq~
</textarea><BR><BR></td>
  </tr><tr>
    <td bgcolor="$color{'titlebg'}"><font size=2 color="$color{'titletext'}"><b>$txt{'338'}</b></font></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2">
    <input type=text name="subject" size=30 value="$txt{'70'}"><br><br>
    <textarea cols=70 rows=9 name=message>$txt{'72'}</textarea><br><br>
    <center><input type=submit value="$txt{'339'}"></center></form></td>
  </tr>
</table>
~;
	$yytitle = "$txt{'6'}";
	&template;
	exit;
}

sub ml {
	$FORM{'emails'} = "; " . $FORM{'emails'};
	@emails = split(/;\s*/, $FORM{'emails'});
	foreach $curmem (@emails) {
		&sendmail( $curmem, "$mbname: $FORM{'subject'}", "$FORM{'message'}\n\n$txt{'130'}\n\n$scripturl");
	}
	$yySetLocation = qq~$cgi;action=admin~;
	&redirectexit;
}

sub clean_log {
	&is_admin;
	$yymain .= qq~
<table border="0" width="90%" cellspacing=1 cellpadding="3" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'202'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>$txt{'203'}
    <a href="$cgi;action=do_clean_log">$txt{'163'}</a>&nbsp;&nbsp;<a href="$scripturl?action=admin">$txt{'164'}</a><br>
    </font></td>
  </tr>
</table>
~;
	$yytitle = $txt{'202'};
	&template;
	exit;
}

sub do_clean_log {
	&is_admin;
	# Overwrite with a blank file
	fopen(FILE, ">$vardir/log.txt");
	print FILE '';
	fclose(FILE);
	&Admin;
}

sub ipban {
	&is_admin;
	my( @ipban, @emailban, $curban );
	fopen(FILE, "$vardir/ban.txt");
	@ipban = <FILE>;
	fclose(FILE);
	fopen(FILE, "$vardir/ban_email.txt");
	@emailban = <FILE>;
	fclose(FILE);
	fopen(FILE, "$vardir/ban_memname.txt");
	@memnameban = <FILE>;
	fclose(FILE);
	$yymain .= qq~
<table border="0" cellspacing="1" cellpadding="4" align="center" width="550">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <img src="$imagesdir/ban.gif" alt="" border="0">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'340'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" align="center">
    <font size="2"><form action="$cgi;action=ipban2" method="POST">
    <BR>$txt{'724'}<br>
    <textarea cols="60" rows="6" name="ban">
~;
	foreach $curban (@ipban) {
		chomp $curban;
		if( $curban =~ m~\A\s+\Z~  ) { next; }
		$yymain .= "$curban\n";
	}
	$yymain .= qq~</textarea><br><br>
    $txt{'725'}<br>
    <textarea cols=60 rows=6 name="ban_email">
~;
	foreach $curban (@emailban) {
		chomp $curban;
		if( $curban =~ m~\A\s+\Z~  ) { next; }
		$yymain .= "$curban\n";
	}
	$yymain .= qq~</textarea><br><BR>
    $txt{'725a'}<br>
    <textarea cols=60 rows=6 name="ban_memname">
~;
	foreach $curban (@memnameban) {
		chomp $curban;
		if( $curban =~ m~\A\s+\Z~  ) { next; }
		$yymain .= "$curban\n";
	}
	$yymain .= qq~</textarea><br><BR>
    <input type=submit value="$txt{'10'}">
    </form></font></td>
  </tr>
</table>
~;
	$yytitle = "$txt{'340'}";
	&template;
	exit;
}

sub ipban2 {
	&is_admin;
	$FORM{'ban'} =~ tr/\r//d;
	$FORM{'ban'} =~ s~\A[\s\n]+~~;
	$FORM{'ban'} =~ s~[\s\n]+\Z~~;
	$FORM{'ban'} =~ s~\n\s*\n~\n~g;
	$FORM{'ban_email'} =~ tr/\r//d;
	$FORM{'ban_email'} =~ s~\A[\s\n]+~~;
	$FORM{'ban_email'} =~ s~[\s\n]+\Z~~;
	$FORM{'ban_email'} =~ s~\n\s*\n~\n~g;
	$FORM{'ban_memname'} =~ tr/\r//d;
	$FORM{'ban_memname'} =~ s~\A[\s\n]+~~;
	$FORM{'ban_memname'} =~ s~[\s\n]+\Z~~;
	$FORM{'ban_memname'} =~ s~\n\s*\n~\n~g;

	fopen(FILE, ">$vardir/ban.txt", 1);
	print FILE "$FORM{'ban'}";
	fclose(FILE);
	fopen(FILE, ">$vardir/ban_email.txt", 1);
	print FILE "$FORM{'ban_email'}";
	fclose(FILE);
	fopen(FILE, ">$vardir/ban_memname.txt", 1);
	print FILE "$FORM{'ban_memname'}";
	fclose(FILE);
	$yySetLocation = qq~$cgi;action=admin~;
	&redirectexit;
}

sub ver_detail {
	&is_admin;
	&loadfiles;
	$yymain .= qq~
<table border="0" width="70%" cellspacing=1 bgcolor="$color{'titlebg'}" align="center">
  <tr>
    <td bgcolor="$color{'titlebg'}"><img src="$imagesdir/info.gif" alt="" border="0">&nbsp;<font size=2 color="$color{'titletext'}"><b>$txt{'429'}</b></font></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg'}" align="center"><P>
    <table border="0" bgcolor="$color{'windowbg'}" class="windowbg">
      <tr>
        <td width="30%"><font size=2><B>$txt{'495'}</B><BR><BR></td>
        <td><font size=2><B>$txt{'494'}</B><BR><BR></td>
        <td><font size=2><B>$txt{'493'}</B><BR><BR></td>
      </tr><tr>
        <td width="30%"><font size=2>$txt{'496'}</td><td><font size=2><i>$YaBBversion</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/versioncheck.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>YaBB.$yyext</td><td><font size=2><i>$YaBBplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/yabbplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>$language</td><td><font size=2><i>$englishlngver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/englishlngver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Admin.pl</td><td><font size=2><i>$adminplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/adminplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>AdminEdit.pl</td><td><font size=2><i>$admineditplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/admineditplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>BoardIndex.pl</td><td><font size=2><i>$boardindexplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/boardindexplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Display.pl</td><td><font size=2><i>$displayplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/displayplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>ICQPager.pl</td><td><font size=2><i>$icqpagerplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/icqpagerplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>InstantMessage.pl</td><td><font size=2><i>$instantmessageplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/instantmessageplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Load.pl</td><td><font size=2><i>$loadplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/loadplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>LockThread.pl</td><td><font size=2><i>$lockthreadplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/lockthreadplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>LogInOut.pl</td><td><font size=2><i>$loginoutplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/loginoutplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Maintenance.pl</td><td><font size=2><i>$maintenanceplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/maintenanceplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>ManageBoards.pl</td><td><font size=2><i>$manageboardsplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/manageboardsplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>ManageCats.pl</td><td><font size=2><i>$managecatsplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/managecatsplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Memberlist.pl</td><td><font size=2><i>$memberlistplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/memberlistplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>MessageIndex.pl</td><td><font size=2><i>$messageindexplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/messageindexplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>ModifyMessage.pl</td><td><font size=2><i>$modifymessageplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/modifymessageplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>MoveThread.pl</td><td><font size=2><i>$movethreadplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/movethreadplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Notify.pl</td><td><font size=2><i>$notifyplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/notifyplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Post.pl</td><td><font size=2><i>$postplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/postplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Printpage.pl</td><td><font size=2><i>$printplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/printplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Profile.pl</td><td><font size=2><i>$profileplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/profileplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Recent.pl</td><td><font size=2><i>$recentplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/recentplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Register.pl</td><td><font size=2><i>$registerplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/registerplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>RemoveOldThreads.pl</td><td><font size=2><i>$removeoldthreadsplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/removeoldthreadsplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>RemoveThread.pl</td><td><font size=2><i>$removethreadplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/removethreadplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Search.pl</td><td><font size=2><i>$searchplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/searchplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>SendTopic.pl</td><td><font size=2><i>$sendtopicplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/sendtopicplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Security.pl</td><td><font size=2><i>$securityplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/securityplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Subs.pl</td><td><font size=2><i>$subsplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/subsplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>YaBBC.pl</td><td><font size=2><i>$yabbcplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/yabbcplver.gif"></td>
      </tr>
    </table>
    </font></td>
  </tr>
</table>
~;
	$yytitle = $txt{'429'};
	&template;
	exit;
}

1;