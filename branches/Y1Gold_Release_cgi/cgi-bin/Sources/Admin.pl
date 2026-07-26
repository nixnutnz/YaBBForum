###############################################################################
# Admin.pl                                                                    #
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

$adminplver="1 Gold - Release";

sub Admin {
	&is_admin;
	my( $numcats, $numboards, @categories, @catboards, @curcataccess, $curcat, $curcatname, $curcataccess, $curboard, $threadcount, $messagecount, $maxdays, $totalt, $totalm, $avgt, $avgm );
	my( $memcount, $latestmember ) = &MembershipGet;
	&LoadUser($latestmember);
	$thelatestmember = qq~<font size="2"><B>$txt{'656'}</B></font> <font size="1"><a href="$scripturl?action=viewprofile&username=$useraccount{$latestmember}">$userprofile{$latestmember}->[1]</a></font>~;
	$memcount ||= 1;

	# Load data for the 'remove old messages' feature, get totals, and get moderators
	fopen(FILE, "$vardir/oldestmes.txt");
	$maxdays = <FILE>;
	fclose(FILE);
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

	$yytitle = "$txt{'208'}";
	&header;
	print << "EOT";
<map NAME="egg">
<AREA SHAPE="RECT" COORDS="42,64,57,70" HREF="http://yabb.xnull.com/01g.php">
</MAP>
<table border="0" cellpadding="0" cellspacing="0" align="center">$showmods
  <tr>
    <td colspan="3" width="800">
    <table border="0" cellpadding="5" cellspacing="1" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
        <td bgcolor="$color{'titlebg'}" class="titlebg" height="23" align="center" colspan="2">
        <font size="4" color="$color{'titletext'}">$txt{'208'}</font></td>
      </tr><tr>
        <td class="windowbg" bgcolor="$color{'windowbg'}" valign="middle" align="center" width="50">
        <img src="$imagesdir/administrator.gif" border="0" alt="" usemap="#egg"></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}">
        <font size="2"><B>$txt{'248'} $settings[1] ($username)!</B></font>
        <font size="1"><BR>$txt{'644'}</font></td>
      </tr>
    </table>
    </td>
  </tr><tr>
    <td valign="top" width="340"><BR>
    <table border="0" cellpadding="4" cellspacing="1" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor">
      <tr>
        <td width="340" class="catbg" bgcolor="$color{'catbg'}"><font size="4" class="catbg">$txt{'424'}</font></td>
      </tr><tr>
        <td width="340" bgcolor="$color{'windowbg'}" height="21" class="windowbg">
        <img src="$imagesdir/board.gif" alt="" border="0"> <font size="3"><b>$txt{'427'}</b></td>
      </tr><tr>
        <td width="340" bgcolor="$color{'windowbg2'}" height="21" class="windowbg2"><font size="2">
        <a href="$cgi&action=editnews">$txt{'7'}</a><br>
        <a href="$cgi&action=managecats">$txt{'3'}</a><br>
        <a href="$cgi&action=manageboards">$txt{'4'}</a><br><br>
        </td>
      </tr><tr>
        <td width="340" bgcolor="$color{'windowbg'}" height="21" class="windowbg">
        <img src="$imagesdir/board.gif" alt="" border="0"> <font size="3"><b>$txt{'426'}</b></td>
      </tr><tr>
        <td width="340" bgcolor="$color{'windowbg2'}" height="21" class="windowbg2"><font size="2">
        <a href="$cgi&action=viewmembers">$txt{'5'}</a><br>
        <a href="$cgi&action=modmemgr">$txt{'8'}</a><br>
        <a href="$cgi&action=mailing">$txt{'6'}</a><br>
        <a href="$cgi&action=ipban">$txt{'206'}</a><br>
        <a href="$cgi&action=setreserve">$txt{'207'}</a><br><br>
        </td>
      </tr><tr>
        <td width="340" bgcolor="$color{'windowbg'}" height="21" class="windowbg">
        <img src="$imagesdir/board.gif" alt="" border="0"> <font size="3"><b>$txt{'428'}</b></td>
      </tr><tr>
        <td width="340" bgcolor="$color{'windowbg2'}" height="21" class="windowbg2"><font size="2">
        <a href="$cgi&action=modtemp">$txt{'216'}</a><br>
        <a href="$cgi&action=modsettings">$txt{'222'}</a><br>
        <a href="$cgi&action=setcensor">$txt{'135'}</a><br>
        <a href="$cgi&action=clean_log">$txt{'202'}</a><br><br>
        </td>
      </tr><tr>
        <td width="340" bgcolor="$color{'windowbg'}" height="21" class="windowbg">
        <img src="$imagesdir/board.gif" alt="" border="0"> <font size="3"><b>$txt{'501'}</b></td>
      </tr><tr>
        <td width="340" bgcolor="$color{'windowbg2'}" height="21" class="windowbg2"><font size="2">
        <a href="$cgi&action=repairboards">$txt{'610'}</a><BR>
        <a href="$cgi&action=boardrecount">$txt{'502'}</a><br>
        <a href="$cgi&action=membershiprecount">$txt{'504'}</a><br>
        <a href="$cgi&action=rebuildmemlist">$txt{'593'}</a><BR>
        <font size="1">($txt{'595'})</font>
        <form action="$cgi&action=removeoldthreads" method="POST">
        <font size="2">$txt{'124'} <input type=text name="maxdays" size="2" value="$maxdays"> $txt{'579'}
        <input type=submit value="$txt{'31'}"></form>
        </td>
      </tr>
    </table>
    </td>
    <td width="6">&nbsp;</td>
    <td valign="top" width="460"><BR>
    <table border="0" cellpadding="4" cellspacing="1" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor">
      <tr>
        <td width="460" class="catbg" bgcolor="$color{'catbg'}"><font size="4" class="catbg">$txt{'645'}</font></td>
      </tr><tr>
        <td bgcolor="$color{'windowbg'}" class="windowbg" height="21">
        <img src="$imagesdir/cat.gif" alt="" border="0"> <font size="3"><B>$txt{'94'}</B></font><BR></td>
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
            <td><font size="1">$yyclicks</font></td>
          </tr><tr>
            <td colspan="2"><font size="2"><a href="$scripturl?action=showclicks">$txt{'693'}</a></font></td>
          </tr>
        </table>
	</td>
      </tr><tr>
        <td bgcolor="$color{'windowbg'}" class="windowbg" height="21">
        <img src="$imagesdir/cat.gif" alt="" border="0"> <font size="3"><B>$txt{'657'}</B></font><BR></td>
      </tr><tr>
	<td bgcolor="$color{'windowbg2'}" class="windowbg2">
        $thelatestmember<BR>
        <font size="2"><B>$txt{'659'}</b></font><font size="1"> 
