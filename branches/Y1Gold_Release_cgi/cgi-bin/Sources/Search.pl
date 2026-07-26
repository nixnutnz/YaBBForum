###############################################################################
# Search.pl                                                                   #
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

$searchplver="1 Gold - Release";

sub plushSearch1 {
	my( @categories, %cat, $curcat, %catname, %cataccess, %catboards, $openmemgr, @membergroups, $tmpa, %openmemgr, $curboard, @threads, @boardinfo, $counter );
	@categories = ();
	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);

	# Load Censor List
	&LoadCensorList;

	$yytitle = $txt{'183'};
	&header;
	$searchpageurl = $curposlinks ? qq~<a href="$scripturl?action=search" class="nav">$txt{'182'}</a>~ : $txt{'182'};
	print <<"EOT";
<script language="JavaScript1.2" type="text/javascript">
<!-- Begin
function changeBox(cbox) {
box = eval(cbox);
box.checked = !box.checked;
}
//  End -->
</script>
<script language="JavaScript">
<!--
function checkAll() {
  for (var i = 0; i < document.searchform.elements.length; i++) {
  	if(document.searchform.elements[i].name != "subfield" && document.searchform.elements[i].name != "msgfield") {
    		document.searchform.elements[i].checked = true;
    	}
  }
}
function uncheckAll() {
  for (var i = 0; i < document.searchform.elements.length; i++) {
  	if(document.searchform.elements[i].name != "subfield" && document.searchform.elements[i].name != "msgfield") {
    		document.searchform.elements[i].checked = false;
    	}
  }
}
//-->
</script>
<table width="700" align="center" border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td><font size=2 class="nav"><img src="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;<b><a href="$scripturl" class="nav">$mbname</a></b><br><img src="$imagesdir/tline.gif" BORDER=0><img src="$imagesdir/open.gif" border=0>&nbsp;&nbsp;<b>$searchpageurl</b></font></td>
  </tr>
</table>

<table border=0 width="700" cellspacing=1 cellpadding=4 bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'183'}</font></td>
  </tr><tr>
    <td bgcolor="$color{'windowbg'}">
    <form action="$scripturl?action=search2" method="post" name="searchform">
    <font size="2"><B>$txt{'582'}:</B><br>
    <input type=text size=40 name=search>&nbsp;
    <select name="searchtype">
     <option value="allwords" selected>$txt{'343'}</option>
     <option value="anywords">$txt{'344'}</option>
     <option value="asphrase">$txt{'345'}</option>
    </select><BR>
    <B>$txt{'583'}:</B><br>
    <input type=text size=40 name=userspec>&nbsp;
    <select name="userkind">
     <option value="any">$txt{'577'}</option>
     <option value="starter">$txt{'186'}</option>
     <option value="poster">$txt{'187'}</option>
     <option value="noguests" selected>$txt{'346'}</option>
     <option value="onlyguests">$txt{'572'}</option>
    </select>
    <hr size="1" width="100%" color="$color{'windowbg3'}" class="windowbg3">
    <B>$txt{'189'}:</B><br></font>
    <table width="80%" border="0" cellpadding="1" cellspacing="0">
      <tr>
