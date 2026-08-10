###############################################################################
# InstantMessage.pl                                                           #
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

$instantmessageplver="1 Gold - Release";

sub IMIndex {
	if( $username eq 'Guest' ) { &fatal_error($txt{147}); }
	$imbox = $txt{'316'};
	$txt{'412'} =~ s~IMBOX~$imbox~g;
	$img{'im_delete'} =~ s~IMBOX~$imbox~g;
	# Read Membergroups
	fopen(FILE, "$vardir/membergroups.txt");
	@membergroups = <FILE>;
	fclose(FILE);

	# Load censor list.
	&LoadCensorList;

	# Fix moderator showing in info
	$sender = "im";

	$yytitle = $txt{'143'};
	&header;

	print <<"EOT";
<table border=0 width=100% cellspacing=0 cellpadding="0">
  <tr>
    <td valign=bottom><font size=2 class="nav"><B>
    <IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
    <A href="$scripturl" class="nav">$mbname</a><br>
    <IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif"  BORDER=0>&nbsp;&nbsp;
    <a href="$cgi&action=im" class="nav">$txt{'144'}</a><br>
    <IMG SRC="$imagesdir/tline2.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
    $txt{'316'}
    </td>
    <td align=right valign=bottom><font size=-1>
EOT
	if( @immessages ) {
		print qq~    <a href="$cgi&action=imremoveall&caller=1">$img{'im_delete'}</a>$menusep~;
	}

	print <<"EOT";
    <a href="$cgi&action=imoutbox">$img{'im_outbox'}</a>$menusep<a href="$cgi&action=imsend">$img{'im_new'}</a>$menusep<a href="$cgi&action=im">$img{'im_reload'}</a>$menusep<a href="$cgi&action=imprefs">$img{'im_config'}</a>
    </font></td>
  </tr>
</table>
<table border=0 width="100%" cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}" width="300"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;<b>$txt{'317'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'318'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'319'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;</font></td>
  </tr>
EOT
	unless( @immessages ) {
		print <<"EOT";
  <tr>
    <td class="windowbg" colspan=4 bgcolor="$color{'windowbg'}"><font size=2>$txt{'151'}</font></td>
  </tr>
EOT
	}
	@bgcolors = ( $color{windowbg}, $color{windowbg2} );
	@bgstyles = qw~windowbg windowbg2~;
	$bgcolornum = scalar @bgcolors;
	$bgstylenum = scalar @bgstyles;

	for( $counter = 0; $counter < @immessages; $counter++ ) {
		$windowbg = $bgcolors[($counter % $bgcolornum)];
		$windowcss = $bgstyles[($counter % $bgstylenum)];
		chomp $immessages[$counter];
		($musername, $msub, $mdate, $immessage, $messageid, $mips) = split( /\|/, $immessages[$counter] );
		if( $messageid < 100 ) { $messageid = $counter; }
		if( $msub eq '' ) { $msub = $txt{'24'}; }
		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}
		$mydate = &timeformat($mdate);
		print<<"EOT";
  <tr>
    <td class="$windowcss" bgcolor="$windowbg" width=300><font size=2>$mydate</font></td>
    <td class="$windowcss" bgcolor="$windowbg"><font size=2>$musername</font></td>
    <td class="$windowcss" bgcolor="$windowbg"><font size=2><a href="#$messageid">$msub</a></font></td>
    <td class="$windowcss" bgcolor="$windowbg"><font size=2><a href="$cgi&action=imremove&caller=1&id=$messageid">$img{'im_remove'}</a></font> </td>
  </tr>
EOT
	}
	if( @immessages ) { print qq~</table>\n\n~; }

	if( @immessages ) {
		print <<"EOT";
<br>
<table border=0 width="100%" cellspacing=1 cellpadding="4" bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
     <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;<b>$txt{'29'}</b></font></td>
     <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'118'}</b></font></td>
  </tr>
