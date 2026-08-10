###############################################################################
# BoardIndex.pl                                                               #
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

$boardindexplver="1 Gold - Release";

sub BoardIndex {
	# Open the file with all categories
	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);

	my( $memcount, $latestmember ) = &MembershipGet;
	&LoadUser($latestmember);
	$thelatestmember = qq~$txt{'201'} <a href="$scripturl?action=viewprofile&username=$useraccount{$latestmember}"><b>$userprofile{$latestmember}->[1]</b></a>$txt{'581'}~;
	$totalm = 0;
	$totalt = 0;

	for( $catnum = 0; $catnum < @categories; $catnum++ ) {
		chomp $categories[$catnum];
		$curcat = $categories[$catnum];
		fopen(FILE, "$boardsdir/$curcat.cat");
		$catname{$curcat} = <FILE>;
		chomp $catname{$curcat};
		$cataccess{$curcat} = <FILE>;
		chomp $cataccess{$curcat};
		@{$catboards{$curcat}} = <FILE>;
		fclose(FILE);
		@membergroups = split( /,/, $cataccess{$curcat} );
		$openmemgr{$curcat} = 0;
		foreach $tmpa (@membergroups) {
			if( $tmpa eq $settings[7]) { $openmemgr{$curcat} = 1; last; }
		}
		if( ! $cataccess{$curcat} || $settings[7] eq 'Administrator' ) {
			$openmemgr{$curcat} = 1;
		}
		unless( $openmemgr{$curcat} ) { next; }
		foreach $curboard (@{$catboards{$curcat}}) {
			chomp $curboard;
			( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($curboard);
			$lastposttime{$curboard} = $lastposttime eq 'N/A' || ! $lastposttime ? $txt{'470'} : &timeformat($lastposttime);
			$lastpostrealtime{$curboard} = $lastposttime eq 'N/A' || ! $lastposttime ? '' : $lastposttime;
			if( $lastposter =~ m~\AGuest-(.*)~ ) {
				$lastposter = $1;
				$lastposterguest{$curboard} = 1;
			}
			$lastposter{$curboard} = $lastposter eq 'N/A' || ! $lastposter ? $txt{'470'} : $lastposter;
			$messagecount{$curboard} = $messagecount || 0;
			$threadcount{$curboard} = $threadcount || 0;
			$totalm += $messagecount;
			$totalt += $threadcount;
		}
	}
	$yytitle = "$txt{'18'}";
	&header;
	$curforumurl = $curposlinks ? qq~<a href="$scripturl" class="nav">$mbname</a>~ : $mbname;
	print <<"EOT";
<table width="100%" align="center">
  <tr>
    <td valign=bottom><font size="2" class="nav"><IMG SRC="$imagesdir/open.gif" BORDER=0> <b>$curforumurl</b></font></td>
    <td align=right><font size=2>$txt{'19'}: $memcount &nbsp;&#149;&nbsp; $txt{'95'} $totalm &nbsp;&#149;&nbsp; $txt{'64'} $totalt
EOT
	if ($showlatestmember == 1) {
		print <<"EOT";
	<br>$thelatestmember</font>
EOT
	}
	print <<"EOT";
    </td>
  </tr>
</table>
EOT

	if($shownewsfader == 1) {
		if(!$fadertime) { $fadertime = 5; }
		print <<"EOT";
<table border=0 width="100%" cellspacing="1" cellpadding="5" bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td bgcolor="$color{'titlebg'}" class="titlebg" align="center">
    <font class="text1" color="$color{'titletext'}" size="2"><b>$txt{'102'}</b></font></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" valign="middle" align="center" height="60">
    <SCRIPT LANGUAGE="JavaScript1.2" TYPE="text/javascript">
    <!--
    FDRboxWid = 590;
    FDRboxHgt = 50;
    FDRbackCol = "$color{'windowbg2'}";
    FDRborWid = 0;
    FDRborSty = "solid";
    FDRborCol = "$color{'windowbg2'}";
    FDRboxPad = 4;

    FDRtxtAln = "center";
    FDRlinHgt = "11pt";
    FDRfntFam = "Verdana";
    FDRfntCol = "$color{'fadertext2'}";
    FDRfntSiz = "10pt";
    FDRfntWgh = "bold";
    FDRfntSty = "normal";
    FDRlnkDec = "underline";
    FDRlnkCol = "#000080";
    FDRhovCol = "#800000";

    FDRblendInt = $fadertime;
    FDRblendDur = 1;
    FDRmaxLoops = 100;

    FDRendWithFirst = false;
    FDRreplayOnClick = true;
    FDRjustFlip = false;
    FDRhdlineCount = 1;

    FDRgifSrc = "$imagesdir/fade.gif";
    FDRgifInt = 10;
    //-->
    </SCRIPT>
    <SCRIPT LANGUAGE='JavaScript1.2' TYPE='text/javascript'>
    prefix="";
    arNews = [
EOT
	for($i=0;$i<@newsmessages;$i++) {
		$newsmessages[$i] =~ s/\n//g;
		$newsmessages[$i] =~ s/\r//g;
		if($i != 0)
		{print ",\n";}
		$message = $newsmessages[$i];
		if($enable_ubbc) {
			&MakeSmileys;
			$sender = 'News';
			&DoUBBC;
		}
		$message =~ s/\"/\\\"/g;
		print qq~"$message",""~;
	}
	print <<"EOT";
    ]
    </SCRIPT>
    <SCRIPT LANGUAGE="JavaScript1.2" src="$faderpath" TYPE="text/javascript"></SCRIPT>
    <div align="center"><div id="elFader" style="position:relative; visibility:hidden; width:100%;">
    <font face="Verdana, Arial" size=2>YaBB News Fader</font>
    </div></div>
    </td>
  </tr>
</table>
EOT
	}
	print <<"EOT";
<table border=0 width="100%" cellspacing="1" cellpadding="5" bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}" colspan="2"><font class="text1" color="$color{'titletext'}" size="2"><b>$txt{'20'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}" width="1%" align="center"><font class="text1" color="$color{'titletext'}" size="2"><b>$txt{'330'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}" width="1%" align="center"><font class="text1" color="$color{'titletext'}" size="2"><b>$txt{'21'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}" width="23%" align="center"><font class="text1" color="$color{'titletext'}" size="2"><b>$txt{'22'}</b></font></td>
  </tr>
