###############################################################################
# Display.pl                                                                  #
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

$displayplver="1 Gold - Release";

sub Display {
	my $viewnum = $INFO{'num'};
	if( $viewnum =~ /\D/ ) { &fatal_error($txt{'337'}); }
	if( $currentboard eq '' ) { &fatal_error($txt{'1'}); }
	$maxmessagedisplay ||= 10;
	my($buffer,$views,$lastposter,$moderators,$counter,$counterwords,$max,$pageindex,$msubthread,$mnum,$mstate,$mdate,$msub,$mname,$memail,$mreplies,$musername,$micon,$noposting,$threadclass,$notify,$max,$start,$bgcolornum,$windowbg,$mattach,$mip,$mlm,$mlmb,$lastmodified,$postinfo,$star,$sendm,$topicdate);
	my(@userprofile,@messages,@bgcolors);

	# Determine what category we are in.
	fopen(FILE, "$boardsdir/$currentboard.ctb") || &fatal_error("300 $txt{'106'}: $txt{'23'} $currentboard.ctb");
	$cat = <FILE>;
	fclose(FILE);
	$curcat = $cat;
	fopen(FILE, "$boardsdir/$cat.cat") || &fatal_error("300 $txt{'106'}: $txt{'23'} $cat.cat");
	$cat = <FILE>;
	fclose(FILE);
	
	# Load the membergroups list.
	fopen(FILE,"$vardir/membergroups.txt") || &fatal_error("100 $txt{'106'}: $txt{'23'} membergroups.txt");
	@membergroups = <FILE>;
	fclose(FILE);

	# Mark current thread as read.
	($mnum,$tmpa,$tmpa,$tmpa,$mdate) = split(/\|/,$yyThreadLine);
	&dumplog($mnum,$mdate);

	# Add 1 to the number of views of this thread.
	if( fopen(FILE, "$datadir/$viewnum.data") ) {
		$tmpa = <FILE>;
		fclose(FILE);
	}
	elsif( -e "$datadir/$viewnum.data" ) { &fatal_error("102 $txt{'106'}: $txt{'23'} $viewnum.data"); }
	else { $tmpa = '0'; }

	( $tmpa, $tmpb ) = split( /\|/, $tmpa );
	$tmpa++;

	fopen(FILE,"+>$datadir/$viewnum.data") || &fatal_error("103 $txt{'106'}: $txt{'23'} $viewnum.data");
	print FILE qq~$tmpa|$tmpb~;
	fclose(FILE);
	$views = $tmpa - 1;

	# Check to make sure this thread isn't locked.
	($mnum,$msubthread,$mname,$memail,$mdate,$mreplies,$musername,$micon,$mstate) = split( /\|/, $yyThreadLine );
	$noposting = $viewnum eq $mnum && $mstate == 1 ? 1 : 0;

	# Get the class of this thread, based on lock status and number of replies.
	if( $mstate == 1 ) { $threadclass = 'locked'; }
	elsif( $mreplies > 24 ) { $threadclass = 'veryhotthread'; }
	elsif( $mreplies > 14 ) { $threadclass = 'hotthread'; }
	elsif( $mstate == 0 ) { $threadclass = 'thread'; }

	# Load Censor List
	&LoadCensorList;
	
	# Build a list of this board's moderators.
	if( scalar keys %moderators > 0 ) {
		if( scalar keys %moderators == 1 ) {
			$showmods = qq~($txt{'298'}: ~;
		}
		else {
			$showmods = qq~($txt{'299'}: ~;
		}
		while( $_ = each(%moderators) ) {
			&FormatUserName($_);
			$showmods .= qq~<a href="$scripturl?action=viewprofile&username=$useraccount{$_}" class="nav">$moderators{$_}</a>, ~;
		}
		$showmods =~ s/, \Z/)/;
	}

	if( $enable_notification ) {
		my $startnum = $start || '0';
		$notify = qq~$menusep<a href="$cgi&action=notify&thread=$viewnum&start=$startnum">$img{'notify'}</a>~;
	}
	&jumpto;

	# Build the page links list.
	$max = $mreplies + 1;
	$start = $INFO{'start'} || 0;
	$start = $start > $mreplies ? $mreplies : $start;
	$start = ( int( $start / $maxmessagedisplay ) ) * $maxmessagedisplay;
	$tmpa = $start - $maxmessagedisplay;
	$pageindex .= $start == 0 ? qq~ ~ : qq~<a href="$cgi&action=display&num=$viewnum&start=$tmpa">&#171;</a> ~;
	$tmpa = 1;
	for( $counter = 0; $counter < $max; $counter += $maxmessagedisplay ) {
		$pageindex .= $start == $counter ? qq~<b>$tmpa</b> ~ : qq~<a href="$cgi&action=display&num=$viewnum&start=$counter">$tmpa</a> ~;
		$tmpa++;
	}
	$tmpa = $start + $maxmessagedisplay;
	$tmpa = $tmpa > $mreplies ? $mreplies : $tmpa;
	if($start != $counter-$maxmessagedisplay) {
		$pageindex .= $tmpa > $counter-$maxmessagedisplay ? qq~ ~ : qq~<a href="$cgi&action=display&num=$viewnum&start=$tmpa">&#187;</a> ~;
	}

	foreach (@censored) {
		($tmpa,$tmpb) = @{$_};
		$msubthread =~ s~\Q$tmpa\E~$tmpb~gi;
	}
	$curthreadurl = $curposlinks ? qq~<a href="$cgi&action=display&num=$viewnum" class="nav">$msubthread</a>~ : $msubthread;

	$yytitle = $msubthread;
	&header;
	print << "EOT";
<table width="100%" cellpadding=0 cellspacing=0>
  <tr>
    <td valign=bottom colspan="2"><font size=2 class="nav"><B>
    <img src="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    <a href="$scripturl" class="nav">$mbname</a>
    <br>
    <img src="$imagesdir/tline.gif" border=0><IMG SRC="$imagesdir/open.gif"  border=0>&nbsp;&nbsp;
    <a href="$scripturl#$curcat" class="nav">$cat</a><br>
    <img src="$imagesdir/tline2.gif" border=0><IMG SRC="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    <a href="$cgi" class="nav">$boardname</a><br>
    <img SRC="$imagesdir/tline3.gif" border=0><IMG SRC="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    $curthreadurl
    </b> $showmods</font></td>
  </tr>
</table>
<table width="100%" cellpadding=3 cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr height="35">
    <td align="left" class="catbg" bgcolor="$color{'catbg'}" width="100%">
    <table cellpadding="3" cellspacing="0" width="100%">
      <tr>
        <td>
        <font size=2><b>$txt{'139'}:</b> $pageindex</font>
        </td>
	<td class="catbg" bgcolor="$color{'catbg'}" align=right width="350"><font size=-1>
        <a href="$cgi&action=post&num=$viewnum&title=$txt{'116'}&start=$start">$img{'reply'}</a>$notify$menusep<a href="$cgi&action=sendtopic&topic=$viewnum">$img{'sendtopic'}</a>$menusep<a href="$printurl?board=$currentboard&num=$viewnum" target="_blank">$img{'print'}</a>&nbsp;
	</font></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
<table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td>
    <table cellpadding="3" cellspacing="1" border="0" width="100%">
      <tr>
        <td valign="middle" align="left" width="20%" bgcolor="$color{'titlebg'}" class="titlebg">
        <font size=2 class="text1" color="$color{'titletext'}">&nbsp;<img src="$imagesdir/$threadclass.gif">
        &nbsp;<b>$txt{'29'}</b></font>
        </td>
        <td valign="middle" align="left" bgcolor="$color{'titlebg'}" class="titlebg" width="80%">
        <font size=2 class="text1" color="$color{'titletext'}"><b>&nbsp;$txt{'118'}: $msubthread</b> &nbsp;($txt{'641'} $views $txt{'642'})</font></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
EOT

	# Load background color list.
	@bgcolors = ( $color{windowbg}, $color{windowbg2} );
	$bgcolornum = scalar @bgcolors;
	@cssvalues = ( "windowbg","windowbg2" );
	$cssnum = scalar @bgcolors;

	if($MenuType == 0) { $sm = 1; }
	$counter = 0;

	fopen(FILE,"$datadir/$viewnum.txt") || &fatal_error("104 $txt{'106'}: $txt{'23'} $viewnum.txt");

	# Skip past the posts in this thread until we reach $start.
	while( $counter < $start && ( $buffer = <FILE> ) ) {
		$counter++;
	}

	$#messages = $maxmessagedisplay - 1;
	for( $counter = 0; $counter < $maxmessagedisplay && ( $buffer = <FILE> ); $counter++ ) {
		$messages[$counter] = $buffer;
	}
	fclose(FILE);
	$#messages = $counter - 1;

	$counter = $start;

	# For each post in this thread:
	foreach (@messages) {
		$windowbg = $bgcolors[($counter % $bgcolornum)];
		$css = $cssvalues[($counter % $cssnum)];
		chomp;
		($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $postmessage, $ns, $mlm, $mlmb) = split(/[\|]/, $_);
		# Should we show "last modified by?"
		if( $mlm && $showmodify && $mlm ne "" && $mlmb ne "") {
			$mlm = &timeformat($mlm);
			&LoadUser($mlmb);
			$mlmb = $userprofile{$mlmb}->[1] || $mlmb || $txt{'470'};
			$lastmodified = qq~&#171; <i>$txt{'211'}: $mlm $txt{'525'} $mlmb</i> &#187;~;
		}
		else {
			$mlm = '-';
			$lastmodified = '';
		}
		$msub ||= $txt{'24'};
		$messdate = &timeformat($mdate);
		$mip = $settings[7] eq 'Administrator' ? $mip : "$txt{'511'}";
		$sendm = '';

		# If the user isn't a guest, load his/her info.
		if( $musername ne 'Guest' && ! $yyUDLoaded{$musername} && -e("$memberdir/$musername.dat") ) {
			# If user is not in memory, s/he must be loaded.
			&LoadUserDisplay($musername);
		}
		if( $yyUDLoaded{$musername} ) {
			@userprofile = @{$userprofile{$musername}};
			$star = $memberstar{$musername};
			$memberinfo = $memberinfo{$musername};
			$icqad = $icqad{$musername};
			$yimon = $yimon{$musername};
			if( $username ne 'Guest' ) {
				# Allow instant message sending if current user is a member.
				$sendm = qq~$menusep<a href="$cgi&action=imsend&to=$useraccount{$musername}">$img{'message_sm'}</a>~;
			}
			$usernamelink = qq~<a href="$scripturl?board=$currentboard&action=viewprofile&username=$useraccount{$musername}"><font size="2"><b>$userprofile[1]</b></font></a>~;
			$postinfo = qq~$txt{'26'}: $userprofile[6]<br>~;
			$memail = $userprofile[2];
		}
		else {
			$musername = "Guest";
			$star = '';
			$memberinfo = "$txt{'28'}";
			$icqad = '';
			$yimon = '';
			$usernamelink = qq~<font size="2"><b>$mname</b></font>~;
			$postinfo = '';
			@userprofile = ();
		}
		# Censor the subject and message.
		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$postmessage =~ s~\Q$tmpa\E~$tmpb~gi;
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}
		# Run UBBC interpreter on the message.
		$message = $postmessage; # put the message back into the proper variable to do ubbc on it
		if($enable_ubbc) { &DoUBBC; }
		$message =~ s~(\S{80})(?=\S)~$1\n~g;
		$profbutton = $profilebutton && $musername ne 'Guest' ? qq~<a href="$scripturl?action=viewprofile&username=$useraccount{$musername}">$img{'viewprofile_sm'}</a>$menusep~ : '';
		if($counter != 0) { $counterwords = "$txt{'146'} #$counter"; }
		else { $counterwords = ""; }
# Print the post and user info for the poster.
		print << "EOT";
<a name="$counter">
<table cellpadding=0 cellspacing=0 border=0 width="100%" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td>
    <table cellpadding=3 cellspacing=1 border=0 width=100%>
      <tr>
        <td bgcolor="$windowbg" class="$css">
        <table width='100%' cellpadding='4' cellspacing='0' class="$css" bgcolor="$windowbg">
          <tr>
            <td class="$css" bgcolor="$windowbg" valign='top' width='20%' rowspan='2'><font size=1>
            $usernamelink<br>
            $memberinfo<br>
EOT
if($musername ne "Guest") {
print << "EOT";
            $star<br><BR>
            $userprofile[11]
            $postinfo
            <center>$userprofile[13]$userprofile[12]
            $userprofile[8] $icqad &nbsp; $userprofile[10] $yimon &nbsp; $userprofile[9]</center><BR>
EOT
}
if($musername eq "Guest") {
print << "EOT";
            <BR><a href="mailto:$memail">$img{'email_sm'}</a>
EOT
}
elsif ($userprofile[19] ne "checked" || $settings[7] eq "Administrator" || $allow_hide_email ne 1) {
print << "EOT";
            <center>$profbutton$userprofile[4] <a href="mailto:$memail">$img{'email_sm'}</a>$sendm</center>
EOT
} else {
print << "EOT";
    <center>$profbutton$userprofile[4]$sendm</center>
EOT
}
print << "EOT";
            </font></td>
            <td class="$css" bgcolor="$windowbg" valign='top' width='80%' height='100%'>
            <table width='100%' border='0'>
              <tr>
                <td align="left" valign="middle"><img src="$imagesdir/$micon.gif"></td>
                <td align="left" valign="middle">
                <font size="2"><B>$msub</b></font><BR>
                <font size="1">&#171; <B>$counterwords $txt{'30'}:</B> $messdate &#187;</font></td>
                <td align="right" valign="bottom" nowrap height="20">
                <font size=-1>$menusep<a href="$cgi&action=post&num=$viewnum&quote=$counter&title=$txt{'116'}&start=$start">$img{'replyquote'}</a>$menusep<a href="$cgi&action=modify&message=$counter&thread=$viewnum">$img{'modify'}</a>
EOT
		if(exists $moderators{$username} || $settings[7] eq 'Administrator') {
print << "EOT";
                $menusep<a href="$cgi&action=modify2&thread=$viewnum&id=$counter&d=1">$img{'delete'}</a></font>
EOT
}
print << "EOT";
                </td>
              </tr>
            </table>
            <hr width="100%" size="1" color="$color{'windowbg3'}" class="windowbg3">
            <font size="2">
            $message
            </font>
            </td>
          </tr><tr>
            <td class="$css" bgcolor="$windowbg" valign="bottom"><font size="1">
            <table width="100%" border="0">
              <tr>
                <td align="left"><font size="1">$lastmodified</font></td>
                <td align="right"><font size="1"><img src="$imagesdir/ip.gif" alt="" border="0"> $mip</font></td>
              </tr>
            </table>
            <font size="1">
            $userprofile[5]
            </font></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
EOT
;
		$counter++;
	}

	print << "EOT";
<table width="100%" cellpadding=3 cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr height="30">
    <td align="left" class="catbg" bgcolor="$color{'catbg'}" width="100%">
    <table cellpadding="3" cellspacing="0" width="100%">
      <tr>
        <td>
        <font size=2><b>$txt{'139'}:</b> $pageindex</font>
        </td>
	<td class="catbg" bgcolor="$color{'catbg'}" align=right width="350"><font size=-1>
        <a href="$cgi&action=post&num=$viewnum&title=$txt{'116'}&start=$start">$img{'reply'}</a>$notify$menusep<a href="$cgi&action=sendtopic&topic=$viewnum">$img{'sendtopic'}</a>$menusep<a href="$printurl?board=$currentboard&num=$viewnum" target="_blank">$img{'print'}</a>&nbsp;
	</font></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
<table border=0 width=100% cellpadding=0 cellspacing=0>

EOT
  print << "EOT";
  <tr>
    <td align="left" colspan="2">
    <font size=2>
EOT
	if(exists $moderators{$username} || $settings[7] eq 'Administrator') {
		print << "EOT";
	 <b><img src="$imagesdir/admin_func.gif" alt="$txt{'137'}" border="0"></b> &nbsp;<a href="$cgi&action=movethread&thread=$viewnum"><img src="$imagesdir/admin_move.gif" alt="$txt{'132'}" border="0"></a>
	<a href="$cgi&action=removethread&thread=$viewnum"><img src="$imagesdir/admin_rem.gif" alt="$txt{'63'}" border="0"></a>
	<a href="$cgi&action=lock&thread=$viewnum"><img src="$imagesdir/admin_lock.gif" alt="$txt{'104'}" border="0"></a>
EOT
	}
	print << "EOT";
    </font></td>
    <td align="right"><form action="$scripturl" method="GET">
    <font size=1>$txt{'160'}: <select name="board">$selecthtml</select> <input type=submit value="$txt{'161'}"></form></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}