EOT
	$counter = 1;
	foreach $curcat (@categories) {
		chomp $curcat;
		fopen(FILE, "$boardsdir/$curcat.cat");
		$catname{$curcat} = <FILE>;
		chomp $catname{$curcat};
		$cataccess{$curcat} = <FILE>;
		chomp $cataccess{$curcat};
		@{$catboards{$curcat}} = <FILE>;
		fclose(FILE);
		$openmemgr{$curcat} = 0;
		@membergroups = split( /,/, $cataccess{$curcat} );
		foreach $tmpa (@membergroups) {
			if( $tmpa eq $settings[7]) { $openmemgr{$curcat} = 1; last; }
		}
		if( ! $cataccess{$curcat} || $settings[7] eq 'Administrator' ) {
			$openmemgr{$curcat} = 1;
		}
		unless( $openmemgr{$curcat} ) { next; }
		boardcheck: foreach $curboard (@{$catboards{$curcat}}) {
			chomp $curboard;
			fopen(FILE, "$boardsdir/$curboard.dat");
			@boardinfo = <FILE>;
			fclose(FILE);
			chomp @boardinfo;
			@{$boardinfo{$curboard}} = @boardinfo;
			$cat{$curboard} = $curcat;
			print qq~<td width="50%"><font size="2"><input type=checkbox name="brd$counter" value="$curboard" checked><span id="spanbrd$counter" style="cursor:hand;" onClick="changeBox('document.searchform.brd$counter')">$boardinfo[0]</span></font></td>~;
			unless( $counter % 2 ) { print q~</tr><tr>~; }
			++$counter;
		}
	}
	print <<"EOT";
      </tr>
    </table><BR>
    <INPUT TYPE="checkbox" ONCLICK="if (this.checked) checkAll(); else uncheckAll();" checked><font size="2"><i>$txt{'737'}</i></font>
    <BR><br><font size="2">
    <B>$txt{'573'}:</B>
    <table border="0" cellpadding="2" cellspacing="0">
      <tr>
        <td><font size="2">
        <input type=checkbox name=subfield value=on checked><span id="spansubfield" style="cursor:hand;" onClick="changeBox('document.searchform.subfield')">$txt{'70'}</span></font></td>
        <td><font size="2">
        <input type=checkbox name=msgfield value=on checked><span id="spanmsgfield" style="cursor:hand;" onClick="changeBox('document.searchform.msgfield')">$txt{'72'}</span></font></td>
      </tr>
    </table>
    <hr size="1" width="100%" color="$color{'windowbg3'}" class="windowbg3">
    <table border="0" cellpadding="2" cellspacing="0">
      <tr>
        <td><font size="2">
        <B>$txt{'575'} $txt{'574'}:</B><br>
        <input type=text name=minripe value=0 size=3 maxlength=5> $txt{'578'} +
        <input type=text name=minage value=0 size=5 maxlength=5> $txt{'579'}.
        </font></td>
        <td><font size="2">
        <B>$txt{'576'} $txt{'574'}:</B><br>
        <input type=text name=maxripe value=0 size=3 maxlength=5> $txt{'578'} +
        <input type=text name=maxage value=7 size=5 maxlength=5> $txt{'579'}.</font></td>
      </tr>
    </table>
    <hr size="1" width="100%" color="$color{'windowbg3'}" class="windowbg3">
    <table border="0" cellpadding="2" cellspacing="0" align="center">
      <tr>
        <td valign="bottom"><font size="2">
        <B>$txt{'191'}</B><br></font>
        <input type=text size=5 name=numberreturned maxlength=5 value=25></font></td>
        <td valign="bottom"><font size="2">
        <input type=hidden name=action value=dosearch>
        <input type="submit" name="submit" value="$txt{'182'}"></font></td>
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