EOT
        require "$sourcedir/Recent.pl";
        $recentsender = "admin";
	&LastPost;
	print <<"EOT";
        </font><BR><BR>
	<font size="2"><B>$txt{'684'}:</B></font> <font size="1">$administrators</font><BR><BR>
        <font size="2"><b>$txt{'425'}:</b></font>
        <font size="1">$YaBBversion</font>/<img src="http://yabb.xnull.com/images/versioninfo/versioncheck.gif"><BR>
        <center><font size="2"><a href="$cgi&action=detailedversion">$txt{'429'}</a></font></center><BR></td>
      </tr>
    </table>
    </td>
  </tr><tr>
    <td colspan="3" width="800"><BR>
    <table border="0" cellpadding="5" cellspacing="1" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%">
      <tr>
	<td class="catbg" bgcolor="$color{'catbg'}">
	<img src="$imagesdir/xx.gif" alt="" border="0">
	<font size="4" class="catbg">$txt{'571'}</font></td>
      </tr><tr>
        <td class="windowbg" bgcolor="$color{'windowbg'}">
        <font size="1"><BR><i><B>YaBB 1 Gold:</B></i> Ze0|ntrus (Corey Chapman), plushpuffin (Darya Misse), 
        Popeye, [CV]XXL, DaveB, DaveG, CareyP, Christian Land, Tim C, ejdmoo, StarSaber, Parham and the rest 
        for helping out with graphics, code and other things :-)
        <BR><BR><i><B>YaBB 1 Final:</B></i> Zef Hemel, Jeff Lewis, Christian Land, Ze0|ntrus, Peter Crouch 
        and a bunch of others we want to thank!</font>
        <BR><BR></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub ShowClickLog {
	&is_admin;
	my($totalip,$totalclick,$totalbrow,$totalos,@log,@iplist,$date,@to,@from,@info,@os,@browser,@newiplist,@newbrowser,@newoslist,@newtolist,@newfromlist);
	my($i,$curentry);

	$yytitle = $txt{'693'};
	&header;

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

	print <<"EOT";
<table border=0 cellspacing=1 cellpadding="5" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td bgcolor="$color{'titlebg'}" class="titlebg">
    <img src="$imagesdir/xx.gif" alt="" border="0">&nbsp;
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
EOT
for($i = 0; $i < @iplist; $i++) { $iplist{$iplist[$i]}++; }
$i = 0;
while(($key, $val ) = each(%iplist)) {
	$newiplist[$i] = [ $key, $val ];
	$i++;
}
$totalclick = @iplist-1;
$totalip = @newiplist-1;
print qq~<i>$txt{'742'}: $totalclick</i><BR>~;
print qq~<i>$txt{'743'}: $totalip</i><BR><BR>~;
for($i = 0; $i < @newiplist; $i++) {
	if($newiplist[$i]->[0] =~ /\S+/) { print "$newiplist[$i]->[0] &nbsp;(<i>$newiplist[$i]->[1]</i>)<BR>\n"; }
}
print <<"EOT";
    </font></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>$txt{'695'}</B>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
EOT
for($i = 0; $i < @browser; $i++) { $browser{$browser[$i]}++; }
$i = 0;
while(($key, $val ) = each(%browser)) {
	$newbrowser[$i] = [ $key, $val ];
	$i++;
}
$totalbrow = @newbrowser-1;
print qq~<i>$txt{'744'}: $totalbrow</i><BR><BR>~;
for($i = 0; $i < @newbrowser; $i++) {
	if($newbrowser[$i]->[0] =~ /\S+/) { print "$newbrowser[$i]->[0] &nbsp;(<i>$newbrowser[$i]->[1]</i>)<BR>\n"; }
}
print <<"EOT";
    </font></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>$txt{'696'}</B>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
EOT
for($i = 0; $i < @os; $i++) { $os{$os[$i]}++; }
$i = 0;
while(($key, $val ) = each(%os) ) {
	$newoslist[$i] = [ $key, $val ];
	$i++;
}
$totalos = @newoslist-1;
print qq~<i>$txt{'745'}: $totalos</i><BR><BR>~;
for($i = 0; $i < @newoslist; $i++) {
	if($newoslist[$i]->[0] =~ /\S+/) { print "$newoslist[$i]->[0] &nbsp;(<i>$newoslist[$i]->[1]</i>)<BR>\n"; }
}
print <<"EOT";
    </font></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>Pages Visited</B>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
EOT
for($i = 0; $i < @to; $i++) { $to{$to[$i]}++; }
$i = 0;
while(($key, $val ) = each(%to)) {
	$newtolist[$i] = [ $key, $val ];
	$i++;
}
for($i = 0; $i < @newtolist; $i++) {
	if($newtolist[$i]->[0] =~ /\S+/) {	print "<a href=$newtolist[$i]->[0] target=_blank>$newtolist[$i]->[0]</a> &nbsp;(<i>$newtolist[$i]->[1]</i>)<BR>\n"; }
}
print <<"EOT";
    </font></td>
  </tr><tr>
    <td bgcolor="$color{'catbg'}" class="catbg">
    <font size=2><center><B>Referring Pages</B>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size="2">
EOT
for($i = 0; $i < @from; $i++) { $from{$from[$i]}++; }
$i = 0;
while(($key, $val ) = each(%from)) {
	$newfromlist[$i] = [ $key, $val ];
	$i++;
}
for($i = 0; $i < @newfromlist; $i++) {
	if($newfromlist[$i]->[0] =~ /\S+/) { print "<a href=$newfromlist[$i]->[0] target=_blank>$newfromlist[$i]->[0]</a> &nbsp;(<i>$newfromlist[$i]->[1]</i>)<BR>\n"; }
}
print <<"EOT";
    </font></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub RepairBoards {
	&is_admin;
	unless( $maintenance ) { &fatal_error($txt{'611'}); }
	$yytitle = $txt{'612'};
	&header;

	%users = ();
	%emails = ();
	%userslc = ();
	%nicknamess = ();
	%nicknameslc = ();
	keys %users = $#memberlist;
	keys %emails = $#memberlist;
	keys %userslc = $#memberlist;
	keys %nicknames = $#memberlist;
	keys %nicknameslc = $#memberlist;
	fopen(FILE, "$memberdir/memberlist.txt") || &fatal_error("1000 $txt{'106'}: $txt{'23'} memberlist.txt");

	while( $musername = <FILE> ) {
		$musername =~ s~[\n\r]~~g;
		if( $musername && fopen(FILE2, "$memberdir/$musername.dat") ) {
			$_ = <FILE2>;
			$mname = <FILE2>;
			$memail = <FILE2>;
			fclose(FILE2);
			$mname =~ s~[\n\r]~~g;
			$memail =~ s~[\n\r]~~g;
			$musernamelc = lc $musername;
			$mnamelc = lc $mname;
			$users{$musername} = $mname;
			$emails{$musername} = $memail;
			$nicknames{$mname} = $musername;
			$userslc{$musernamelc} = $mname;
			$nicknameslc{$mnamelc} = $musername;
		}
	}
	fclose(FILE);

	@categories = ();
	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);
	foreach $curcat (@categories) {
		chomp $curcat;
		fopen(FILE, "$boardsdir/$curcat.cat");
		$catname{$curcat} = <FILE>;
		chomp $catname{$curcat};
		$cataccess{$curcat} = <FILE>;
		chomp $cataccess{$curcat};
		@catboards = <FILE>;
		fclose(FILE);
		print qq~<hr>$txt{'613'}: $curcat / $catname{$curcat}<br>~;
		boardcheck: foreach $curboard (@catboards) {
			$curboard =~ s~[\n\r]~~g;
			print qq~$txt{'614'}: $curboard<br>~;
			fopen(FILE, "$boardsdir/$curboard.dat");
			@boardinfo = <FILE>;
			fclose(FILE);
			chomp @boardinfo;
			@{$boardinfo{$curboard}} = @boardinfo;
			$cat{$curboard} = $curcat;
			fopen(FILE, "$boardsdir/$curboard.txt") || &fatal_error("1001 $txt{'106'}: $txt{'23'} $curboard.txt");
			@threads = <FILE>;
			fclose(FILE);
			#  Process Board Here  #
			%ttimes = ();
			keys %ttimes = $#threads;
			$totalposts = 0;
			$totalthreads = 0;
			threadcheck: for( $threadnum = 0; $threadnum < @threads; ++$threadnum ) {
				$curthread = $threads[$threadnum];
				$curthread =~ s~[\n\r]~~g;
				if( $curthread =~ m~\A\s*\Z~ ) {
					$threads[$threadnum] = '';
					next threadcheck;
				}
				($tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate) = split( /\|/, $curthread );
				if( fopen(FILE, "$datadir/$tnum.txt") ) {
					@messages = <FILE>;
					fclose(FILE);
				}
				else {
					$threads[$threadnum] = '';
					next threadcheck;
				}
				$treplies = 0;
				postcheck: for( $postnum = 0; $postnum < @messages; ++$postnum ) {
					$curpost = $messages[$postnum];
					$curpost =~ s~[\n\r]~~g;
					if( $curpost =~ m~\A\s*\Z~ ) {
						$messages[$postnum] = '';
						next postcheck;
					}
					++$treplies;
					($msub, $mname, $memail, $mdate, $musername, $icon, $mattach, $mip, $message, $mns, $mlm, $mlmb) = split(/\|/,$curpost);
					$mnamelc = lc $mname;
					$musernamelc = lc $musername;
					unless( $musername eq 'Guest' || exists $userslc{$musernamelc} ) {
						$musername = $nicknames{$mname} || $nicknameslc{$mnamelc} || 'Guest';
					}
					if( $mlmb ) {
						$mlmblc = lc $mlmb;
						$mlmb = $users{ $nicknames{$mlmb} } || $userslc{ $nicknameslc{$mlmblc} } || $mlmb;
					}
					if( $musername ne 'Guest' && exists $users{$musername} ) {
						$mname = $users{$musername};
						$memail = $emails{$musername};
					}
					else {
						$musername = 'Guest';
						$mname =~ s/\&/\&amp;/g;
						$mname =~ s/"/\&quot;/g;
						$mname =~ s/  / \&nbsp;/g;
						$mname =~ s/</&lt;/g;
						$mname =~ s/>/&gt;/g;
						$mname =~ s/\|/\&#124;/g;
						$memail =~ s/\&/\&amp;/g;
						$memail =~ s/"/\&quot;/g;
						$memail =~ s/  / \&nbsp;/g;
						$memail =~ s/</&lt;/g;
						$memail =~ s/>/&gt;/g;
						$memail =~ s/\|//g;
						$mnamelc = lc $mname;
						if( exists $nicknameslc{$mnamelc} || exists $userslc{$mnamelc} ) {
							$mname .= " ($txt{'28'})";
						}
					}

					$msub =~ s/\cM//g;
					$msub =~ s~&lt;~<~g;
					$msub =~ s~&gt;~>~g;
					$msub =~ s~&quot;~"~g;
					$msub =~ s~&#124;~\|~g;
					$msub =~ s~&nbsp;~ ~g;
					$msub =~ s~&amp;~&~g;

					if (length($msub) > 50) { $msub = substr($msub,0,50); }
					$msub =~ s/\&/\&amp;/g;
					$msub =~ s/"/\&quot;/g;
					$msub =~ s/  / \&nbsp;/g;
					$msub =~ s/</&lt;/g;
					$msub =~ s/>/&gt;/g;
					$msub =~ s/\|/\&#124;/g;

					$message =~ s/\cM//g;
					$message =~ s~&lt;~<~g;
					$message =~ s~&gt;~>~g;
					$message =~ s~&quot;~"~g;
					$message =~ s~&#124;~\|~g;
					$message =~ s~ \&nbsp; \&nbsp; \&nbsp;~\t~g;
					$message =~ s~&nbsp;~ ~g;
					$message =~ s~&amp;~&~g;
					$message =~ s/<br>/\n/gi;

					$message =~ s~(\S{80})(?=\S)~$1\n~g;
					$message =~ s~\[([^\]]{0,30})\n([^\]]{0,30})\]~\[$1$2\]~g;
					$message =~ s~\[/([^\]]{0,30})\n([^\]]{0,30})\]~\[/$1$2\]~g;
					$message =~ s~(\w+://[^<>\s\n\"\]\[]+)\n([^<>\s\n\"\]\[]+)~$1$2~g;
					$message =~ s/\&/\&amp;/g;
					$message =~ s/"/\&quot;/g;
					$message =~ s/  / \&nbsp;/g;
					$message =~ s/</&lt;/g;
					$message =~ s/>/&gt;/g;
					$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
					$message =~ s/\|/\&#124;/g;
					$message =~ s~\n~<br>~g;
					&CheckIcon;

					$messages[$postnum] = qq~$msub|$mname|$memail|$mdate|$musername|$icon|$mattach|$mip|$message|$mns|$mlm|$mlmb\n~;
					if( $postnum == 0 ) {
						$tname = $mname;
						$temail = $memail;
						$tusername = $musername;
						$tsub = $msub;
						$ticon = $icon;
					}
					if( $postnum == $#messages ) {
						$tdate = $mdate;
						$lastposter = $musername eq 'Guest' ? qq~Guest-$mname~ : $musername;
					}
				}
				if( $treplies ) {
					--$treplies;
					if( fopen(FILE, ">$datadir/$tnum.txt") ) {
						print FILE @messages;
						fclose(FILE);
						$totalposts += $treplies + 1;
						++$totalthreads;
						$ttimes{$threadnum} = stringtotime($tdate);
						$threads[$threadnum] = qq~$tnum|$tsub|$tname|$temail|$tdate|$treplies|$tusername|$ticon|$tstate\n~;
						if( fopen(FILE, "$datadir/$tnum.data") ) {
							$_ = <FILE>;
							($views, $_) = split( /\|/, $_ );
							fclose(FILE);
						}
						else {
							$views  = 0;
						}
						if( fopen(FILE, ">$datadir/$tnum.data") ) {
							print FILE qq~$views|$lastposter~;
							fclose(FILE);
						}
					}
					else {
						$treplies = -1;
					}
				}
				if( $treplies < 0 ) {
					unlink("$datadir/$tnum.txt");
					unlink("$datadir/$tnum.mail");
					unlink("$datadir/$tnum.data");
					$threads[$threadnum] = '';
					$ttimes{$threadnum} = 0;
				}
				print qq~</ul>~;
			}

			@threads = map { $_->[0] }
				sort { $b->[1] <=> $a->[1] }
				map { [ $threads[$_], $ttimes{$_} ] } keys %ttimes;

			if( fopen(FILE, ">$boardsdir/$curboard.txt", 1) ) {
				print FILE @threads;
				fclose(FILE);
			}
			($tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate) = split( /\|/, $threads[0] );
			if( fopen(FILE, "$datadir/$tnum.data") ) {
				$_ = <FILE>;
				($views, $lastposter) = split( /\|/, $_ );
				fclose(FILE);
			}
			&BoardCountSet( $curboard, $totalthreads, $totalposts, $tdate, $lastposter );
			#/ Process Board Here /#
		}
	}
	&BoardCatsMake;
	print qq~$txt{'51'}<br>~;
	&footer;
	exit;
}