EOT
	}

	for( $counter = 0; $counter < @immessages; $counter++ ) {
		$windowbg = $bgcolors[($counter % $bgcolornum)];
		$windowcss = $bgstyles[($counter % $bgstylenum)];
		($musername, $msub, $mdate, $immessage, $messageid) = split( /\|/, $immessages[$counter] );
		if( $messageid < 100 ) { $messageid = $counter; }
		if( $msub eq '' ) { $msub = $txt{'24'}; }
		$mydate = &timeformat($mdate);
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
			$usernamelink = qq~<a href="$scripturl?board=$currentboard&action=viewprofile&username=$useraccount{$musername}"><font size="2"><b>$userprofile[1]</b></font></a>~;
			$profbutton = $profilebutton && $musername ne 'Guest' ? qq~$menusep<a href="$scripturl?action=viewprofile&username=$useraccount{$musername}">$img{'viewprofile'}</a>~ : '';
			$postinfo = qq~$txt{'26'}: $userprofile[6]<br>~;
			$memail = $userprofile[2];
		}
		#$message .= $userprofile[5];
		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$immessage =~ s~\Q$tmpa\E~$tmpb~gi;
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}
		$message = $immessage; # put the message back in the proper variable for doing ubbc
		if($enable_ubbc) { &DoUBBC; }
		$message =~ s~(\S{80})(?=\S)~$1\n~g;
		print <<"EOT";
  <tr>
    <td class="$windowcss" bgcolor="$windowbg" width="160" valign="top" height="100%">
    $usernamelink<br>
    <font size=1>$memberinfo<br>
    $star<br><br>
    $postinfo
    $userprofile[11]
    <center>$userprofile[13]$userprofile[12]
    $userprofile[8] $icqad &nbsp; $userprofile[10] $yimon &nbsp; $userprofile[9]
    </center></font></td>
    <td class="$windowcss" bgcolor="$windowbg" valign=top>
    <table border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor">
      <tr class="$windowcss" bgcolor="$windowbg" height="10" width="100%">
        <td class="$windowcss" bgcolor="$windowbg"><a name="$messageid"><font size=1>&nbsp;<b>$msub</b></font></td>
        <td class="$windowcss" bgcolor="$windowbg" align="right"><font size=1><b>$txt{'30'}:</b> $mydate</font></td>
      </tr><tr height="*">
        <td colspan="2" class="$windowcss" bgcolor="$windowbg" height="100%">
        <hr width="100%" size="1" color="$color{'windowbg3'}">
        <font size=2>$message</font>
        </td>
      </tr><TR height="10">
        <td colspan="2" class="$windowcss" bgcolor="$windowbg" height="10">
        <font size=2>$userprofile[5]</font>
        <hr width="100%" size="1" color="$color{'windowbg3'}">
        </td>
      </tr><tr height="10" width="100%">
	<td class="$windowcss" bgcolor="$windowbg" height="10">
        <font size=2>
EOT
if ($userprofile[19] ne "checked" || $settings[7] eq "Administrator" || $allow_hide_email ne 1) {
print << "EOT";
	$userprofile[4]<a href="mailto:$memail">$img{'email'}</a>$profbutton
EOT
} else {
print << "EOT";
	$userprofile[4]$profbutton
EOT
}
print << "EOT";
        </font></td>
        <td class="$windowcss" bgcolor="$windowbg" height="10" align="right"><font size=2>
        <a href="$cgi&action=imsend&caller=1&num=$counter&quote=1&to=$useraccount{$musername}">$img{'replyquote'}</a>$menusep<a href="$cgi&action=imsend&caller=1&num=$counter&reply=1&to=$useraccount{$musername}">$img{'reply'}</a>$menusep<a href="$cgi&action=imremove&caller=1&caller=1&id=$messageid">$img{'im_remove'}</a>
        </font></td>
      </tr>
    </table>
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

sub IMOutbox {
	if ($username eq 'Guest') { &fatal_error($txt{'147'}); }
	$imbox = $txt{'320'};
	$txt{'412'} =~ s~IMBOX~$imbox~g;
	$img{'im_delete'} =~ s~IMBOX~$imbox~g;
	# Read all messages
	fopen(FILE, "$memberdir/$username.outbox");
	@ommessages = <FILE>;
	fclose(FILE);

	# Fix moderator showing in info
	$sender = "im";

	# Read Membergroups
	fopen(FILE, "$vardir/membergroups.txt");
	@membergroups = <FILE>;
	fclose(FILE);

	# Load censor list.
	&LoadCensorList;

	$yytitle = $txt{'143'};
	&header;

	print <<"EOT";
<table border=0 width=100% cellspacing=0>
  <tr>
    <td valign=bottom><font size=2 class="nav"><B>
    <img src="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    <a href="$scripturl" class="nav">$mbname</a><br>
    <img src="$imagesdir/tline.gif" border=0><img src="$imagesdir/open.gif"  BORDER=0>&nbsp;&nbsp;
    <a href="$cgi&action=im" class="nav">$txt{'144'}</a><br>
    <img src="$imagesdir/tline2.gif" border=0><img src="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
    $txt{'320'}
    </td>
    <td align=right valign=bottom><font size=-1>
EOT
	if( @ommessages ) {
		print qq~    <a href="$cgi&action=imremoveall&caller=2">$img{'im_delete'}</a>$menusep~;
	}
	print <<"EOT";
    <a href="$cgi&action=im">$img{'im_inbox'}</a>$menusep<a href="$cgi&action=imsend">$img{'im_new'}</a>$menusep<a href="$cgi&action=im">$img{'im_reload'}</a>$menusep<a href="$cgi&action=imprefs">$img{'im_config'}</a>
    </font></td>
  </tr>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}" width="300"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;<b>$txt{'317'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'324'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'319'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;</font></td>
  </tr>