sub plushSearch2 {
	my $minripe = $FORM{'minripe'} || 0;
	my $minage = $FORM{'minage'} || 0;
	my $maxripe = $FORM{'maxripe'} || 0;
	my $maxage = $FORM{'maxage'} || 7;
	my $display = $FORM{'numberreturned'} || 25;
	if( $minripe =~ /\D/ ) { &fatal_error($txt{'337'}); }
	if( $minage =~ /\D/ ) { &fatal_error($txt{'337'}); }
	if( $maxripe =~ /\D/ ) { &fatal_error($txt{'337'}); }
	if( $maxage =~ /\D/ ) { &fatal_error($txt{'337'}); }
	if( $display =~ /\D/ ) { &fatal_error($txt{'337'}); }

	my $userkind = $FORM{'userkind'};
	my $userspec = $FORM{'userspec'};
	if( $userkind eq 'starter' ) { $userkind = 1; }
	elsif( $userkind eq 'poster' ) { $userkind = 2; }
	elsif( $userkind eq 'noguests' ) { $userkind = 3; }
	elsif( $userkind eq 'onlyguests' ) { $userkind = 4; }
	else { $userkind = 0; $userspec = ''; }
	if ($userspec =~ m~/~){ &fatal_error($txt{'224'}); }
	if ($userspec =~ m~\\~){ &fatal_error($txt{'225'}); }
	$userspec =~ s/\A\s+//;
	$userspec =~ s/\s+\Z//;
	$userspec =~ s/[^0-9A-Za-z#%+,-\.@^_]//g;

	my $searchtype = $FORM{'searchtype'};
	my $search = $FORM{'search'};
	if( $searchtype eq 'anywords' ) { $searchtype = 2; }
	elsif( $searchtype eq 'asphrase' ) { $searchtype = 3; }
	else { $searchtype = 1; }
	if ($search =~ m~/~){ &fatal_error($txt{'397'}); }
	if ($search =~ m~\\~){ &fatal_error($txt{'397'}); }
	if ($search =~ /\AIs UBB Good\?\Z/i) { &fatal_error("Many llamas have pondered this question for egons. They each came up with answers to this question, each being quite different. The agreement: UBB is a good piece of software made by a large company. They, however, lack a strong supporting community, charge a lot for their software, and the employees are very biased towards their own products. And so, once again, let it be written into the books that<BR><center><a href=\"http://yabb.xnull.com\"><img src=\"http://yabb.xnull.com/images/9870.gif\" alt=\"\" border=0></a><BR>YaBB is the greatest BBS system there ever was!</center>"); }

	my $searchsubject = $FORM{'subfield'} eq 'on';
	my $searchmessage = $FORM{'msgfield'} eq 'on';

	$search =~ s/\A\s+//;
	$search =~ s/\s+\Z//;
	$search =~ s/\&/\&amp;/g;
	$search =~ s/"/\&quot;/g;
	$search =~ s/  / \&nbsp;/g;
	$search =~ s/</&lt;/g;
	$search =~ s/>/&gt;/g;
	$search =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
	$search =~ s/\cM//g;
	$search =~ s~(\S{80})(?=\S)~$1\n~g;
	$search =~ s/\n/<br>/g;
	$search =~ s/\|/\&#124;/g;
	my @search;
	if( $searchtype != 3 ) { @search = split( /\s+/, $search ); }
	else { @search = ( $search ); }

	my( $curboard, @threads, $curthread, $tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate, $ttime, @messages, $curpost, $mtime, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mns, $subfound, $msgfound, $numfound, %data, $i, $board, $curcat, @categories, %catname, %cataccess, %openmemgr, @membergroups, %cats, @boardinfo, %boardinfo, @boards, $counter, $msgnum );
	my $curtime = time + (3600*$timeoffset);
	my $mintime = $curtime - (($minage*86400)+($minripe*3600) - 1);
	my $maxtime = $curtime - (($maxage*86400)+($maxripe*3600) + 1);
	my $oldestfound = stringtotime("01/10/37 $txt{'107'} 00:00:00");

	$yytitle = $txt{'166'};
	&header;

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
		@{$catboards{$curcat}} = <FILE>;
		fclose(FILE);
		$openmemgr{$curcat} = 0;
		@membergroups = split( /,/, $cataccess{$curcat} );
		foreach $tmpa (@membergroups) {
			if( $tmpa eq $settings[7]) { $openmemgr{$curcat} = 1; last; }
		}
		if( ! $cataccess{$curcat} || $settings[7] eq 'Administrator' ) {
			$openmemgr{$curcat} = 1;
		}
		unless( $openmemgr{$curcat} ) { next; }
		foreach $curboard (@{$catboards{$curcat}}) {
			chomp $curboard;
			fopen(FILE, "$boardsdir/$curboard.dat");
			@boardinfo = <FILE>;
			fclose(FILE);
			chomp @boardinfo;
			@{$boardinfo{$curboard}} = @boardinfo;
			$cat{$curboard} = $curcat;
		}
	}

	$counter = 1;
	while( $_ = each(%FORM) ) {
		unless( $_ =~ m~\Abrd(\d+)\Z~ ) { next; }
		$_ = $FORM{$_};
		if ($_ =~ m~/~){ &fatal_error($txt{'397'}); }
		if ($_ =~ m~\\~){ &fatal_error($txt{'397'}); }
		if( $cat{$_} ) { push( @boards, $_ ); }
		++$counter;
	}

	boardcheck: foreach $curboard (@boards) {
		fopen(FILE, "$boardsdir/$curboard.txt") || next;
		@threads = <FILE>;
		fclose(FILE);
		#print qq~<ol>Beginning search in board $curboard<ol>~;
		threadcheck: foreach $curthread (@threads) {
			chomp $curthread;
			#print qq~</ol>Beginning search in thread $curthread.<ol>~;
			($tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate) = split( /\|/, $curthread );
			if( $userkind == 1 ) {
				if( $tusername eq 'Guest' ) {
					if( $tname !~ m~\A\Q$userspec\E\Z~i ) { next threadcheck; }
				}
				else {
					if( $tusername !~ m~\A\Q$userspec\E\Z~i ) { next threadcheck; }
				}
			}
			$ttime = stringtotime($tdate);
			unless( $ttime < $mintime ) { next threadcheck; }
			unless( $ttime > $maxtime ) { next boardcheck; }
			fopen(FILE, "$datadir/$tnum.txt") || next;
			@messages = <FILE>;
			fclose(FILE);
			
			postcheck: for( $msgnum = 0; $msgnum < @messages; $msgnum++ ) {
				#print qq~Beginning search in post $curpost.<br>~;
				$curpost = $messages[$msgnum];
				chomp $curpost;
				($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns) = split(/\|/,$curpost);
				$mtime = stringtotime($mdate);
				unless( $mtime < $mintime ) { next postcheck; }
				if( $numfound >= $display && $mtime <= $oldestfound ) { next postcheck; }
				if( $musername eq 'Guest' ) {
					if( $userkind == 3 || ( $userkind == 2 && $mname !~ m~\A\Q$userspec\E\Z~i ) ) { next postcheck; }
				}
				else {
					if( $userkind == 4 || ( $userkind == 2 && $musername !~ m~\A\Q$userspec\E\Z~i ) ) { next postcheck; }
				}
				#print qq~<ol>Performing search in post $curpost.</ol>~;
				if( $searchsubject ) {
					if( $searchtype == 2 ) {
						$subfound = 0;
						foreach( @search ) {
							if( $msub =~ m~\Q$_\E~i ) { $subfound = 1; last; }
						}
					}
					else {
						$subfound = 1;
						foreach( @search ) {
							if( $msub !~ m~\Q$_\E~i ) { $subfound = 0; last; }
						}
					}
				}
				if( $searchmessage && ! $subfound ) {
					if( $searchtype == 2 ) {
						$msgfound = 0;
						foreach( @search ) {
							if( $message =~ m~\Q$_\E~i ) { $msgfound = 1; last; }
						}
					}
					else {
						$msgfound = 1;
						foreach( @search ) {
							if( $message !~ m~\Q$_\E~i ) { $msgfound = 0; last; }
						}
					}
				}
				unless( $msgfound || $subfound ) { next postcheck; }
				if( $subfound ) {
					foreach( @search ) {
						$msub =~ s~(\Q$_\E)~<b>$_</b>~ig;
					}
				}
				if( $msgfound ) {
					foreach( @search ) {
						$message =~ s~(\Q$_\E)~<b>$_</b>~ig;
					}
				}
				$data{$mtime} = [$curboard, $tnum, $msgnum, $tusername, $tname, $msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns];
				if( $mtime < $oldestfound ) { $oldestfound = $mtime; }
				++$numfound;
			}
		}
	}

	@messages = sort {$b <=> $a } keys %data;
	if( @messages ) {
		if( @messages > $display ) { $#messages = $display - 1; }
		$counter = 1;
		# Load Censor List
		&LoadCensorList;
	}
	else {
		print qq~<hr><b>$txt{'170'}</b><hr>~;
	}
	for( $i = 0; $i < @messages; $i++ ) {
		($board, $tnum, $msgnum, $tusername, $tname, $msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns) = @{ $data{$messages[$i]} };
		$mdate = &timeformat($mdate);
		if( $tusername ne 'Guest' ) {
			if( &LoadUser($tusername) ) { $tname = $userprofile{$tusername}->[1]; }
		}
		if( $musername ne 'Guest' ) {
			if( &LoadUser($musername) ) { $mname = "<a href=\"$cgi&action=viewprofile&username=$musername\">$userprofile{$musername}->[1]</a>"; }
		}
		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$message =~ s~\Q$tmpa\E~$tmpb~gi;
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}
		if($enable_ubbc) { $ns = $mns; &DoUBBC; }
		if($enable_notification) {
			$notify = qq~$menusep<a href="$scripturl?board=$board&action=notify&thread=$tnum&start=$msgnum">$img{'notify'}</a>~;
		}
		print <<"EOT";
<table border=0 width=100% cellspacing=1 $color{'bordercolor'}>
<tr>
	<td align=left bgcolor="$color{'titlebg'}"><font class="text1" color="$color{'titletext'}" size=2>&nbsp;$counter&nbsp;</font></td>
	<td width="75%" bgcolor="$color{'titlebg'}"><font class="text1" color="$color{'titletext'}" size=2><b>&nbsp;$catname{$cat{$board}} / $boardinfo{$board}->[0] / <a href="$scripturl?board=$board&action=display&num=$tnum&start=$msgnum"><font class="text1" color="$color{'titletext'}" size=2>$msub</font></a></b></font></td>
	<td align=right bgcolor="$color{'titlebg'}"><nobr>&nbsp;<font class="text1" color="$color{'titletext'}" size=2>$txt{'30'}: $mdate&nbsp;</font></nobr></td>
</tr>
<tr>
	<td colspan=3 bgcolor="$color{'catbg'}" class="catbg"><font class="catbg" size=2>$txt{'109'} $tname | $txt{'105'} $txt{'525'} $mname</font></td>
</tr>
<tr height=80>
	<td colspan=3 bgcolor="$color{'windowbg2'}" valign=top><font size=2>$message</font></td>
</tr>
<tr>
	<td colspan=3 bgcolor="$color{'catbg'}"><font size=2>
		&nbsp;<a href="$scripturl?board=$board&action=post&num=$tnum&start=$msgnum&title=Post+reply">$img{'reply'}</a>$menusep<a href="$scripturl?board=$board&action=post&num=$tnum&quote=$msgnum&title=Post+reply">$img{'replyquote'}</a>$notify
	</font></td>
</tr>
</table><br>
EOT
		++$counter;
	}

print <<"EOT";
$txt{'167'}<hr>
<font size=1><a href="$cgi">$txt{'236'}</a>
$txt{'237'}<br></font>
EOT
	&footer;
	exit;
}