sub AdminMembershipRecount {
	&is_admin;
	$yytitle = $txt{'504'};
	&header;
	&MembershipCountTotal;
	print qq~<b>$txt{'505'}</b>~;
	&footer;
	exit;
}

sub AdminBoardRecount {
	&is_admin;
	$yytitle = $txt{'502'};
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
	&header;
	print qq~<b>$txt{'503'}</b>~;
	&footer;
	exit;
}

sub RebuildMemList {
	&is_admin;
	$yytitle = "$txt{'593'}";
	opendir(DIR, "$memberdir") || die "$txt{'230'} ($memberdir) :: $!";
	@contents = readdir(DIR);
	closedir(DIR);
	fopen(MEMLIST, ">$memberdir/memberlist.txt", 1);
	foreach $line (sort @contents){
		#($name, $extension) = split (/\./, $line);
		$line =~ m~(.+)\.(.+)~;
		if ($2 eq 'dat'){
			print MEMLIST "$1\n";
		}
	}
	fclose(MEMLIST);
	&header;
	print qq~<b>$txt{'594'}</b>~;
	&footer;
	exit;
}

sub ViewMembers {
	&is_admin;
	# Load member list
	fopen(FILE, "$memberdir/memberlist.txt");
	@memberlist = <FILE>;
	fclose(FILE);
	$yytitle = "$txt{'9'}";
	&header;
	print <<"EOT";
<table border=0 width="300" cellspacing=1 cellpadding="2" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <img src="$imagesdir/guest.gif" alt="" border="0">&nbsp;
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'9'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" align="left" width="95%">
    <form action="$cgi&action=deletemultimembers" method="POST">
    <table border=0 cellspacing="4" cellspacing="0" align="center" width="95%">
EOT
	$count = 0;
	foreach $curmem (@memberlist) {
		$curmem =~ s/[\n\r]//g;
		&FormatUserName($curmem);
                if ($curmem eq "admin") {
			print qq~      <tr>\n        <td><font size=2><a href="$cgi&action=viewprofile&username=$useraccount{$curmem}">$curmem</a></font></td><td> &nbsp;&nbsp;</td>\n      </tr>\n~;
		} else {
			print qq~      <tr>\n        <td><font size=2><a href="$cgi&action=viewprofile&username=$useraccount{$curmem}">$curmem</a></font></td><td> &nbsp;&nbsp;<input type="checkbox" name="member$count" value="$curmem"></td>\n      </tr>\n~;
		}
		$count++;
	}
	print <<"EOT";
    </table>
    </td>
  </tr><tr>
	<td class="windowbg" bgcolor="$color{'windowbg'}" align="center"><input type=submit value="$txt{'608'}"></td>
  </tr>
</table>
</form>
EOT
	&footer;
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

	$umail=$memsettings[2];

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
	$yytitle = "$txt{'6'}";
	&header;
	print <<"EOT";
<table border="0" width="600" cellspacing="1" cellpadding="4" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    &nbsp;<img src="$imagesdir/email_sm.gif" alt="" border="0">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'6'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}">
    <BR><font size=1>$txt{'735'}</font><BR><BR></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}">
    <form action="$cgi&action=ml" method="POST">
    <textarea cols="70" rows="7" name="emails">
EOT
	foreach $curmem (@memberlist) {
		$curmem =~ s/[\n\r]//g;
		fopen(FILE, "$memberdir/$curmem.dat");
		@memsettings = <FILE>;
		fclose(FILE);
		$email = $memsettings[2];
		$email =~ tr/\r//d;
		$email =~ tr/\n//d;
		print "$email; ";
	}
	print <<"EOT";
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
EOT
	&footer;
	exit;
}

sub ml {
	$FORM{'emails'} = "; " . $FORM{'emails'};
	@emails = split(/;\s*/, $FORM{'emails'});
	foreach $curmem (@emails) {
		&sendmail( $curmem, "$mbname: $FORM{'subject'}", "$FORM{'message'}\n\n$txt{'130'}\n\n$scripturl");
	}
	$yySetLocation = qq~$cgi&action=admin~;
	&redirectexit;
}