EOT
	# Display Message if there are no Messages in Users Outbox
	unless( @ommessages ) {
		print <<"EOT";
  <tr>
    <td class="windowbg" colspan=4 bgcolor="$color{'windowbg'}"><font size=2>$txt{'151'}</font></td>
  </tr>
EOT
	}

	@bgcolors = ( $color{windowbg}, $color{windowbg2} );
	@bgstyles = qw~windowbg windowbg2~;
	$bgcolornum = scalar @bgcolors;
	$bgstylenum = scalar @bgstyles;

	for( $counter = 0; $counter < @ommessages; $counter++ ) {
		$windowbg = $bgcolors[($counter % $bgcolornum)];
		$windowcss = $bgstyles[($counter % $bgstylenum)];
		chomp $ommessages[$counter];
		($musername, $msub, $mdate, $immessage, $messageid, $mips) = split( /\|/, $ommessages[$counter] );
		if( $messageid < 100 ) { $messageid = $counter; }
		if( $msub eq '' ) { $msub = $txt{'24'}; }
		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}
		$mydate = &timeformat($mdate);
		print<<"EOT";
  <tr>
    <td class="$windowcss" bgcolor="$windowbg" width=300><font size=2>$mydate</font></td>
    <td class="$windowcss" bgcolor="$windowbg"><font size=2>$musername</font></td>
    <td class="$windowcss" bgcolor="$windowbg"><font size=2><a href="#$messageid">$msub</a></font></td>
    <td class="$windowcss" bgcolor="$windowbg"><font size=2><a href="$cgi&action=imremove&caller=1&id=$messageid">$img{'im_remove'}</a></font></td>
  </tr>
EOT
	}
	if(@ommessages) { print qq~</table>\n\n~; }

	# Output all messages
	if( @ommessages ) {
	print <<"EOT";
<br>
<table border=0 width=100% cellspacing=1 cellpadding="4" bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">&nbsp;<b>$txt{'535'}</b></font></td>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'118'}</b></font></td>
  </tr>
EOT
	}

	for( $counter = 0; $counter < @ommessages; $counter++ ) {
		$windowbg = $bgcolors[($counter % $bgcolornum)];
		$windowcss = $bgstyles[($counter % $bgstylenum)];
		($musername, $msub, $mdate, $immessage, $messageid) = split( /\|/, $ommessages[$counter] );
		if( $messageid < 100 ) { $messageid = $counter; }
		if( $msub eq '' ) { $msub = $txt{'24'}; }
		$mydate = &timeformat($mdate);
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
			$usernamelink = qq~<a href="$scripturl?board=$currentboard&action=viewprofile&username=$useraccount{$musername}"><font size="2"><B>$userprofile[1]</b></font></a>~;
			$profbutton = $profilebutton && $musername ne 'Guest' ? qq~$menusep<a href="$scripturl?action=viewprofile&username=$useraccount{$musername}">$img{'viewprofile'}</a>~ : '';
			$postinfo = qq~$txt{'26'}: $userprofile[6]<br>~;
			$memail = $userprofile[2];
		}
		$message = $immessage; # put the message back in the proper variable for doing ubbc
		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$message =~ s~\Q$tmpa\E~$tmpb~gi;
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}
		if($enable_ubbc) { &DoUBBC; }
		$message =~ s~(\S{80})(?=\S)~$1\n~g;
		print <<"EOT";
  <tr>
    <td class="$windowcss" bgcolor="$windowbg" width="160" valign="top" height="100%">
    $usernamelink<br>
    <font size=1>$memberinfo<br>
    $star<br><br>
    $postinfo
    $userprofile[11]
    <center>$userprofile[13]$userprofile[12]
    $userprofile[8] $icqad &nbsp; $userprofile[10] $yimon &nbsp; $userprofile[9]
    </center></font></td>
    <td class="$windowcss" bgcolor="$windowbg" valign=top>
    <table border="0" cellspacing="0" cellpadding="3" width="100%" height="100%" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor">
      <tr class="$windowcss" bgcolor="$windowbg" height="10" width="100%">
        <td class="$windowcss" bgcolor="$windowbg"><font size="1"><a name="$messageid">&nbsp;<b>$msub</b></font></td>
        <td class="$windowcss" bgcolor="$windowbg" align="right"><font size=1><b>$txt{'30'}:</b> $mydate</font></td>
      </tr><tr height="100%">
        <td colspan="2" class="$windowcss" bgcolor="$windowbg" height="100%">
        <hr width="100%" size="1" color="$color{'windowbg3'}">
        <font size=2>$message</font>
        </td>
      </tr><TR height="10">
        <td colspan="2" class="$windowcss" bgcolor="$windowbg" height="10">
        <font size=2>$userprofile[5]</font>
        <hr width="100%" size="1" color="$color{'windowbg3'}">
        </td>
      </tr><tr height="10" width="100%">
	<td class="$windowcss" bgcolor="$windowbg" height="10">
        <font size=2>