EOT

	foreach $curcat (@categories) {
		unless( $openmemgr{$curcat} ) { next; }
		print <<"EOT";
  <tr>
    <td colspan="5" class="catbg" bgcolor="$color{'catbg'}" height="18"><a name="$curcat"><font size=2>&#171; <b>$catname{$curcat}</b> &#187;</font></td>
  </tr>
EOT
		foreach $curboard (@{$catboards{$curcat}}) {
			chomp $curboard;
			fopen(FILE, "$boardsdir/$curboard.dat");
			$curboardname = <FILE>;
			chomp $curboardname;
			$curboarddescr = <FILE>;
			chomp $curboarddescr;
			$curboardmods = <FILE>;
			chomp $curboardmods;
			fclose(FILE);
			%moderators = ();
			foreach $curuser (split(/\|/, $curboardmods)) {
				&LoadUser($curuser);
				$moderators{$curuser} = $userprofile{$curuser}->[1];

			}
			$showmods = '';
			if( scalar keys %moderators == 1 ) {
				$showmods = qq~$txt{'298'}: ~;
			}
			elsif( scalar keys %moderators != 0) {
				$showmods = qq~$txt{'299'}: ~;
			}
			while( $tmpa = each(%moderators) ) {
				&FormatUserName($tmpa);
				$showmods .= qq~<a href="$scripturl?action=viewprofile&username=$useraccount{$tmpa}">$moderators{$tmpa}</a>, ~;
			}
			$showmods =~ s/, \Z//;
			if($showmods eq '') { $showmods = qq~$txt{'298'}: $txt{'470'}~; }
			$dlp = &getlog($curboard);
			if( $max_log_days_old && $lastposttime{$curboard} ne $txt{'470'} && $username ne 'Guest' && $dlp < stringtotime( $lastpostrealtime{$curboard} ) ) {
				$new = qq~<img src="$imagesdir/on.gif" alt="$txt{'333'}" border="0">~;
			}
			else {
				$new = qq~<img src="$imagesdir/off.gif" alt="$txt{'334'}" border="0">~;
			}
			$lastposter = $lastposter{$curboard};
			unless( $lastposterguest{$curboard} || $lastposter{$curboard} eq $txt{'470'} ) {
				$lastposterid = $lastposter;
				&LoadUser($lastposterid);
				if($userprofile{$lastposter}->[1]) { $lastposter = qq~<a href="$scripturl?action=viewprofile&username=$lastposterid">$userprofile{$lastposter}->[1]</a>~; }
			}
			$lastposter ||= $txt{'470'};
			$lastposttime ||= $txt{'470'};
			print <<"EOT";
  <tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" width="6%" align="center" valign="top">$new</td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}" align="left" width="69%">
    <a name="$curboard"></a>
    <font size=2><b><a href="$scripturl?board=$curboard">$curboardname</a></b>
    <br>$curboarddescr</font><BR>
    <font size="1">&#187; <i>$showmods</i></font></td>
    <td class="windowbg" bgcolor="$color{'windowbg'}" valign="middle" align="center" width="1%"><font size=2>$threadcount{$curboard}</font></td>
    <td class="windowbg" bgcolor="$color{'windowbg'}" valign="middle" align="center" width="1%"><font size=2>$messagecount{$curboard}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}" valign="middle" width="23%"><font size=1>$lastposttime{$curboard}<BR>$txt{'525'} $lastposter</font></td>
  </tr>
EOT
		}
	}

	$guests = 0;
	$users = '';
	fopen(FILE, "$vardir/log.txt");
	@entries = <FILE>;
	fclose(FILE);
	foreach $curentry (@entries) {
		chomp $curentry;
		($name, $value) = split(/\|/, $curentry);
		if( $name ) {
			&LoadUser($name);
			if( exists $userprofile{$name} ) {
				$users .= qq~ <a href="$scripturl?action=viewprofile&username=$useraccount{$name}">$userprofile{$name}->[1]</a><font size=1>,</font> \n~;
			}
			else { ++$guests; }
		}
	}
	$users =~ s~<font size=1>,</font> \n\Z~~;
	if( $username ne 'Guest' ) {
		$messnum = @immessages;
		print <<"EOT";
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}" colspan="6" align="center">
    <table cellpadding="0" border="0" cellspacing="0" width="100%">
      <tr>
        <td align="left">
        <img src="$imagesdir/new_some.gif" border=0 alt="$txt{'333'}"> &nbsp;&nbsp;
        <img src="$imagesdir/new_none.gif" border=0 alt="$txt{'334'}"></td>
        <td align="center"><font size=-1>&nbsp;