sub EditNews {
	&is_admin;
	fopen(FILE, "$vardir/news.txt");
	@newsitems = <FILE>;
	fclose(FILE);
	$yytitle = "$txt{'7'}";
	&header;
	print <<"EOT";
<form action="$cgi&action=editnews2" method="POST">
<table border="0" width="70%" cellspacing="1" cellpadding="3" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <img src="$imagesdir/xx.gif" alt="">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'7'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><BR><font size="1">$txt{'670'}</font><BR><BR></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}" align="center"><BR>
    <font size=2>
    <textarea cols=70 rows=8 name="news">
EOT
	foreach $curnews (@newsitems) {
		$curnews =~ s/[\n\r]//g;
		if( $curnews =~ m~\A\s*\Z~ ) { next; }
		print "$curnews\n";
	}
	print <<"EOT";
</textarea><br><input type="submit" value="$txt{'10'}"></font><BR></td>
  </tr>
</table>
</form>
EOT
	&footer;
	exit;
}

sub EditNews2 {
	&is_admin;
	fopen(FILE, ">$vardir/news.txt", 1);
	print FILE "$FORM{'news'}";
	fclose(FILE);
	$yySetLocation = qq~$cgi\&action=admin~;
	&redirectexit;
}

sub EditMemberGroups {
	&is_admin;
	my( @lines, $mgroups, $i );
	fopen(FILE, "$vardir/membergroups.txt");
	@lines = <FILE>;
	fclose(FILE);
	$yytitle = $txt{'8'};
	foreach $i (@lines) {
		$i =~ tr/\r//d;
		$i =~ tr/\n//d;
	}
	for( $i = 7; $i < @lines; ++$i ) {
		if( $lines[$i] =~ m~\A\s+\Z~ ) { next; }
		$mgroups .= "$lines[$i]\n";
	}
	&header;
	print <<"EOT";
<table border="0" width="600" cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" align="center" cellpadding="4">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <img src="$imagesdir/guest.gif" alt="" border="0">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'8'}</font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>
    <form action="$cgi&action=modmemgr2" method="POST">
    <table border="0" cellpadding="1" cellspacing="0">
      <tr>
        <td align="right"><font size=2><b>$txt{'11'}:</b></font></td>
        <td><input type=text name="admin" size=30 value="$lines[0]"></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'12'}:</b></font></td>
        <td><input type=text name="moderator" size=30 value="$lines[1]"></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'569'}:</b></font></td>
        <td><input type=text name="newbie" size=30 value="$lines[2]"></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'13'}:</b></font></td>
        <td><input type=text name="junior" size=30 value="$lines[3]"></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'14'}:</b></font></td>
        <td><input type=text name="full" size=30 value="$lines[4]"></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'15'}:</b></font></td>
        <td><input type=text name="senior" size=30 value="$lines[5]"></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'570'}:</b></font></td>
        <td><input type=text name="god" size=30 value="$lines[6]"></td>
      </tr><tr>
        <td align="right"><font size=2><B>$txt{'16'}:</b></font></td>
        <td><textarea name="additional" cols=30 rows=5>$mgroups</textarea><BR>
        <center><input type=submit value="$txt{'10'}"></center></td>
      </tr>
    </table>
    </form>
    </td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub EditMemberGroups2 {
	&is_admin;
	my $additional = $FORM{'additional'};
	while( $groups = each(%FORM) ) {
		$FORM{$groups} =~ tr/\n//d;
		$FORM{$groups} =~ tr/\r//d;
	}

	fopen(FILE, ">$vardir/membergroups.txt", 1);
	print FILE "$FORM{'admin'}\n";
	print FILE "$FORM{'moderator'}\n";
	print FILE "$FORM{'newbie'}\n";
	print FILE "$FORM{'junior'}\n";
	print FILE "$FORM{'full'}\n";
	print FILE "$FORM{'senior'}\n";
	print FILE "$FORM{'god'}\n";
	print FILE "$additional";
	fclose(FILE);
	$yySetLocation = qq~$cgi&action=admin~;
	&redirectexit;
}