EOT
if ($userprofile[19] ne "checked" || $settings[7] eq "Administrator" || $allow_hide_email ne 1) {
print << "EOT";
	$userprofile[4]<a href="mailto:$memail">$img{'email'}</a>$profbutton
EOT
} else {
print << "EOT";
	$userprofile[4]$profbutton
EOT
}
print << "EOT";
        </font></td>
        <td class="$windowcss" bgcolor="$windowbg" align="right" height="10"><font size=2>
        <a href="$cgi&action=imsend&caller=2&num=$counter&quote=1&to=$useraccount{$musername}">$img{'replyquote'}</a>$menusep<a href="$cgi&action=imsend&caller=2&num=$counter&reply=1&to=$useraccount{$musername}">$img{'reply'}</a>$menusep<a href="$cgi&action=imremove&caller=2&id=$messageid">$img{'im_remove'}</a>        </font></td>
      </tr>
    </table>
    </td>
  </tr>
EOT
;
	}
	print <<"EOT";
</table>
EOT
	&footer;
	exit;
}


sub IMPost {
	if($username eq 'Guest') { &fatal_error($txt{'147'}); }
	my( @messages, $mfrom, $msubject, $mdate, $mmessage, $mip, $form_message, $form_subject );
	$yytitle=$txt{'148'};
	&header;
	if($INFO{'num'} ne "") {
		if($INFO{'caller'} == 1) { fopen(FILE, "$memberdir/$username.msg"); }
		else { fopen(FILE, "$memberdir/$username.outbox"); }
		@messages = <FILE>;
		fclose(FILE);

		($mfrom, $msubject, $mdate, $mmessage, $mip) = split(/\|/,$messages[$INFO{'num'}]);
		$msubject =~ s/Re: //g;

		if($INFO{'quote'} == 1) {
			$mmessage =~ s/<br>/\n/g;
			$form_message =~ s/\[quote\](\S+?)\[\/quote\]//isg;
			$form_message =~ s/\[(\S+?)\]//isg;
			$form_message = "\n\n\[quote\]$mmessage\[/quote\]";
			$form_subject = "Re: $msubject";
		}
		if($INFO{'reply'} == 1) { $form_subject = "Re: $msubject"; }
	}

	if ($form_subject eq "") { $form_subject = "$txt{'24'}"; }

	print <<"EOT";
<script language="JavaScript1.2" src="$ubbcjspath" type="text/javascript"></script>
<table border=0 width="700" cellpadding="3" align="center" cellspacing=0>
<tr>
	<td valign=bottom><font size=2 class="nav"><B>
	<IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	<A href="$scripturl" class="nav">$mbname</A>
	<br>
	<IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif"  BORDER=0>&nbsp;&nbsp;
	<a href="$cgi&action=im" class="nav">$txt{'144'}</A>
	<br>
	<IMG SRC="$imagesdir/tline2.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	$txt{'321'}
	</td>
<td align=right valign=bottom><font size=-1>
EOT
	print <<"EOT";
<a href="$cgi&action=im">$img{'im_inbox'}</a>$menusep<a href="$cgi&action=imoutbox">$img{'im_outbox'}</a>$menusep<a href="$cgi&action=im">$img{'im_reload'}</a>$menusep<a href="$cgi&action=imprefs">$img{'im_config'}</a>
</font></td>
</table>
<table border=0 width="700" align="center" cellpadding="3" cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$img{'im_new'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}">
    <form action="$cgi&action=imsend2" method="post" name="postmodify" onSubmit="submitonce(this);">
    <table border=0 cellpadding=3>
      <tr>
        <td align="right"><font size=2><b>$txt{'150'}:</b></font></td>
        <td><font size=2><input type=text name="to" value="$INFO{'to'}" size="20" maxlength="50">
        <font size=1">$txt{'748'}</font></font></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'70'}:</b></font></td>
        <td><font size=2><input type=text name="subject" value="$form_subject" size="40" maxlength="50"></font></td>
      </tr>
EOT
if($enable_ubbc && $showyabbcbutt) {
	print << "EOT";
<tr height="25">
     <td align="right" valign="middle"><font size=2><b>$txt{'252'}:</b></font></td>
     <td valign="middle">
<script language="JavaScript1.2" type="text/javascript">
<!--
if((navigator.appName == "Netscape" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Opera" && navigator.appVersion.charAt(0) >= 4)) {
	document.write("<a href=javascript:bold()><img src='$imagesdir/bold.gif' align=bottom width=23 height=22 alt='$txt{'253'}' border=0></a>");
	document.write("<a href=javascript:italicize()><img src='$imagesdir/italicize.gif' align=bottom width=23 height=22 alt='$txt{'254'}' border='0'></a>");
	document.write("<a href=javascript:underline()><img src='$imagesdir/underline.gif' align=bottom width=23 height=22 alt='$txt{'255'}' border='0'></a>");
	document.write("<a href=javascript:strike()><img src='$imagesdir/strike.gif' align=bottom width=23 height=22 alt='$txt{'441'}' border='0'></a>");
	document.write("<a href=javascript:glow()><img src='$imagesdir/glow.gif' align=bottom width=23 height=22 alt='$txt{'442'}' border='0'></a>");
	document.write("<a href=javascript:shadow()><img src='$imagesdir/shadow.gif' align=bottom width=23 height=22 alt='$txt{'443'}' border='0'></a>");
	document.write("<a href=javascript:move()><img src='$imagesdir/move.gif' align=bottom width=23 height=22 alt='$txt{'439'}' border='0'></a>");
	document.write("<a href=javascript:pre()><img src='$imagesdir/pre.gif' align=bottom width=23 height=22 alt='$txt{'444'}' border='0'></a>");
	document.write("<a href=javascript:left()><img src='$imagesdir/left.gif' align=bottom width=23 height=22 alt='$txt{'445'}' border='0'></a>");
	document.write("<a href=javascript:center()><img src='$imagesdir/center.gif' align=bottom width=23 height=22 alt='$txt{'256'}' border='0'></a>");
	document.write("<a href=javascript:right()><img src='$imagesdir/right.gif' align=bottom width=23 height=22 alt='$txt{'446'}' border='0'></a>");
	document.write("<a href=javascript:hr()><img src='$imagesdir/hr.gif' align=bottom width=23 height=22 alt='$txt{'531'}' border='0'></a>");
	document.write("<a href=javascript:size()><img src='$imagesdir/size.gif' align=bottom width=23 height=22 alt='$txt{'532'}' border='0'></a>");
	document.write("<a href=javascript:font()><img src='$imagesdir/face.gif' align=bottom width=23 height=22 alt='$txt{'533'}' border='0'></a>");
}
else { document.write("<font size=1>$txt{'215'}</font>"); }
//-->
</script>
<noscript>
<font size=1>$txt{'215'}</font>
</noscript>

<select name="color" onChange="showcolor(this.options[this.selectedIndex].value)">
	<option value="Black" selected>$txt{'262'}</option>
	<option value="Red">$txt{'263'}</option>
	<option value="Yellow">$txt{'264'}</option>
	<option value="Pink">$txt{'265'}</option>
	<option value="Green">$txt{'266'}</option>
	<option value="Orange">$txt{'267'}</option>
	<option value="Purple">$txt{'268'}</option>
	<option value="Blue">$txt{'269'}</option>
	<option value="Beige">$txt{'270'}</option>
	<option value="Brown">$txt{'271'}</option>
	<option value="Teal">$txt{'272'}</option>
	<option value="Navy">$txt{'273'}</option>
	<option value="Maroon">$txt{'274'}</option>
	<option value="LimeGreen">$txt{'275'}</option>
</select>
<BR>

<script language="JavaScript1.2" type="text/javascript">
<!--
if((navigator.appName == "Netscape" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Opera" && navigator.appVersion.charAt(0) >= 4)) {
	document.write("<a href=javascript:flash()><img src='$imagesdir/flash.gif' align=bottom width=23 height=22 alt='$txt{'433'}' border='0'></a>");
	document.write("<a href=javascript:hyperlink()><img src='$imagesdir/url.gif' align=bottom width=23 height=22 alt='$txt{'257'}' border='0'></a>");
	document.write("<a href=javascript:ftp()><img src='$imagesdir/ftp.gif' align=bottom width=23 height=22 alt='$txt{'434'}' border='0'></a>");
	document.write("<a href=javascript:image()><img src='$imagesdir/img.gif' align=bottom width=23 height=22 alt='$txt{'435'}' border='0'></a>");
	document.write("<a href=javascript:emai1()><img src='$imagesdir/email2.gif' align=bottom width=23 height=22 alt='$txt{'258'}' border='0'></a>");
	document.write("<a href=javascript:table()><img src='$imagesdir/table.gif' align=bottom width=23 height=22 alt='$txt{'436'}' border='0'></a>");
	document.write("<a href=javascript:trow()><img src='$imagesdir/tr.gif' align=bottom width=23 height=22 alt='$txt{'437'}' border='0'></a>");
	document.write("<a href=javascript:tcol()><img src='$imagesdir/td.gif' align=bottom width=23 height=22 alt='$txt{'449'}' border='0'></a>");
	document.write("<a href=javascript:superscript()><img src='$imagesdir/sup.gif' align=bottom width=23 height=22 alt='$txt{'447'}' border='0'></a>");
	document.write("<a href=javascript:subscript()><img src='$imagesdir/sub.gif' align=bottom width=23 height=22 alt='$txt{'448'}' border='0'></a>");
	document.write("<a href=javascript:teletype()><img src='$imagesdir/tele.gif' align=bottom width=23 height=22 alt='$txt{'440'}' border='0'></a>");
	document.write("<a href=javascript:showcode()><img src='$imagesdir/code.gif' align=bottom width=23 height=22 alt='$txt{'259'}' border='0'></a>");
	document.write("<a href=javascript:quote()><img src='$imagesdir/quote2.gif' align=bottom width=23 height=22 alt='$txt{'260'}' border='0'></a>");
	document.write("<a href=javascript:list()><img src='$imagesdir/list.gif' align=bottom width=23 height=22 alt='$txt{'261'}' border='0'></a>");

}
else { document.write("<font size=1>$txt{'215'}</font>"); }
//-->
</script>
<noscript>
<font size=1>$txt{'215'}</font>
</noscript>
     </td>
     </tr>
EOT
}
	print << "EOT";
     <tr>
     <td align="right"><font size=2><b>$txt{'297'}:</b></font></td>
     <td valign="middle">
<script language="JavaScript1.2" type="text/javascript">
<!--
if((navigator.appName == "Netscape" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Opera" && navigator.appVersion.charAt(0) >= 4)) {
	document.write("<a href=javascript:smiley()><img src='$imagesdir/smiley.gif' align=bottom alt='$txt{'287'}' border='0'></a> ");
	document.write("<a href=javascript:wink()><img src='$imagesdir/wink.gif' align=bottom alt='$txt{'292'}' border='0'></a> ");
	document.write("<a href=javascript:cheesy()><img src='$imagesdir/cheesy.gif' align=bottom alt='$txt{'289'}' border='0'></a> ");
	document.write("<a href=javascript:grin()><img src='$imagesdir/grin.gif' align=bottom alt='$txt{'293'}' border='0'></a> ");
	document.write("<a href=javascript:angry()><img src='$imagesdir/angry.gif' align=bottom alt='$txt{'288'}' border='0'></a> ");
	document.write("<a href=javascript:sad()><img src='$imagesdir/sad.gif' align=bottom alt='$txt{'291'}' border='0'></a> ");
	document.write("<a href=javascript:shocked()><img src='$imagesdir/shocked.gif' align=bottom alt='$txt{'294'}' border='0'></a> ");
	document.write("<a href=javascript:cool()><img src='$imagesdir/cool.gif' align=bottom alt='$txt{'295'}' border='0'></a> ");
	document.write("<a href=javascript:huh()><img src='$imagesdir/huh.gif' align=bottom alt='$txt{'296'}' border='0'></a> ");
	document.write("<a href=javascript:rolleyes()><img src='$imagesdir/rolleyes.gif' align=bottom alt='$txt{'450'}' border='0'></a> ");
	document.write("<a href=javascript:tongue()><img src='$imagesdir/tongue.gif' align=bottom alt='$txt{'451'}' border='0'></a> ");
	document.write("<a href=javascript:embarassed()><img src='$imagesdir/embarassed.gif' align=bottom alt='$txt{'526'}' border='0'></a> ");
	document.write("<a href=javascript:lipsrsealed()><img src='$imagesdir/lipsrsealed.gif' align=bottom alt='$txt{'527'}' border='0'></a> ");
	document.write("<a href=javascript:undecided()><img src='$imagesdir/undecided.gif' align=bottom alt='$txt{'528'}' border='0'></a> ");
	document.write("<a href=javascript:kiss()><img src='$imagesdir/kiss.gif' align=bottom alt='$txt{'529'}' border='0'></a> ");
	document.write("<a href=javascript:cry()><img src='$imagesdir/cry.gif' align=bottom alt='$txt{'530'}' border='0'></a> ");
}
else { document.write("<font size=1>$txt{'215'}</font>"); }
//-->
</script>
<noscript>
<font size=1>$txt{'215'}</font>
</noscript>
     </td>
     </tr>
     <tr>
      <td valign=top align="right">
       <font size=2><b>$txt{'469'}:</b></font>
      </td>
      <td><textarea name=message rows=12 cols=60 wrap="virtual" ONSELECT="javascript:storeCaret(this);" ONCLICK="javascript:storeCaret(this);" ONKEYUP="javascript:storeCaret(this);" ONCHANGE="javascript:storeCaret(this);">$form_message</textarea></td>
     </tr>
     <tr>
      <td align=center colspan=2>
       <input type="hidden" name="waction" value="imsend">
       <input type=submit value="$txt{'148'}" onClick="WhichClicked('imsend');">
       <input type="submit" name="preview" value="$txt{'507'}" onClick="WhichClicked('previewim');">
       <input type=reset value="$txt{'329'}">
      </td>
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

sub IMPost2
{
if($username eq 'Guest') { &fatal_error($txt{'147'}); }
my( @imconfig, @ignore, $igname, $messageid, $subject, $message, @recipient, $ignored );

$subject = $FORM{'subject'};
$subject =~ s/\A\s+//;
$subject =~ s/\s+\Z//;
$message = $FORM{'message'};
if (length($message)>$MaxMessLen) { &fatal_error("$txt{'499'}"); }

&fatal_error("$txt{'77'}") unless($subject);
&fatal_error("$txt{'78'}") unless($message);

$mmessage = $message;
$msubject = $subject;

$subject =~ s/\&/\&amp;/g;
$message =~ s/\&/\&amp;/g;
$subject =~ s/"/\&quot;/g;
$message =~ s/"/\&quot;/g;
$subject =~ s/  / \&nbsp;/g;
$message =~ s/  / \&nbsp;/g;

$subject =~ s/</&lt;/g;
$subject =~ s/>/&gt;/g;
$subject =~ s/\|/\&#124;/g;
$message =~ s/</&lt;/g;
$message =~ s/>/&gt;/g;
$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
$message =~ s/\cM//g;
$message =~ s/\n/<br>/g;
$message =~ s/\|/\&#124;/g;

if( $FORM{'waction'} eq 'previewim' ) {
	require "$sourcedir/Post.pl";
	&Preview;
}

@multiple = split(/,/, $FORM{'to'});
foreach $db (@multiple) {
	chomp $db;
	$ignored = 0;

	$db =~ s/\A\s+//;
	$db =~ s/\s+\Z//;
	$db =~ s/[^0-9A-Za-z#%+,-\.@^_]//g;

	# Check Ignore-List
	if (-e("$memberdir/$db.imconfig")) {
		fopen(FILE, "$memberdir/$db.imconfig");
		@imconfig = <FILE>;
		fclose(FILE);

		# Build Ignore-List
		$imconfig[0] =~ s/[\n\r]//g;
		$imconfig[1] =~ s/[\n\r]//g;

		@ignore = split(/\|/,$imconfig[0]);

		# If User is on Recipient's Ignore-List, show Error Message
		foreach $igname (@ignore) {
			#adds ignored user's name to array which error list will be built from later
			if ($igname eq $username) {
				push(@nouser, $db);
				$ignored = 1;
			}
		}

	}

	if (!(-e("$memberdir/$db.dat"))) { 
		#adds invalid user's name to array which error list will be built from later
		push(@nouser, $db);
		$ignored = 1;
	}

	if(!$ignored) {
	# Create unique Message ID = Time & ProccessID
	$messageid = $^T.$$;

	# Add message to outbox
	if(-e("$memberdir/$username.outbox")) { fopen(FILE, ">>$memberdir/$username.outbox", 1); }
	else { fopen(FILE, ">$memberdir/$username.outbox", 1); }
	print FILE "$db|$subject|$date|$message|$messageid|$ENV{'REMOTE_ADDR'}\n";
	fclose(FILE);

	# Send message to user
	fopen(FILE, ">>$memberdir/$db.msg");
	print FILE "$username|$subject|$date|$message|$messageid|$ENV{'REMOTE_ADDR'}\n";
	fclose(FILE);

	# Send notification
	if ($imconfig[1]==1) {
		fopen(FILE, "$memberdir/$db.dat");
		@recipient = <FILE>;
		fclose(FILE);
		$mydate = &timeformat($date);
		$recipient[2] =~ s/[\n\r]//g; # get email address
		if ($recipient[2] ne "") {
			$fromname = $settings[1];
			$txt{'561'} =~ s~SUBJECT~$msubject~g;
			$txt{'561'} =~ s~SENDER~$fromname~g;
			$txt{'561'} =~ s~DATE~$mydate~g;
			$txt{'562'} =~ s~SUBJECT~$msubject~g;
			$txt{'562'} =~ s~MESSAGE~$mmessage~g;
			$txt{'562'} =~ s~SENDER~$fromname~g;
			$txt{'562'} =~ s~DATE~$mydate~g;
			&sendmail($recipient[2],$txt{'561'},$txt{'562'});
		}
	}
	}
}  #end foreach loop

#if there were invalid usernames in the recipient list, these names are listed after all valid users have been IMed
if (@nouser) { 
	$badusers = join(", ", @nouser);
	&fatal_error("$badusers $txt{'747'}");
}
     	
$yySetLocation = qq~$cgi&action=im~;
&redirectexit;
}

sub IMRemove
{
	if($username eq 'Guest') { &fatal_error($txt{'147'}); }
	my( @messages, $a, $musername, $msub, $mdate, $mmessage, $messageid, $mip );
	if ($INFO{'caller'} == 1) { fopen(FILE, "$memberdir/$username.msg"); }
	elsif ($INFO{'caller'} == 2) { fopen(FILE, "$memberdir/$username.outbox"); }
	@messages = <FILE>;
	fclose(FILE);

	if ($INFO{'caller'} == 1) { fopen(FILE, ">$memberdir/$username.msg", 1); }
	elsif ($INFO{'caller'} == 2) { fopen(FILE, ">$memberdir/$username.outbox", 1); }

	for ($a = 0; $a < @messages; $a++) {
		chomp $messages[$a];
		# ONLY delete MSG with correct ID
		($musername, $msub, $mdate, $mmessage, $messageid, $mip) = split(/\|/,$messages[$a]);

		# If Message-ID is < 100, user has used the old IM before
		if ($messageid < 100 ) {
			if($a ne $INFO{'id'}) { print FILE "$messages[$a]\n"; }
		} else {
	 		if($messageid ne "$INFO{'id'}") { print FILE "$messages[$a]\n"; }
      		}
   	}

   	fclose(FILE);
	my $redirect = $INFO{'caller'} == 1 ? 'im' : 'imoutbox';
	$yySetLocation = qq~$cgi&action=$redirect~;
	&redirectexit;

}

sub IMPreferences {
	if ($username eq 'Guest') { &fatal_error($txt{'147'}); }
	my( @imconfig, $sel0, $sel1 );
	if (-e("$memberdir/$username.imconfig")) {
		fopen(FILE, "$memberdir/$username.imconfig");
		@imconfig = <FILE>;
		fclose(FILE);
	}

	$imconfig[0] =~ s/[\n\r]//g;
	$imconfig[0] =~ s/\|/\n/g;
	$imconfig[1] =~ s/[\n\r]//g;

	if ($imconfig[1]) {
		$sel0='';
		$sel1=' selected';
	} else {
		$sel0=' selected';
		$sel1='';
	}
	$yytitle = "$txt{'323'}: $txt{'144'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=0>
<tr>
	<td valign=bottom><font size=2 class="nav"><B>
	<IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	<A href="$scripturl" class="nav">$mbname</A>
	<br>
	<IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif"  BORDER=0>&nbsp;&nbsp;
	<a href="$cgi&action=im" class="nav">$txt{'144'}</A>
	<br>
	<IMG SRC="$imagesdir/tline2.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
	$txt{'323'}
	</td>
<td align=right valign=bottom>
EOT
	print <<"EOT";
<a href="$cgi&action=im">$img{'im_inbox'}</a> <a href="$cgi&action=imoutbox">$img{'im_outbox'}</a> <a href="$cgi&action=imsend">$img{'im_new'}</a> <a href="$cgi&action=im">$img{'im_reload'}</a>
</td>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
 <tr>
  <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'323'}</b></font></td>
 </tr>
 <tr>
  <td class="windowbg" bgcolor="$color{'windowbg'}">
   <form action="$cgi&action=imprefs2" method=post>
    <table border=0>
     <tr>
      <td valign=top>
       <font size=2><b>$txt{'325'}:</b></font><br><font size=1>$txt{'326'}</font>
      </td>
      <td>
       <font size=2><textarea name=ignore rows=10 cols=50 wrap=virtual>$imconfig[0]</textarea></font>
      </td>
     </tr>
     <tr>
      <td valign=top>
       <font size=2><b>$txt{'327'}:</b></font>
      </td>
      <td>
       <font size=2>
	<select name="notify">
	 <option value="0"$sel0>$txt{'164'}
	 <option value="1"$sel1>$txt{'163'}
	</select>
       </font>
      </td>
     </tr>
     <tr>
      <td>
      	&nbsp;
      </td>
      <td>
       <input type=submit value="$txt{'328'}">
       <input type=reset value="$txt{'329'}">
      </td>
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

sub IMPreferences2 {
	if($username eq 'Guest') { &fatal_error($txt{'147'}); }
	my( $ignorelist, $notify );
	$ignorelist = "$FORM{'ignore'}";
	$notify = "$FORM{'notify'}";

	$ignorelist =~ s~\A\n\s*~~;
	$ignorelist =~ s~\s*\n\Z~~;
	$ignorelist =~ s~\n\s*\n~\n~g;
	$ignorelist =~ s~[\n\r]~\|~g;
	$ignorelist =~ s~\|\|~\|~g;
	$notify =~ s~[\n\r]~~g;

	fopen(FILE, "+>$memberdir/$username.imconfig");
	print FILE "$ignorelist\n$notify\n";
	fclose(FILE);
	$yySetLocation = qq~$cgi&action=imprefs~;
	&redirectexit;
}

sub KillAll {
	if($username eq 'Guest') { &fatal_error($txt{'147'}); }
	if ($INFO{'caller'} == 1) {
		unlink("$memberdir/$username.msg");
		$redirect = 'im';
	} elsif ($INFO{'caller'} == 2) {
		unlink("$memberdir/$username.outbox");
		$redirect = 'imoutbox';
	}
	$yySetLocation = qq~$cgi&action=$redirect~;
	&redirectexit;
}

sub KillAllQuery {
	if($username eq 'Guest') { &fatal_error($txt{'147'}); }
	my( $query, $cgi2 );
	if ($INFO{'caller'} == 1) {
		$yytitle .= $txt{'316'};
		$imbox = $txt{'316'};
		$cgi2 = "$cgi&action=imremoveall2&caller=1";
		$cgi .= "&action=im";
	} elsif ($INFO{'caller'} == 2) {
		$imbox = $txt{'320'};
		$cgi2 = "$cgi&action=imremoveall2&caller=2";
		$cgi .= "&action=imoutbox";
	}
	$txt{'412'} =~ s~IMBOX~$imbox~g;
	$img{'im_delete'} =~ s~IMBOX~$imbox~g;
	&header;
	$yytitle = $txt{'412'};
	print <<"EOT";
<table border=0 width="80%" cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
<tr>
	<td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'412'}</b></font></td>
</tr>
<tr>
	<td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>
$txt{'413'}<br>
<b><a href="$cgi2">$txt{'163'}</a> - <a href="$cgi">$txt{'164'}</a></b>
</font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

1;