EOT
if($showmarkread) { 
	print qq~        <a href="$scripturl?action=markallasread">$img{'markallread'}</a>~; 
}
	print <<"EOT";
        </font></td>
      </tr>
    </table>
    </td>
  </tr>
EOT
	}

	print <<"EOT";
</table>
<br><BR>
<table border="0" width="100%" cellspacing="1" cellpadding="4" bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td bgcolor="$color{'titlebg'}" class="titlebg" align="center" colspan="6">
    <font class="text1" color="$color{'titletext'}" size="2"><b>$txt{'685'}</b></font></td>
  </tr>
EOT
	if($Show_RecentBar == 1) {
		print <<"EOT";
  <tr>
    <td class="catbg" bgcolor="$color{'catbg'}" colspan="2"><font size="2" class="catbg">&#187; <b>$txt{'214'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" width="20" valign="middle" align="center"><img src="$imagesdir/xx.gif" border="0"></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size=2><b><A href="$scripturl?action=recent">$txt{'214'}</A></b></font><br>
    <font size=1>
EOT
	require "$sourcedir/Recent.pl";
	&LastPost;
	print <<"EOT";
    </font>
  </tr>
EOT
	}
	if($Show_MemberBar == 1) {
		print <<"EOT";
  <tr>
    <td class="catbg" bgcolor="$color{'catbg'}" colspan="2"><font size="2" class="catbg">&#187; <b>$txt{'331'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" width="20" valign="middle" align="center"><img src="$imagesdir/guest.gif" border="0" width="20"></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size=2><b><A href="$scripturl?action=mlall">$txt{'332'}</A></b></font><br><font size=1>$txt{'200'}</font></td>
  </tr>
EOT
	}
	print <<"EOT";
  <tr>
    <td class="catbg" bgcolor="$color{'catbg'}" colspan="2"><font size="2" class="catbg">&#187; <b>$txt{'158'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" width="20" valign="middle" align="center"><img src="$imagesdir/online.gif" border="0"></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size=2>$txt{'141'}: $guests <br>$txt{'142'}: $users</font></td>
  </tr>