sub SetCensor {
	&is_admin;
	my( @censored, $i );
	fopen(FILE, "$vardir/censor.txt");
	@censored = <FILE>;
	fclose(FILE);
	foreach $i (@censored) {
		$i =~ tr/\r//d;
		$i =~ tr/\n//d;
	}
	$yytitle = "$txt{'135'}";
	&header;
	print <<"EOT";
<table border="0" width="300" cellspacing="1" cellpadding="4" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'135'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" align="center"><font size=2>
    <form action="$cgi&action=setcensor2" method="POST">
    $txt{'136'}<br>
    <textarea cols=50 rows=6 name="censored">
EOT
	foreach $i (@censored) {
		unless( $i && $i =~ m~.+\=.+~ ) { next; }
		print "$i\n";
	}
	print <<"EOT";
</textarea><br><BR>
    <input type=submit value="$txt{'10'}"></form></font></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub SetCensor2 {
	&is_admin;
	$FORM{'censored'} =~ tr/\r//d;
	$FORM{'censored'} =~ s~\A[\s\n]+~~;
	$FORM{'censored'} =~ s~[\s\n]+\Z~~;
	$FORM{'censored'} =~ s~\n\s*\n~\n~g;
	my @lines = split( /\n/, $FORM{'censored'} );
	fopen(FILE, ">$vardir/censor.txt", 1);
	foreach my $i (@lines) {
		$i =~ tr/\n//d;
		unless( $i && $i =~ m~.+\=.+~ ) { next; }
		print FILE "$i\n";
	}
	fclose(FILE);
	$yySetLocation = qq~$cgi&action=admin~;
	&redirectexit;
}

sub clean_log {
	&is_admin;
	$yytitle = $txt{'202'};
	&header;
	print <<"EOT";
<table border="0" width="90%" cellspacing=1 cellpadding="3" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'202'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>$txt{'203'}
    <a href="$cgi&action=do_clean_log">$txt{'163'}</a>&nbsp;&nbsp;<a href="$scripturl?action=admin">$txt{'164'}</a><br>
    </font></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub do_clean_log {
	&is_admin;
	# Overwrite with a blank file
	fopen(FILE, ">$vardir/log.txt");
	print FILE '';
	close FILE;
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
	$yytitle = "$txt{'340'}";
	&header;
	print <<"EOT";
<table border="0" cellspacing="1" cellpadding="4" align="center" width="550">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <img src="$imagesdir/ban.gif" alt="" border="0">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'340'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" align="center">
    <font size="2"><form action="$cgi&action=ipban2" method="POST">
    <BR>$txt{'724'}<br>
    <textarea cols="60" rows="6" name="ban">
EOT
	foreach $curban (@ipban) {
		$curban =~ tr/\n//d;
		$curban =~ tr/\r//d;
		if( $curban =~ m~\A\s+\Z~  ) { next; }
		print "$curban\n";
	}
	print <<"EOT";
</textarea><br><br>
    $txt{'725'}<br>
    <textarea cols=60 rows=6 name="ban_email">
EOT
	foreach $curban (@emailban) {
		$curban =~ tr/\n//d;
		$curban =~ tr/\r//d;
		if( $curban =~ m~\A\s+\Z~  ) { next; }
		print "$curban\n";
	}
	print <<"EOT";
</textarea><br><BR>
    <input type=submit value="$txt{'10'}">
    </form></font></td>
  </tr>
</table>
EOT
	&footer;
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
	
	fopen(FILE, ">$vardir/ban.txt", 1);
	print FILE "$FORM{'ban'}";
	fclose(FILE);
	fopen(FILE, ">$vardir/ban_email.txt", 1);
	print FILE "$FORM{'ban_email'}";
	fclose(FILE);
	$yySetLocation = qq~$cgi&action=admin~;
	&redirectexit;
}

sub SetReserve {
	my( @reserved, @reservecfg, $i );
	&is_admin;
	fopen(FILE, "$vardir/reserve.txt");
	@reserved = <FILE>;
	fclose(FILE);
	fopen(FILE, "$vardir/reservecfg.txt");
	@reservecfg = <FILE>;
	fclose(FILE);
	$yytitle = "$txt{'341'}";
	
	foreach $i (@reservecfg) {
		$i =~ tr/\r//d;
		$i =~ tr/\n//d;
	}

	&header;
	print <<"EOT";
<table border=0 cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" align="center" cellpadding="4" width="580">
  <tr>
    <td bgcolor="$color{'titlebg'}" class="titlebg">
    <img src="$imagesdir/profile_sm.gif" alt="" border="0">
    <font size=2 color="$color{'titletext'}"><b>$txt{'341'}</b></font></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg'}" class="windowbg">
    <font size="1"><BR>$txt{'699'}<BR><BR></font></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg2'}" class="windowbg2"><font size=2>
    <form action="$cgi&action=setreserve2" method="POST">
    <center>$txt{'342'}<br>
    <textarea cols=30 rows=6 name="reserved">
EOT
	foreach $i (@reserved) {
		$i =~ tr/\r//d;
		$i =~ tr/\n//d;
		if( $i =~ m~\A\s+\Z~ ) { next; }
		print "$i\n";
	}
	print <<"EOT";
	</textarea></center><br>
	<font size=2><input type=checkbox name="matchword" value="checked" $reservecfg[0]></font>
	<font size=2>$txt{'726'}</font><br>
	<font size=2><input type=checkbox name="matchcase" value="checked" $reservecfg[1]></font>
	<font size=2>$txt{'727'}</font><br>
	<font size=2><input type=checkbox name="matchuser" value="checked" $reservecfg[2]></font>
	<font size=2>$txt{'728'}</font><br>
	<font size=2><input type=checkbox name="matchname" value="checked" $reservecfg[3]></font>
	<font size=2>$txt{'729'}</font><br>
	<center><input type=submit value="$txt{'10'}"></center></form></font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub SetReserve2 {
	&is_admin;
	$FORM{'reserved'} =~ tr/\r//d;
	$FORM{'reserved'} =~ s~\A[\s\n]+~~;
	$FORM{'reserved'} =~ s~[\s\n]+\Z~~;
	$FORM{'reserved'} =~ s~\n\s*\n~\n~g;
	fopen(FILE, ">$vardir/reserve.txt", 1);
	my $matchword = $FORM{'matchword'} eq 'checked' ? 'checked' : '';
	my $matchcase = $FORM{'matchcase'} eq 'checked' ? 'checked' : '';
	my $matchuser = $FORM{'matchuser'} eq 'checked' ? 'checked' : '';
	my $matchname = $FORM{'matchname'} eq 'checked' ? 'checked' : '';
	print FILE $FORM{'reserved'};
	fclose(FILE);
	fopen(FILE, "+>$vardir/reservecfg.txt");
	print FILE "$matchword\n";
	print FILE "$matchcase\n";
	print FILE "$matchuser\n";
	print FILE "$matchname\n";
	fclose(FILE);
	$yySetLocation = qq~$cgi&action=admin~;
	&redirectexit;
}

sub ModifyTemplate {
	&is_admin;
	my( $fulltemplate, $line );
	fopen(FILE, "$boarddir/template.html");
	while( $line = <FILE> ) {
		$line =~ tr/\r//d;
		$line =~ tr/\n//d;
		$line =~ s/&/&amp;/g;
		$line =~ s/</&lt;/g;
		$line =~ s/>/&gt;/g;
		$line =~ s/\|/\&#124;/g;
		$line =~ s/\%/&#37;/g;
		$line =~ s/"/&quot;/g;
		$fulltemplate .= qq~$line\n~;
	}
	fclose(FILE);
	$yytitle = "$txt{'216'}";
	&header;
	print <<"EOT";
<table border=0 width="100%" cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" cellpadding="4">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <img src="$imagesdir/xx.gif" alt="" border="0">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'216'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}">
    <BR><font size=1>$txt{'682'}</font><BR><BR></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}" align="center"><font size=2>
    <form action="$cgi&action=modtemp2" method="POST"><BR>
    <textarea rows=30 cols=95 wrap=virtual name="template" style="width:98%">$fulltemplate</textarea>
    <br><BR><input type=submit value="$txt{'10'}"></form></font></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub ModifyTemplate2 {
	&is_admin;
	$FORM{'template'} =~ tr/\r//d;
	$FORM{'template'} =~ s~\A\n~~;
	$FORM{'template'} =~ s~\n\Z~~;
	fopen(FILE, ">$boarddir/template.html");
	print FILE $FORM{'template'};
	fclose(FILE);
	$yySetLocation = qq~$cgi&action=admin~;
	&redirectexit;
}

sub ver_detail {
	&is_admin;
	&loadfiles;
	$yytitle = $txt{'429'};
	&header;
	print <<"EOT";
<table border="0" width="70%" cellspacing=1 bgcolor="$color{'titlebg'}" align="center">
  <tr>
    <td bgcolor="$color{'titlebg'}"><font size=2 color="$color{'titletext'}"><b>$txt{'429'}</b></font></td>
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
        <td width="30%"><font size=2>YaBB.pl</td><td><font size=2><i>$YaBBplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/yabbplver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>$language</td><td><font size=2><i>$englishlngver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/englishlngver.gif"></td>
      </tr><tr>
        <td width="30%"><font size=2>Admin.pl</td><td><font size=2><i>$adminplver</i></td>
        <td><img src="http://yabb.xnull.com/images/versioninfo/adminplver.gif"></td>
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
        <td width="30%"><font size=2>ManageBoards.pl</td><td><font size=2>$manageboardsplver</i></td>
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
      </tr>
    </table>
    </font></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub ModifySettings {
	&is_admin;
	my($mainchecked, $guestaccchecked, $forcechecked, $blankchecked, $agreechecked, $mailpasschecked, $newpasschecked, $welchecked);
	my($menuchecked, $ubbcchecked, $aluchecked, $cpchecked, $pbchecked, $insertchecked, $newschecked, $gpchecked, $notifchecked);
	my($ahmchecked, $slmchecked, $srbarchecked, $smbarchecked, $smreadchecked, $smodchecked, $supicchecked, $sutextchecked, $sgichecked);
	my($snfchecked, $fls1, $fls2, $fls3, $utfchecked, $truncchecked, $mts1, $mts2, $mts3, $tsl6, $tsl5, $tsl4, $tsl3, $tsl2, $tsl1);
	
	$yytitle = $txt{'222'};
	&header;
	
	# figure out what to print
	if ($maintenance) { $mainchecked = ' checked'; }
	if ($guestaccess == 0) { $guestaccchecked = ' checked'; }
	if ($yyForceIIS) { $forcechecked = ' checked'; }
	if ($yyblankpageIIS) { $blankchecked = ' checked'; }
	if($RegAgree) { $agreechecked = " checked"; }
	if($emailpassword) { $mailpasschecked = " checked"; }
	if($emailnewpass) { $newpasschecked = " checked"; }
	if($emailwelcome) { $welchecked = " checked"; }
	if ($MenuType) { $menuchecked = ' checked'; }
	if ($enable_ubbc) { $ubbcchecked = ' checked'; }
	if ($autolinkurls) { $aluchecked = ' checked'; }
	if ($curposlinks) { $cpchecked = ' checked'; }
	if ($profilebutton) { $pbchecked = ' checked'; }
	if ($enable_news) { $newschecked = "checked" }
	if ($enable_guestposting) { $gpchecked = "checked" }
	if ($enable_notification) { $notifchecked = "checked" }
	if ($allow_hide_email) { $ahmchecked = "checked" }
	if ($showlatestmember) { $slmchecked = "checked" }
	if ($Show_RecentBar) { $srbarchecked = "checked" }
	if ($Show_MemberBar) { $smbarchecked = "checked" }
	if ($showmarkread) { $smreadchecked = "checked" }
	if ($showmodify) { $smodchecked = "checked" }
	if ($ShowBDescrip) { $bdescripchecked = "checked" }
	if ($showuserpic) { $supicchecked = "checked" }
	if ($showusertext) { $sutextchecked = "checked" }
	if ($showgenderimage) { $sgichecked = "checked" }
	if ($shownewsfader) { $snfchecked = "checked" }
	if ($showyabbcbutt) { $syabbcchecked = "checked" }
	if ($allowpics) { $allowpicschecked = "checked" }
	if ($use_flock == 0) { $fls1 = " selected" } elsif ($use_flock == 1) { $fls2 = " selected" } elsif ($use_flock == 2) { $fls3 = " selected" }
	$utfchecked = $usetempfile ? ' checked' : '';
	$truncchecked = $faketruncation ? ' checked' : '';
	if ($mailtype == 0) { $mts1 = ' selected'; } elsif ($mailtype == 1) { $mts2 = ' selected'; } elsif( $mailtype == 2 ) { $mts3 = ' selected'; }
	if ($timeselected == 6) { $tsl6 = " selected" } elsif ($timeselected == 5) { $tsl5 = " selected" } elsif ($timeselected == 4) { $tsl4 = " selected" } elsif ($timeselected == 3) { $tsl3 = " selected" } elsif ($timeselected == 2) { $tsl2 = " selected" } else { $tsl1 = " selected" }
	
	print <<"EOT";
<form action="$cgi&action=modsettings2" method="POST">
<table width="700" border="0" cellspacing="1" cellpadding="0" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
  <td>
  <table border="0" cellspacing="0" cellpadding="4" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}" colspan=2>
    <img src="$imagesdir/settings.gif" alt="" border="0">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'222'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" colspan=2><BR><font size="1">$txt{'347'}</font><BR><BR></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}" width="400"><font size="2">$txt{'348'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="maintenance"$mainchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'632'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="guestaccess"$guestaccchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'666'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="yyforceiis"$forcechecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'667'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="yyblankpageiis"$blankchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'349'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><select name="language">
EOT
opendir(DIR, "$boarddir") || die "$txt{'230'} ($boarddir) :: $!";
@contents = readdir(DIR);
closedir(DIR);
foreach $line (@contents){
	($name, $extension) = split (/\./, $line);
	if ($extension eq "lng"){
		$selected = "";
		if ($line eq $language) { $selected = " selected" }
		print "    <option value=\"$line\"$selected>$name\n";
	}
}
print <<"EOT";
</select></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'350'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="mbname" size="30" value="$mbname"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'351'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="boardurl" size="35" value="$boardurl"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'432'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="cookielength" size="5" value="$Cookie_Length"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'352'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="cookieusername" size="20" value="$cookieusername"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'353'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="cookiepassword" size="20" value="$cookiepassword"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'584'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="regagree"$agreechecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'702'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="emailpassword"$mailpasschecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'639'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="emailnewpass"$newpasschecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'619'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="emailwelcome"$welchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'354'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="mailprog" size="20" value="$mailprog"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'407'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="smtp_server" size="20" value="$smtp_server"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'355'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="webmaster_email" size="20" value="$webmaster_email"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'404'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}">
    <select name="mailtype" size=1>
    <option value="0"$mts1>$txt{'405'}
    <option value="1"$mts2>$txt{'406'}
    <option value="2"$mts3>Net::SMTP
    </select></td>
  </tr><tr>
    <td colspan=2 class="windowbg2" bgcolor="$color{'windowbg2'}">
    <HR size=1 width="100%" color="$color{'windowbg3'}" class="windowbg3"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'356'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="boarddir" size="30" value="$boarddir"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'357'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="datadir" size="30" value="$datadir"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'358'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="memberdir" size="30" value="$memberdir"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'359'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="boardsdir" size="30" value="$boardsdir"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'360'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="sourcedir" size="30" value="$sourcedir"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'361'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="vardir" size="30" value="$vardir"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'362'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="facesdir" size="30" value="$facesdir"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'423'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="facesurl" size="35" value="$facesurl"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'363'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="imagesdir" size="35" value="$imagesdir"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'390'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="faderpath" size="35" value="$faderpath"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'506'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="ubbcjspath" size="35" value="$ubbcjspath"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'364'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="helpfile" size="35" value="$helpfile"></td>
  </tr><tr>
    <td colspan=2 class="windowbg2" bgcolor="$color{'windowbg2'}">
    <HR size=1 width="100%" color="$color{'windowbg3'}" class="windowbg3"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'365'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="titlebg" size="10" value="$color{'titlebg'}"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'366'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="titletext" size="10" value="$color{'titletext'}"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'367'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="windowbg" size="10" value="$color{'windowbg'}"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'368'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="windowbg2" size="10" value="$color{'windowbg2'}"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'640'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="windowbg3" size="10" value="$color{'windowbg3'}"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'369'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="catbg" size="10" value="$color{'catbg'}"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'370'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="bordercolor" size="10" value="$color{'bordercolor'}"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'388'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="fadertext" size="10" value="$color{'fadertext'}"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'389'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="fadertext2" size="10" value="$color{'fadertext2'}"></td>
  </tr><tr>
    <td colspan=2 class="windowbg2" bgcolor="$color{'windowbg2'}">
    <HR size=1 width="100%" color="$color{'windowbg3'}" class="windowbg3"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'521'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="menutype"$menuchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'522'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="curposlinks"$cpchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'523'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="profilebutton"$pbchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'587'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}">
    <select name="timeselect" size=1>
    <option value="1"$tsl1>$txt{'480'}
    <option value="5"$tsl4>$txt{'484'}
    <option value="4"$tsl4>$txt{'483'}
    <option value="2"$tsl2>$txt{'481'}
    <option value="3"$tsl3>$txt{'482'}
    <option value="6"$tsl3>$txt{'485'}
    </select>
    </td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'723'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="allow_hide_email" $ahmchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'382'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showlatestmember" $slmchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'387'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="shownewsfader" $snfchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'509'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showrecentbar" $srbarchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'510'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showmemberbar" $smbarchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'618'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showmarkread" $smreadchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'732'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showbdescrip" $bdescripchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'383'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showmodify" $smodchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'384'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showuserpic" $supicchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'385'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showusertext" $sutextchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'386'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showgenderimage" $sgichecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'740'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="showyabbcbutt" $syabbcchecked></td>
  </tr><tr>
    <td colspan=2 class="windowbg2" bgcolor="$color{'windowbg2'}">
    <HR size=1 width="100%" color="$color{'windowbg3'}" class="windowbg3"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'378'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="enable_ubbc"$ubbcchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'379'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="enable_news" $newschecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'746'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="allowpics" $allowpicschecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'380'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="enable_guestposting" $gpchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'381'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="enable_notification" $notifchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'524'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="autolinkurls"$aluchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'371'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="timeoffset" size="5" value="$timeoffset"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'372'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="TopAmmount" size="5" value="$TopAmmount"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'373'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="MembersPerPage" size="5" value="$MembersPerPage"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'374'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="maxdisplay" size="5" value="$maxdisplay"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'375'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="maxmessagedisplay" size="5" value="$maxmessagedisplay"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'498'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="maxmesslen" size="5" value="$MaxMessLen"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'689'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="maxsiglen" size="5" value="$MaxSigLen"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'690'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="clicklogtime" size="5" value="$ClickLogTime"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'376'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="max_log_days_old" size="5" value="$max_log_days_old"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'739'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="fadertime" size="5" value="$fadertime"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'408'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="timeout" size="5" value="$timeout"></td>
  </tr><tr>
    <td colspan=2 class="windowbg2" bgcolor="$color{'windowbg2'}">
    <HR size=1 width="100%" color="$color{'windowbg3'}" class="windowbg3"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'588'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="jrmem" size="5" value="$JrPostNum"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'589'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="fullmem" size="5" value="$FullPostNum"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'590'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="srmem" size="5" value="$SrPostNum"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'591'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="godmem" size="5" value="$GodPostNum"></td>
  </tr><tr>
    <td colspan=2 class="windowbg2" bgcolor="$color{'windowbg2'}">
    <HR size=1 width="100%" color="$color{'windowbg3'}" class="windowbg3"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'476'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="userpic_width" size="5" value="$userpic_width"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'477'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="userpic_height" size="5" value="$userpic_height"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'478'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="userpic_limits" size="35" value="$userpic_limits"></td>
  </tr><tr>
    <td colspan=2 class="windowbg2" bgcolor="$color{'windowbg2'}">
    <HR size=1 width="100%" color="$color{'windowbg3'}" class="windowbg3"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'392'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="LOCK_EX" size="5" value="$LOCK_EX"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'393'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="LOCK_UN" size="5" value="$LOCK_UN"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'607'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=text name="LOCK_SH" size="5" value="$LOCK_SH"></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'391'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}">
    <select name="use_flock" size=1>
    <option value="0"$fls1>$txt{'401'}
    <option value="1"$fls2>$txt{'402'}
    <option value="2"$fls3>$txt{'403'}
    </select></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'615'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="usetempfile"$utfchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">$txt{'630'}</font></td>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}"><input type=checkbox name="faketruncation"$truncchecked></td>
  </tr><tr>
    <td class="windowbg2" bgcolor="$color{'windowbg2'}" colspan="2" align="center" valign="middle">
    <BR><input type=submit value="$txt{'10'}">
    </td>
  </tr>
</table>
</td>
</tr>
</table>
</form>
EOT
	&footer;
	exit;
}

sub GetBoardURL {
	my $url = 'http://' . ($ENV{'HTTP_HOST'} ? $ENV{'HTTP_HOST'} : $ENV{'SERVER_NAME'}) .  
	($ENV{'SERVER_PORT'} != 80 ? ":$ENV{'SERVER_PORT'}" : '') .
	$ENV{'SCRIPT_NAME'};
	$url =~ s~/[^/]+\Z~/~;
	return $url;
	
}

# Gets our current absolute path. Needed for error messages.
sub GetDirPath {
	eval 'use Cwd; $cwd = cwd();';
	unless( $cwd ) {
		$cwd = `pwd`; chomp $cwd;
	}
	unless( $cwd ) {
		$cwd = $0 || $ENV{'PWD'} || $ENV{'CWD'} || ( $ENV{'DOCUMENT_ROOT'} . '/' . $ENV{'SCRIPT_NAME'} || $ENV{'PATH_INFO'} );
	}
	$cwd =~ tr~\\~/~;
	$cwd =~ s~\A(.+)/\Z~$1~;
	$cwd =~ s~\A(.+)/YaBB\.\w+\Z~$1~i;
	return $cwd;
}

sub is_exe {
    my $cmd;

    foreach $cmd (@_) {
	$cmd =~ s/^\s+//;

	# remove any options
	my $name = ($cmd =~ /^(\S+)/)[0];

	# check for absolute or relative path
	return ($cmd)
	    if (-x $name and ! -d $name and $name =~ m:/:);

	if (defined $ENV{PATH}) {
	    my $dir;
	    foreach $dir (split(/:/, $ENV{PATH})) {
		return "$dir/$cmd"
		    if (-x "$dir/$name" && ! -d "$dir/$name");
	    }
	}
    }
    0;
}

sub ModifySettings2 {
	&is_admin;

	my @onoff = qw/
		allowpics showyabbcbutt showbdescrip maintenance guestaccess insert_original enable_ubbc enable_news enable_guestposting enable_notification showlatestmember showrecentbar showmemberbar showmarkread showmodify showuserpic showusertext showgenderimage shownewsfader MenuType curposlinks profilebutton autolinkurls emailpassword RegAgree emailwelcome allow_hide_email usetempfile faketruncation emailnewpass yyForceIIS yyblankpageIIS/;
	
	# Set as 0 or 1 if box was checked or not
	my $fi;
	map { $fi = lc $_; ${$_} = $FORM{$fi} eq 'on' ? 1 : 0; } @onoff;
	$guestaccess = $guestaccess ? 0 : 1;
	
	# If empty fields are submitted, set them to default-values to save yabb from crashing
	$timeout = $FORM{'timeout'} || 0;
	$fadertime = $FORM{'fadertime'} || 5;
	$timeselected = $FORM{'timeselect'} || 0;
	$timeoffset = $FORM{'timeoffset'} || 0;
	$TopAmmount = $FORM{'TopAmmount'} || 25;
	$MembersPerPage = $FORM{'MembersPerPage'} || 20;
	$maxdisplay = $FORM{'maxdisplay'} || 20;
	$maxmessagedisplay = $FORM{'maxmessagedisplay'} || 20;
	$max_log_days_old = $FORM{'max_log_days_old'} || 21;
	$clicklogtime = $FORM{'clicklogtime'} || 600;
	$use_flock = $FORM{'use_flock'} || 0;
	$LOCK_EX = $FORM{'LOCK_EX'} || 2;
	$LOCK_UN = $FORM{'LOCK_UN'} || 8;
	$LOCK_SH = $FORM{'LOCK_SH'} || 1;
	$Cookie_Length = $FORM{'cookielength'} || 60;
	$cookieusername = $FORM{'cookieusername'} || 'yabbusername';
	$cookiepassword = $FORM{'cookiepassword'} || 'yabbpassword';
	$maxmesslen = $FORM{'maxmesslen'} || 5000;
	$maxsiglen = $FORM{'maxsiglen'} || 200;
	$jrmem = $FORM{'jrmem'} || 50;
	$fullmem = $FORM{'fullmem'} || 100;
	$srmem = $FORM{'srmem'} || 250;
	$godmem = $FORM{'godmem'} || 500;
	$language = $FORM{'language'} || 'english.lng';
	$mbname = $FORM{'mbname'} || 'My YaBB 1 Gold - Release';
	$mbname =~ s/\"/\'/g;
	$boardurl = $FORM{'boardurl'} || &GetBoardURL;
	$boarddir = $FORM{'boarddir'} || &GetDirPath;
	$boardsdir = $FORM{'boardsdir'} || "$boarddir/Boards";
	$datadir = $FORM{'datadir'} || "$boarddir/Messages";
	$memberdir = $FORM{'memberdir'} || "$boarddir/Members";
	$sourcedir = $FORM{'sourcedir'} || "$boarddir/Sources";
	$vardir = $FORM{'vardir'} || "$boarddir/Variables";
	$facesdir = $FORM{'facesdir'} || "$boarddir/YaBBImages/avatars";
	$facesurl = $FORM{'facesurl'} || "$boardurl/YaBBImages/avatars";
	$imagesdir = $FORM{'imagesdir'} || "$boardurl/YaBBImages";
	$helpfile = $FORM{'helpfile'} || "$boardurl/YaBBHelp/index.html";
	$mailprog = $FORM{'mailprog'} || &is_exe( '/usr/lib/sendmail', '/usr/sbin/sendmail', '/usr/ucblib/sendmail', 'sendmail', 'mailx', 'Mail', 'mail' );
	$smtp_server = $FORM{'smtp_server'} || '127.0.0.1';
	$webmaster_email = $FORM{'webmaster_email'} || 'webmaster@mysite.com';
	$mailtype = $FORM{'mailtype'} || 0;
	$color{'titlebg'} = $FORM{'titlebg'} || '#FFB903';
	$color{'titletext'} = $FORM{'titletext'} || '#000000';
	$color{'windowbg'} = $FORM{'windowbg'} || '#272A2F';
	$color{'windowbg2'} = $FORM{'windowbg2'} || '#444444';
	$color{'windowbg3'} = $FORM{'windowbg3'} || '#FFB903';
	$color{'catbg'} = $FORM{'catbg'} || '#40454C';
	$color{'bordercolor'} = $FORM{'bordercolor'} || '#000000';
	$color{'fadertext'} = $FORM{'fadertext'} || '#FFFFFF';
	$color{'fadertext2'} = $FORM{'fadertext2'} || '#FFFFFF';
	$faderpath = $FORM{'faderpath'} || "$boardurl/fader.js";
	$ubbcjspath = $FORM{'ubbcjspath'} || "$boardurl/ubbc.js";
	$userpic_width = $FORM{'userpic_width'} || 65;
	$userpic_height = $FORM{'userpic_height'} || 65;
	$userpic_limits = $FORM{'userpic_limits'} || 'Please note that your image has to be <b>gif</b> or <b>jpg</b> and that it will be resized!';
	$userpic_limits =~ s/\"/\'/g;
	@domains = 
	
	my $filler = q~                                                                               ~;
	my $setfile = << "EOF";
###############################################################################
# Settings.pl                                                                 #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Project started by Zef Hemel (zef\@zefnet.com)                   #
# Software Version: YaBB 1 Gold - Release                                     #
# =========================================================================== #
# Software Distributed by:    http://yabb.xnull.com                           #
# Support, News, Updates at:  http://yabb.xnull.com/community/                #
# =========================================================================== #
# Copyright (c) 2000-2001 X-Null - All Rights Reserved                        #
# Software by: The YaBB Development Team                                      #
###############################################################################

########## Board Info ##########
# Note: these settings must be properly changed for YaBB to work

\$maintenance = $maintenance;				# Set to 1 to enable Maintenance mode
\$guestaccess = $guestaccess;				# Set to 0 to disallow guests from doing anything but login or register

\$yyForceIIS = $yyForceIIS;				# Set to 1 if you encounter errors while running on an MS IIS server
\$yyblankpageIIS = $yyblankpageIIS;			# Set to 1 if you encounter blank pages after posting (usually on MS IIS servers)

\$language = "$language";				# Change to language pack you want to use
\$mbname = "$mbname";					# The name of your YaBB forum
\$boardurl = "$boardurl";				# URL of your board's folder (without trailing '/')

\$Cookie_Length = $Cookie_Length;			# Cookies will expire after XX minutes of person logging in (they will be logged out after)
\$cookieusername = "$cookieusername";			# Name of the username cookie
\$cookiepassword = "$cookiepassword";			# Name of the password cookie

\$RegAgree = $RegAgree;					# Set to 1 to display the registration agreement when registering
\$emailpassword = $emailpassword;			# 0 - instant registration. 1 - password emailed to new members
\$emailnewpass = $emailnewpass;				# Set to 1 to email a new password to members if they change their email address
\$emailwelcome = $emailwelcome;				# Set to 1 to email a welcome message to users even when you have mail password turned off

\$mailprog = "$mailprog";				# Location of your sendmail program
\$smtp_server = "$smtp_server";				# SMTP-Server
\$webmaster_email = q^$webmaster_email^;		# Your e-mail address. (eg: \$webmaster_email = q^admin\@host.com^;)
\$mailtype = $mailtype;					# 0 - sendmail, 1 - SMTP, 2 - Net::SMTP


########## Directories/Files ##########
# Note: directories other than \$imagesdir do not have to be changed unless you move things

\$boarddir = "$boarddir"; 				# The absolute path to the board's folder (usually can be left as '.')
\$boardsdir = "$boardsdir";         			# Directory with board data files
\$datadir = "$datadir";         			# Directory with messages
\$memberdir = "$memberdir";        			# Directory with member files
\$sourcedir = "$sourcedir";        			# Directory with YaBB source files
\$vardir = "$vardir";         				# Directory with variable files
\$facesdir = "$facesdir";				# Absolute Path to your avatars folder
\$facesurl = "$facesurl";				# URL to your avatars folder
\$imagesdir = "$imagesdir";				# URL to your images directory
\$ubbcjspath = "$ubbcjspath";	                        # Web path to your 'ubbc.js' REQUIRED for post/modify to work properly!
\$faderpath = "$faderpath";				# Web path to your 'fader.js'
\$helpfile = "$helpfile";				# Location of your help file


########## Colors ##########
# Note: equivalent to colors in CSS tag of template.html, so set to same colors preferrably
# for browsers without CSS compatibility and for some items that don't use the CSS tag

\$color{'titlebg'} = "$color{'titlebg'}";		# Background color of the 'title-bar'
\$color{'titletext'} = "$color{'titletext'}";		# Color of text in the 'title-bar' (above each 'window')
\$color{'windowbg'} = "$color{'windowbg'}";		# Background color for messages/forms etc.
\$color{'windowbg2'} = "$color{'windowbg2'}";		# Background color for messages/forms etc.
\$color{'windowbg3'} = "$color{'windowbg3'}";		# Color of horizontal rules in posts
\$color{'catbg'} = "$color{'catbg'}";			# Background color for category (at Board Index)
\$color{'bordercolor'} = "$color{'bordercolor'}";	# Table Border color for some tables
\$color{'fadertext'}  = "$color{'fadertext'}";		# Color of text in the NewsFader ("The Latest News" color)
\$color{'fadertext2'}  = "$color{'fadertext2'}";	# Color of text in the NewsFader (news color)

########## Layout ##########

\$MenuType = $MenuType;					# 1 for text menu or anything else for images menu
\$curposlinks = $curposlinks;				# 1 for links in navigation on current page, or 0 for text without link
\$profilebutton = $profilebutton;			# 1 to show view profile button under post, or 0 for blank
\$timeselected = $timeselected;				# Select your preferred output Format of Time and Date
\$allow_hide_email = $allow_hide_email;			# Allow users to hide their email from public. Set 0 to disable
\$showlatestmember = $showlatestmember;			# Set to 1 to display "Welcome Newest Member" on the Board Index
\$shownewsfader = $shownewsfader;			# 1 to allow or 0 to disallow NewsFader javascript on the Board Index
							# If 0, you'll have no news at all unless you put <yabb news> tag
							# back into template.html!!!
\$Show_RecentBar = $showrecentbar;			# Set to 1 to display the Recent Posts bar on Board Index
\$Show_MemberBar = $showmemberbar;			# Set to 1 to display the Members List table row on Board Index
\$showmarkread = $showmarkread;				# Set to 1 to display and enable the mark as read buttons
\$showmodify = $showmodify;				# Set to 1 to display "Last modified: Realname - Date" under each message
\$ShowBDescrip = $showbdescrip;				# Set to 1 to display board descriptions on the topic (message) index for each board
\$showuserpic = $showuserpic;				# Set to 1 to display each member's picture in the message view (by the ICQ.. etc.)
\$showusertext = $showusertext;				# Set to 1 to display each member's personal text in the message view (by the ICQ.. etc.)
\$showgenderimage = $showgenderimage;			# Set to 1 to display each member's gender in the message view (by the ICQ.. etc.)
\$showyabbcbutt = $showyabbcbutt;                       # Set to 1 to display the yabbc buttons on Posting and IM Send Pages

########## Feature Settings ##########

\$enable_ubbc = $enable_ubbc;				# Set to 1 if you want to enable UBBC (Uniform Bulletin Board Code)
\$enable_news = $enable_news;				# Set to 1 to turn news on, or 0 to set news off
\$allowpics = $allowpics;				# set to 1 to allow members to choose avatars in their profile
\$enable_guestposting = $enable_guestposting;		# Set to 0 if do not allow 1 is allow.
\$enable_notification = $enable_notification;		# Allow e-mail notification
\$autolinkurls = $autolinkurls;				# Set to 1 to turn URLs into links, or 0 for no auto-linking.

\$timeoffset = $timeoffset;				# Time Offset (so if your server is EST, this would be set to -1 for CST)
\$TopAmmount = $TopAmmount;				# No. of top posters to display on the top members list
\$MembersPerPage = $MembersPerPage;			# No. of members to display per page of Members List - All
\$maxdisplay = $maxdisplay;				# Maximum of topics to display
\$maxmessagedisplay = $maxmessagedisplay;		# Maximum of messages to display
\$MaxMessLen = $maxmesslen;  				# Maximum Allowed Characters in a Posts
\$MaxSigLen = $maxsiglen;				# Maximum Allowed Characters in Signatures
\$ClickLogTime = $clicklogtime;				# Time in minutes to log every click to your forum (longer time means larger log file size)
\$max_log_days_old = $max_log_days_old;			# If an entry in the user's log is older than ... days remove it
							# Set to 0 if you want it disabled
\$fadertime = $fadertime;				# Length in seconds to display each item in the news fader
\$timeout = $timeout;					# Minimum time between 2 postings from the same IP


########## Membergroups ##########

\$JrPostNum = $jrmem;					# Number of Posts required to show person as 'junior' membergroup
\$FullPostNum = $fullmem;				# Number of Posts required to show person as 'full' membergroup
\$SrPostNum = $srmem;					# Number of Posts required to show person as 'senior' membergroup
\$GodPostNum = $godmem;					# Number of Posts required to show person as 'god' membergroup


########## MemberPic Settings ##########

\$userpic_width = $userpic_width;			# Set pixel size to which the selfselected userpics are resized, 0 disables this limit
\$userpic_height = $userpic_height;			# Set pixel size to which the selfselected userpics are resized, 0 disables this limit
\$userpic_limits = qq~$userpic_limits~;			# Text To Describe The Limits


########## File Locking ##########

\$LOCK_EX = $LOCK_EX;				# You can probably keep this as it is set now.
\$LOCK_UN = $LOCK_UN;					# You can probably keep this as it is set now.
\$LOCK_SH = $LOCK_SH;		                   # You can probably keep this as it is set now.

\$use_flock = $use_flock;				# Set to 0 if your server doesn't support file locking,
						# 1 for Unix/Linux and WinNT, and 2 for Windows 95/98/ME

\$usetempfile = $usetempfile;			# Write to a temporary file when updating large files.
						# This can potentially save your board index files from
						# being corrupted if a process aborts unexpectedly.
						# 0 to disable, 1 to enable.
						
\$faketruncation = $faketruncation;		# Enable this option only if YaBB fails with the error:
						# "truncate() function not supported on this platform."
						# 0 to disable, 1 to enable.

1;
EOF

	$setfile =~ s~(.+\;)\s+(\#.+$)~$1 . substr( $filler, 0, (70-(length $1)) ) . $2 ~gem;
	$setfile =~ s~(.{64,}\;)\s+(\#.+$)~$1 . "\n   " . $2~gem;
	# $setfile =~ s~(.+\;)(\s+)(\#.{40,}?)\s+(.{10,}$)~$1 . $2 . $3 . "\n   # " . $4~gem;
	# $setfile =~ s~^\s\s\s+(\#.{40,}?)\s+(.{10,}$)~"   " . $1 . "\n   # " . $2~gem;
	$setfile =~ s~^\s\s\s+(\#.+$)~substr( $filler, 0, 70 ) . $1~gem;
	
	fopen(FILE, ">$boarddir/Settings.pl");
	print FILE $setfile;
	fclose(FILE);

	$password = crypt($settings[0],$pwseed);
	$Cookie_Exp_Date = 'Sun, 17-Jan-2038 00:00:00 GMT';

	$yySetCookies = qq~Set-Cookie: $cookieusername=$username; path=/; expires=$Cookie_Exp_Date;\n~;
	$yySetCookies .= qq~Set-Cookie: $cookiepassword=$password; path=/; expires=$Cookie_Exp_Date;\n~;

	&LoadUserSettings;
	&WriteLog;
	&Admin;
}

1;