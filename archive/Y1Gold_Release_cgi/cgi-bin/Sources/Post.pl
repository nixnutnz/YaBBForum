###############################################################################
# Post.pl                                                                     #
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

$postplver="1 Gold - Release";

sub Post {
	if($username eq 'Guest' && $enable_guestposting == 0) { &fatal_error($txt{'165'}); }
	if( $currentboard eq '' ) { &fatal_error($txt{'1'}); }
	my( $notification, $x, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate, $msubject, $mattach, $mip, $mmessage, $mns, $name_field, $email_field, $form_message, $quotestart, $form_subject );

	my $threadid = $INFO{'num'};
	my $quotemsg = $INFO{'quote'};
	
	($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$yyThreadLine);
	if( $mstate == 1 ) { &fatal_error($txt{'90'}); }

	# Determine what category we are in.
	fopen(FILE, "$boardsdir/$currentboard.ctb") || &fatal_error("300 $txt{'106'}: $txt{'23'} $currentboard.ctb");
	$cat = <FILE>;
	fclose(FILE);
	$curcat = $cat;
	fopen(FILE, "$boardsdir/$cat.cat") || &fatal_error("300 $txt{'106'}: $txt{'23'} $cat.cat");
	$cat = <FILE>;
	fclose(FILE);

	$notification = ! $enable_notification || $username eq 'Guest' ? '' : <<"EOT";
<tr>
	<td align="right"><font size=2><b>$txt{'131'}:</b></font></td>
	<td><font size=2><input type=checkbox name="notify" value="x"></font></td>
</tr>
EOT

	$yytitle=$INFO{'title'};
	&header;

	$name_field = $realname eq '' ? qq~<input type=text name=name size=25 value="$form_name" maxlength="25">~ : qq~$realname~;

	$email_field = $realemail eq '' ? qq~<input type=text name=email size=25 value="$form_name" maxlength="30">~ : qq~$realemail~;

	if( $threadid ne '' ) {
		fopen(FILE, "$datadir/$threadid.txt") || &fatal_error("201 $txt{'106'}: $txt{'23'} $threadid.txt");
		@messages = <FILE>;
		fclose(FILE);

		if($quotemsg ne '') {
			($msubject, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns) = split(/\|/,$messages[$quotemsg]);
			$form_message=$mmessage;
			$form_message =~ s~<br>~\n~g;
			$form_message =~ s~\n{0,1}\[quote([^\]]*)\](.*?)\[/quote\]\n{0,1}~\n~isg;
			$form_message =~ s~\n*\[/*quote([^\]]*)\]\n*~~ig;

			$mname ||= $musername || $txt{'470'};
			$quotestart = int( $quotemsg / $maxmessagedisplay ) * $maxmessagedisplay;
			$form_message = qq~\n\n\[quote author=$mname link=board=$currentboard&num=$threadid&start=$quotestart#$quotemsg date=$mdate\]\n$form_message\n\[/quote\]~;
			$msubject =~ s/\bre:\s+//ig;
			$form_subject = "Re: $msubject";
		}
		else {
			($msubject, $mname, $memail, $mdate, $musername, $micon, $mattache, $mip, $mmessage, $mns) = split(/\|/,$messages[0]);
			$msubject =~ s/\bre:\s+//ig;
			$form_subject = "Re: $msubject";
		}
	}
	if(!$form_subject) { $sub = "<i>$txt{'33'}</i>"; }
	else { $sub = "$form_subject"; }
	print <<"EOT";
<script language="JavaScript1.2" src="$ubbcjspath" type="text/javascript"></script>

<script language="JavaScript1.2" type="text/javascript">
<!--
function showimage()
{
	document.images.icons.src="$imagesdir/"+document.postmodify.icon.options[document.postmodify.icon.selectedIndex].value+".gif";
}
//-->
</script>
<table  width="700" align="center" cellpadding=0 cellspacing=0>
  <tr>
    <td valign=bottom colspan="2">
    <font size=2 class="nav"><B><img src="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    <a href="$scripturl" class="nav">$mbname</a><br>
    <img src="$imagesdir/tline.gif" border=0><IMG SRC="$imagesdir/open.gif"  border=0>&nbsp;&nbsp;
    <a href="$scripturl#$curcat" class="nav">$cat</a><br>
    <img src="$imagesdir/tline2.gif" border=0><IMG SRC="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    <a href="$cgi" class="nav">$boardname</a><br>
    <img SRC="$imagesdir/tline3.gif" border=0><IMG SRC="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    $INFO{'title'} ( $sub )</td>
  </tr>
</table>
<table border=0  width="700" align="center" cellspacing=1 cellpadding="3" bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$yytitle</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}">
    <form action="$cgi&action=post2" method="post" name="postmodify" onSubmit="submitonce(this);">
    <input type="hidden" name="threadid" value="$threadid">
    <table border=0 cellpadding="3">
      <tr>
        <td align="right"><font size=2><b>$txt{'68'}:</b></font></td>
        <td><font size=2>$name_field</font></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'69'}:</b></font></td>
        <td><font size=2>$email_field</font></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'70'}:</b></font></td>
        <td><font size=2><input type=text name="subject" value="$form_subject" size="40" maxlength="50"></font></td>
      </tr><tr>
	<td align="right"><font size=2><b>$txt{'71'}:</b></font></td>
	<td>
<select name="icon" onChange="showimage()">
	<option value="xx">$txt{'281'}
	<option value="thumbup">$txt{'282'}
	<option value="thumbdown">$txt{'283'}
	<option value="exclamation">$txt{'284'}
	<option value="question">$txt{'285'}
	<option value="lamp">$txt{'286'}
	<option value="smiley">$txt{'287'}
	<option value="angry">$txt{'288'}
	<option value="cheesy">$txt{'289'}
	<option value="laugh">$txt{'290'}
	<option value="sad">$txt{'291'}
	<option value="wink">$txt{'292'}
	</select>
	<img src="$imagesdir/xx.gif" name="icons" border=0 hspace=15></td>
</tr>
EOT
if( $enable_ubbc && $showyabbcbutt) {
	print << "EOT";
<tr>
<td align="right"><font size=2><b>$txt{'252'}:</b></font></td>
<td valign=middle>

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
<br>

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
<td valign=middle>
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
	<td valign=top align="right"><font size=2><b>$txt{'72'}:</b></font></td>
	<td><textarea name=message rows=12 cols=60 wrap="virtual" ONSELECT="javascript:storeCaret(this);" ONCLICK="javascript:storeCaret(this);" ONKEYUP="javascript:storeCaret(this);" ONCHANGE="javascript:storeCaret(this);">$form_message</textarea></td>
</tr>
$notification
<tr>
	<td align="right"><font size=2><b>$txt{'276'}:</b></font><BR><BR></td>
	<td><input type=checkbox name="ns" value="NS"> <font size=1> $txt{'277'}</font><BR><BR></td>
</tr>
<tr>
	<td align="center" colspan="2">
	<input type="hidden" name="waction" value="post">
	<input type="submit" name="post" value="$txt{'105'}" onClick="WhichClicked('post');">
	<input type="submit" name="preview" value="$txt{'507'}" onClick="WhichClicked('preview');">
	<input type="reset" value="$txt{'278'}">
	</td>
</tr>
<tr>
<td colspan=2></td>
</tr>
</table></form>
</td>
</tr>
</table>
EOT
	&doshowthread;
	&footer;
	exit;
}

sub Preview {
	$name = $FORM{'name'};
	$email = $FORM{'email'};
	$subject = $FORM{'subject'};
	$message = $FORM{'message'};
 	$icon = $FORM{'icon'};
	$ns = $FORM{'ns'};
	$threadid = $FORM{'threadid'};
	$notify = $FORM{'notify'};
	if (length($subject) > 50) { $subject = substr($subject,0,50); }
	$subject =~ s/\&/\&amp;/g;
	$subject =~ s/"/\&quot;/g;
	$subject =~ s/  / \&nbsp;/g;
	$subject =~ s/</&lt;/g;
	$subject =~ s/>/&gt;/g;
	$subject =~ s/\|/\&#124;/g;
	$message =~ s/\cM//g;
	$message =~ s~\[([^\]]{0,30})\n([^\]]{0,30})\]~\[$1$2\]~g;
	$message =~ s~\[/([^\]]{0,30})\n([^\]]{0,30})\]~\[/$1$2\]~g;
	$message =~ s~(\w+://[^<>\s\n\"\]\[]+)\n([^<>\s\n\"\]\[]+)~$1$2~g;
	$message =~ s/\&/\&amp;/g;
	$message =~ s/"/\&quot;/g;
	$message =~ s/  / \&nbsp;/g;
	$message =~ s/</&lt;/g;
	$message =~ s/>/&gt;/g;
	$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
	$message =~ s/\n/<br>/g;
	$message =~ s/\|/\&#124;/g;
	&CheckIcon;

	if ($username eq 'Guest') {
		fopen(FILE, "$memberdir/memberlist.txt") || &fatal_error("202 $txt{'106'}: $txt{'23'} memberlist.txt");
		@memberlist = <FILE>;
		fclose(FILE);
		$testname = lc $name;
		for ($a = 0; $a < @memberlist; $a++) {
			chomp $memberlist[$a];
			$membername = lc $memberlist[$a];
			if( fopen(FILE2, "$memberdir/$memberlist[$a].dat") ) {
				$tmpa = <FILE2>;
				$realname = <FILE2>;
				fclose(FILE2);
				chomp $realname;
				$realname = lc $realname;
				if ($realname eq $testname || $membername eq $testname) { &fatal_error($txt{'100'}); }
			}
			elsif( $testname eq $membername ) { &fatal_error($txt{'100'}); }
		}
		fopen(FILE, "$vardir/reserve.txt") || &fatal_error("203 $txt{'106'}: $txt{'23'} reserve.txt");
		@reserve = <FILE>;
		fclose(FILE);
		fopen(FILE, "$vardir/reservecfg.txt") || &fatal_error("204 $txt{'106'}: $txt{'23'} reservecfg.txt");
		@reservecfg = <FILE>;
		fclose(FILE);
		for( $a = 0; $a < @reservecfg; $a++ ) {
			chomp $reservecfg[$a];
		}
		$matchword = $reservecfg[0] eq 'checked';
		$matchcase = $reservecfg[1] eq 'checked';
		$matchuser = $reservecfg[2] eq 'checked';
		$matchname = $reservecfg[3] eq 'checked';
		$namecheck = $matchcase eq 'checked' ? $name : lc $name;
		foreach $reserved (@reserve) {
			chomp $reserved;
			$reservecheck = $matchcase ? $reserved : lc $reserved;
			if ($matchname) {
				if ($matchword) {
					if ($namecheck eq $reservecheck) { &fatal_error("$txt{'244'} $reserved"); }
				}
				else {
					if ($namecheck =~ $reservecheck) { &fatal_error("$txt{'244'} $reserved"); }
				}
			}
		}
	}
	if($enable_ubbc) { &DoUBBC; }
	$message =~ s~(\S{80})(?=\S)~$1\n~g;
	if( $FORM{'waction'} eq 'previewmodify' ) {
		$destination = 'modify2';
		$submittxt = $txt{'10'};
	}
	elsif( $FORM{'waction'} eq 'previewim' ) {
		$destination = 'imsend2';
		$submittxt = $txt{'148'};
	}
	else {
		$destination = 'post2';
		$submittxt = $txt{'105'};
	}

	$csubject = $subject;
	
	# Load Censor List
	&LoadCensorList;

	$csubject =~ s/\Q$tmpa\E/$tmpb/gi;
	$message =~ s/\Q$tmpa\E/$tmpb/gi;
	
	$yytitle = "$txt{'507'} - $csubject";
	
	&header;
	print<<"EOT";
<script language="JavaScript1.2" src="$ubbcjspath" type="text/javascript"></script>
<table border=0 width="70%" cellspacing=1 cellpadding="3" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$csubject</font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>$message</font></td>
  </tr><tr>
    <td align="center" valign="middle" bgcolor="$color{'titlebg'}">
    <form action="$cgi&action=$destination" method="post" name="postmodify" onSubmit="submitonce(this);">
    <input type="hidden" name="threadid" value="$FORM{'threadid'}">
    <input type="hidden" name="postid" value="$FORM{'postid'}">
    <input type="hidden" name="name" value="$FORM{'name'}">
    <input type="hidden" name="email" value="$FORM{'email'}">
    <input type="hidden" name="subject" value="$FORM{'subject'}">
    <input type="hidden" name="notify" value="$FORM{'notify'}">
EOT
	$FORM{'message'} =~ s/\&/\&amp;/g;
	$FORM{'message'} =~ s/"/\&quot;/g;
	$FORM{'message'} =~ s/  / \&nbsp;/g;
	$FORM{'message'} =~ s/</&lt;/g;
	$FORM{'message'} =~ s/>/&gt;/g;
	$FORM{'message'} =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
	$FORM{'message'} =~ s/\cM//g;
	$FORM{'message'} =~ s~(\S{80})(?=\S)~$1\n~g;
	$FORM{'message'} =~ s/\|/\&#124;/g;
print<<"EOT";
    <input type="hidden" name="to" value="$FORM{'to'}">
    <input type="hidden" name="message" value="$FORM{'message'}">
    <input type="hidden" name="icon" value="$FORM{'icon'}">
    <input type="hidden" name="ns" value="$FORM{'ns'}">
    <input type="submit" name="donepreview" value="$submittxt">
    </td>
  </tr>
</table>
<center><BR><a href="javascript:history.go(-1)">$txt{'250'}</a></center>
</form>
EOT
&footer;
exit;
}

sub Post2 {
	if($username eq 'Guest' && $enable_guestposting == 0) {	&fatal_error($txt{'165'}); }
	my( $email, $subject, $icon, $ns, $threadid, $notify, @memberlist, $a, $realname, $membername, $testname, @reserve, @reservecfg, $matchword, $matchcase, $matchuser, $matchname, $namecheck, $reserved, $reservecheck, $newthreadid, @messages, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate, $start, $pageindex, $tempname );

	# If poster is a Guest then evaluate the legality of name and email
	if(!$settings[2]) {
		$FORM{'name'} =~ s/\A\s+//;
		$FORM{'name'} =~ s/\s+\Z//;
		&fatal_error($txt{'75'}) unless ($FORM{'name'} ne '' && $FORM{'name'} ne '_' && $FORM{'name'} ne ' ');
		&fatal_error($txt{'568'}) if(length($FORM{'name'}) > 25);
		&fatal_error("$txt{'76'}") if($FORM{'email'} eq '');
		&fatal_error($txt{'243'}) if($FORM{'email'} !~ /^[0-9A-Za-z@\._\-]+$/);
		&fatal_error("$txt{'500'}") if(($FORM{'email'} =~ /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|(\.$)/) || ($FORM{'email'} !~ /^.+@\[?(\w|[-.])+\.[a-zA-Z]{2,4}|[0-9]{1,4}\]?$/));
	}

	# Get the form values
	$name = $FORM{'name'};
	$email = $FORM{'email'};
	$subject = $FORM{'subject'};
	$message = $FORM{'message'};
 	$icon = $FORM{'icon'};
	$ns = $FORM{'ns'};
	$threadid = $FORM{'threadid'};
	if( $threadid =~ /\D/ ) { &fatal_error($txt{'337'}); }
	$notify = $FORM{'notify'};

	if($name && $email) {
		$name =~ s/\&/\&amp;/g;
		$name =~ s/"/\&quot;/g;
		$name =~ s/  / \&nbsp;/g;
		$name =~ s/</&lt;/g;
		$name =~ s/>/&gt;/g;
		$name =~ s/\|/\&#124;/g;
		$email =~ s/\&/\&amp;/g;
		$email =~ s/"/\&quot;/g;
		$email =~ s/  / \&nbsp;/g;
		$email =~ s/</&lt;/g;
		$email =~ s/>/&gt;/g;
		$email =~ s/\|//g;
		# let's hold it temporarily so we can put the _'s back later
		$tempname = $name;
		$name =~ s/\_/ /g;
	}

	&fatal_error($txt{'75'}) unless($username || $name);
	&fatal_error($txt{'76'}) unless($settings[2] || $email);
	&fatal_error($txt{'77'}) unless($subject && $subject !~ m~\A[\s_.,]+\Z~ );
	&fatal_error($txt{'78'}) unless($message);
	if (length($message)>$MaxMessLen) { &fatal_error($txt{'499'}); }

	if( $FORM{'waction'} eq 'preview' ) { &Preview; }
	&spam_protection;

	if (length($subject) > 50) { $subject = substr($subject,0,50); }
	$message =~ s/\cM//g;
	#$message =~ s~(\S{80})(?=\S)~$1\n~g;
	$message =~ s~\[([^\]]{0,30})\n([^\]]{0,30})\]~\[$1$2\]~g;
	$message =~ s~\[/([^\]]{0,30})\n([^\]]{0,30})\]~\[/$1$2\]~g;
	$message =~ s~(\w+://[^<>\s\n\"\]\[]+)\n([^<>\s\n\"\]\[]+)~$1\n$2~g;
	$subject =~ s/\&/\&amp;/g;
	$subject =~ s/"/\&quot;/g;
	$subject =~ s/  / \&nbsp;/g;
	$subject =~ s/</&lt;/g;
	$subject =~ s/>/&gt;/g;
	$subject =~ s/\|/\&#124;/g;
	$message =~ s/\&/\&amp;/g;
	$message =~ s/"/\&quot;/g;
	$message =~ s/  / \&nbsp;/g;
	$message =~ s/</&lt;/g;
	$message =~ s/>/&gt;/g;
	$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
	$message =~ s/\n/<br>/g;
	$message =~ s/\|/\&#124;/g;
	&CheckIcon;

	if(-e("$datadir/.txt")) { unlink("$datadir/.txt"); }

	if ($username ne 'Guest') {
		# If not guest, get name and email.
		$name = $settings[1];
		$email = $settings[2];
	} else {
		# If user is Guest, then make sure the chosen name
		# is not reserved or used by a member.
		#
		fopen(FILE, "$memberdir/memberlist.txt") || &fatal_error("206 $txt{'106'}: $txt{'23'} $memberlist.txt");
		@memberlist = <FILE>;
		fclose(FILE);
		$testname = lc $name;
		for ($a = 0; $a < @memberlist; $a++) {
			chomp $memberlist[$a];
			$membername = lc $memberlist[$a];
			if( fopen(FILE2, "$memberdir/$memberlist[$a].dat") ) {
				$tmpa = <FILE2>;
				$realname = <FILE2>;
				fclose(FILE2);
				chomp $realname;
				$realname = lc $realname;
				if ($realname eq $testname || $membername eq $testname) { &fatal_error($txt{'473'}); }
			}
			elsif( $testname eq $membername ) { &fatal_error($txt{'473'}); }
		}

		fopen(FILE, "$vardir/reserve.txt") || &fatal_error("207 $txt{'106'}: $txt{'23'} reserve.txt");
		@reserve = <FILE>;
		fclose(FILE);
		fopen(FILE, "$vardir/reservecfg.txt") || &fatal_error("208 $txt{'106'}: $txt{'23'} reservecfg.txt");
		@reservecfg = <FILE>;
		fclose(FILE);
		for( $a = 0; $a < @reservecfg; $a++ ) {
			chomp $reservecfg[$a];
		}
		$matchword = $reservecfg[0] eq 'checked';
		$matchcase = $reservecfg[1] eq 'checked';
		$matchuser = $reservecfg[2] eq 'checked';
		$matchname = $reservecfg[3] eq 'checked';
		$namecheck = $matchcase eq 'checked' ? $name : lc $name;

		foreach $reserved (@reserve) {
			chomp $reserved;
			$reservecheck = $matchcase ? $reserved : lc $reserved;
			if ($matchname) {
				if ($matchword) {
					if ($namecheck eq $reservecheck) { &fatal_error("$txt{'244'} $reserved"); }
				}
				else {
					if ($namecheck =~ $reservecheck) { &fatal_error("$txt{'244'} $reserved"); }
				}
			}
		}
		$name = $tempname; # put the name back (with any _'s) now that we've checked it
	}


	# If no thread specified, this is a new thread.
	# Find a valid random ID for it.
	if($threadid eq '') {
		$newthreadid = time;
		$i=0;
		if (-e "$datadir/$newthreadid.txt") {
			while (-e "$datadir/$newthreadid$i.txt") { ++$i; }
			$newthreadid="$newthreadid$i";
		}
	}
	else { $newthreadid = ''; }

	fopen(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("209 $txt{'106'}: $txt{'23'} $boardsdir/$currentboard.txt");
	@messages = <FILE>;
	fclose(FILE);

	if($newthreadid) {
		# This is a new thread. Save it.
		fopen(FILE, ">$boardsdir/$currentboard.txt", 1) || &fatal_error("210 $txt{'106'}: $txt{'23'} $currentboard.txt");
		print FILE qq~$newthreadid|$subject|$name|$email|$date|0|$username|$icon|0\n~;
		print FILE @messages;
		fclose(FILE);
		fopen(FILE, ">$datadir/$newthreadid.txt") || &fatal_error("$txt{'23'} $newthreadid.txt");
		print FILE qq~$subject|$name|$email|$date|$username|$icon|0|$ENV{REMOTE_ADDR}|$message|$ns|\n~;
		fclose(FILE);
		$mreplies = 0;
	} else {
		# This is an old thread. Save it.
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$yyThreadLine);
		if( $mstate == 1 ) { &fatal_error($txt{'90'}); }
		++$mreplies;
		$messages[$yyThreadPosition] = '';
		fopen(FILE, ">$boardsdir/$currentboard.txt", 1) || &fatal_error("211 $txt{'106'}: $txt{'23'} $currentboard.txt");
		print FILE qq~$mnum|$msub|$mname|$memail|$date|$mreplies|$musername|$micon|$mstate\n~;
		print FILE @messages;
		fclose(FILE);
		fopen(FILE, ">>$datadir/$threadid.txt") || &fatal_error("212 $txt{'106'}: $txt{'23'} $threadid.txt");
		print FILE qq~$subject|$name|$email|$date|$username|$icon|0|$ENV{REMOTE_ADDR}|$message|$ns|\n~;
		fclose(FILE);
	}

	if($username ne 'Guest') {
		# Increment post count for the member.
		$settings[6] =~ s/[\n\r]//g;
		++$settings[6];
		fopen(FILE, ">$memberdir/$username.dat") || &fatal_error("213 $txt{'106'}: $txt{'23'} $username.dat");
		foreach (@settings) {
			print FILE qq~$_\n~;
		}
		fclose(FILE);
	}

	# The thread ID, regardless of whether it's a new thread or not.
	$thread = $newthreadid || $threadid;

	# Update totals for this board.
	&doaddition;
	
	# Notify any members who have notification turned on for this thread.
	if(-e("$datadir/$thread.mail")) {
		&NotifyUsers;
	}

	# Mark thread as read for the member.
	&dumplog($currentboard,$date);

	# Let's figure out what page number to show
	$start = 0;
	$pageindex = int($mreplies / $maxmessagedisplay);
	$start = $pageindex * $maxmessagedisplay;

	if( $notify ) {
		$INFO{'thread'} = $thread;
		$INFO{'start'} = $start;
		require "$sourcedir/Notify.pl";
		Notify2();
	}
	$yySetLocation = qq~$cgi&action=display&num=$thread&start=$start~;
	&redirectexit;
}

sub NotifyUsers {
	$subject = $FORM{'subject'};
	
	fopen(FILE, "$datadir/$thread.mail") || return 0;
	@mails = <FILE>;
	fclose(FILE);
	foreach $curmail (@mails) {
		chomp $curmail;
		if ($curmail ne $settings[2]) {
			&sendmail($curmail,"$txt{'127'}\:  $subject","$txt{'128'}, $subject, $txt{'129'} $cgi&action=display&num=$thread\n\n$txt{'130'}");
		}
	}
	return 1;
}

sub doshowthread {
	my( $line, $trash, $tempname, $tempdate, $temppost );
	
	# Load Censor List
	&LoadCensorList;

	if (@messages) {
		print qq~
	<BR><BR>
	<table cellspacing=1 cellpadding=0 width="700" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor">
	<tr><td>
	<table class="windowbg" cellspacing=1 cellpadding=2 width=100% align=center bgcolor="$color{'windowbg'}">
	<tr><td class="titlebg" bgcolor="$color{'titlebg'}" colspan=2><font size=2 class="text1" color="$color{'titletext'}">
	<b>$txt{'468'}</b>
	</td></tr>~;
		foreach $line (@messages) { #start for each

			($trash, $tempname, $trash, $tempdate, $trash, $trash, $trash, $trash, $message, $ns) = split(/\|/,$line);
			$tempdate = &timeformat($tempdate);
			foreach (@censored) {
				($tmpa,$tmpb) = @{$_};
				$message =~ s~\Q$tmpa\E~$tmpb~gi;
			}
			if($enable_ubbc) { &DoUBBC; }
			print qq~

<tr><td align=left class="catbg">
<font size=1>$txt{'279'}: $tempname</font></td>
<td class="catbg" align=right>
<font size=1>$txt{'280'}: $tempdate</font></td>
</tr>
<tr><td class="windowbg2" colspan=2 bgcolor="$color{'windowbg2'}">
<font size=1>$message</font>
</td></tr>~;
		}
		print "</table></td></tr></table>\n";
	}
	else { print "<!--no summary-->"; }
}

sub doaddition {
	fopen(FILE, "+>$boardsdir/$currentboard.poster");
	print FILE $name;
	fclose(FILE);

	fopen(FILE2, "$datadir/$thread.data");
	$tempinfo = <FILE2>;
	fclose(FILE2);

	($views, $lastposter) = split(/\|/,$tempinfo);

	my( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
	++$messagecount;
	unless( $FORM{'threadid'} ) {
		++$threadcount;
	}
	$myname = $username eq 'Guest' ? qq~Guest-$name~ : $username;
	&BoardCountSet( $currentboard, $threadcount, $messagecount, $date, $myname );

	fopen(FILE2, "+>$datadir/$thread.data");
	print FILE2 "$views|$myname";
	fclose(FILE2);
}

1;