EOT

	if( $username ne 'Guest' ) {
		print <<"EOT";
  <tr>
    <td class="catbg" bgcolor="$color{'catbg'}" colspan="2"><font size="2" class="catbg">&#187; <b>$txt{'159'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" width="20" valign=middle align=center><img src="$imagesdir/pmon.gif" border="0"></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}" valign=top><font size=2><b><a href="$scripturl?board=&action=im">$txt{'159'}</a></b></font><br><font size=1>$txt{'660'} $messnum
EOT
		if($messnum == 1) { print $txt{'471'}; }
		else { print $txt{'153'}; }
		print <<"EOT";
    .... $txt{'661'} <a href="$scripturl?board=&action=im">$txt{'662'}</a> $txt{'663'}</font></td>
  </tr>
EOT
}
	if( $username eq 'Guest' ) {
		print <<"EOT";
  <tr>
    <td class="catbg" bgcolor="$color{'catbg'}" colspan="2"><font size="2" class="catbg">&#187; <b>$txt{'34'}</b></font>
    <small><small><a href="$reminderurl?action=input_user">($txt{'315'})</small></small></a></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg2'}" width="20" valign=middle align=center><img src="$imagesdir/pmon.gif" border="0"></td>
    <td class="windowbg" bgcolor="$color{'windowbg2'}" valign="middle"><BR>
    <form action="$cgi\&action=login2" method="POST">
    <table border="0" cellpadding="2" cellspacing="0" valign="middle" align="center">
      <tr>
        <td valign="middle" align="left"><font size=2><b>$txt{'35'}:</b></font></td>
        <td valign="middle" align="left"><font size=2><input type=text name="username" size="15"></font></td>
        <td valign="middle" align="left"><font size=2><b>$txt{'36'}:</b></font></td>
        <td valign="middle" align="left"><font size=2><input type=password name="passwrd" size="8"></font></td>
        <td valign="middle" align="left"><font size=2><b>$txt{'497'}:</b></font></td>
        <td valign="middle" align="left"><font size=2><input type=text name="cookielength" size="4" maxlength="4" value="$Cookie_Length"> &nbsp;</font></td>
        <td valign="middle" align="left"><font size=2><b>$txt{'508'}:</b></font></td>
        <td valign="middle" align="left"><font size=2><input type=checkbox name="cookieneverexp"></font></td>
        <td valign="middle" align="right"><input type=submit value="$txt{'34'}"></td>
      </tr>
    </table>
    </form>
   </td>
  </tr>
EOT
	}

	print <<"EOT";
</table>
EOT
	&footer;
	exit;
}

sub MarkAllRead {
	fopen(FILE, "$vardir/cat.txt");
	my @categories = <FILE>;
	fclose(FILE);
	my( $curcat, $curcatname, $curcataccess, @catboards, @membergroups, $openmemgr, $curboard );
	foreach $curcat (@categories) {
		chomp $curcat;
		fopen(FILE, "$boardsdir/$curcat.cat");
		$curcatname = <FILE>;
		$curcataccess = <FILE>;
		chomp $curcatname;
		chomp $curcataccess;
		@catboards = <FILE>;
		fclose(FILE);
		@membergroups = split( /,/, $curcataccess );
		$openmemgr = 0;
		foreach (@membergroups) {
			if( $_ eq $settings[7]) { $openmemgr = 1; last; }
		}
		if( ! $curcataccess || $settings[7] eq 'Administrator' ) {
			$openmemgr = 1;
		}
		unless( $openmemgr ) { next; }
		foreach $curboard (@catboards) {
			chomp $curboard;
			&modlog("$curboard--mark");
			&modlog($curboard);
		}
	}
	&dumplog;
	&BoardIndex;
}
1;