###############################################################################
# Post.pl                                                                     #
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

$postplver = "1 Gold - SP 1.1";

sub Post {
	if($username eq 'Guest' && $enable_guestposting == 0) { &fatal_error($txt{'165'}); }
	if( $currentboard eq '' ) { &fatal_error($txt{'1'}); }
	my( $subtitle, $x, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate, $msubject, $mattach, $mip, $mmessage, $mns, $quotestart);
	my $quotemsg = $INFO{'quote'};
	$threadid = $INFO{'num'};

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

	$notification = ! $enable_notification || $username eq 'Guest' ? '' : <<"~;";
    <tr>
      <td class="windowbg"><font size=2><b>$txt{'131'}:</b></font></td>
      <td class="windowbg"><input type=checkbox name="notify" value="x"$notify> <font size="1">$txt{'750'}</font></td>
    </tr>
~;

	$name_field = $realname eq '' ? qq~      <tr>
    <td class="windowbg"><font size=2><b>$txt{'44'}:</b></font></td>
    <td class="windowbg"><input type=text name="name" size=25 value="$FORM{'name'}" maxlength="25" onMouseOver="this.focus()" tabindex="2"></td>
      </tr>~ : qq~~;

	$email_field = $realemail eq '' ? qq~      <tr>
    <td class="windowbg"><font size=2><b>$txt{'69'}:</b></font></td>
    <td class="windowbg"><font size="2"><input type=text name="email" size=25 value="$FORM{'email'}" maxlength="40" onMouseOver="this.focus()" tabindex="3"></font></td>
      </tr>~ : qq~~;

	$sub = "";
	$settofield="subject";
	if( $threadid ne '' ) {
		fopen(FILE, "$datadir/$threadid.txt") || &fatal_error("201 $txt{'106'}: $txt{'23'} $threadid.txt");
		@messages = <FILE>;
		fclose(FILE);

		if($quotemsg ne '') {
			($msubject, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns) = split(/\|/,$messages[$quotemsg]);
			$message=$mmessage;
			$message =~ s~<br>~\n~g;
			$message =~ s~\n{0,1}\[quote([^\]]*)\](.*?)\[/quote\]\n{0,1}~\n~isg;
			$message =~ s~\n*\[/*quote([^\]]*)\]\n*~~ig;

			$mname ||= $musername || $txt{'470'};
			$quotestart = int( $quotemsg / $maxmessagedisplay ) * $maxmessagedisplay;
			$message = qq~[quote author=$mname link=board=$currentboard;num=$threadid;start=$quotestart#$quotemsg date=$mdate\]$message\[/quote\]\n~;
			$msubject =~ s/\bre:\s+//ig;
			if ($mns eq "NS") {$nscheck="checked";}
		}
		else {
			($msubject, $mname, $memail, $mdate, $musername, $micon, $mattache, $mip, $mmessage, $mns) = split(/\|/,$messages[0]);
			$msubject =~ s/\bre:\s+//ig;
		}
		$sub = "Re: $msubject";
		$settofield="message";
	}
	if(!$sub) { $subtitle = "<i>$txt{'33'}</i>"; }
	else { $subtitle = "<i>$sub</i>"; }
	$yymain .= qq~
<table  width="90%" align="center" cellpadding=0 cellspacing=0>
  <tr>
    <td valign=bottom colspan="2">
    <font size=2 class="nav"><B><img src="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    <a href="$scripturl" class="nav">$mbname</a><br>
    <img src="$imagesdir/tline.gif" border=0><IMG SRC="$imagesdir/open.gif"  border=0>&nbsp;&nbsp;
    <a href="$scripturl#$curcat" class="nav">$cat</a><br>
    <img src="$imagesdir/tline2.gif" border=0><IMG SRC="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    <a href="$cgi" class="nav">$boardname</a><br>
    <img SRC="$imagesdir/tline3.gif" border=0><IMG SRC="$imagesdir/open.gif" border=0>&nbsp;&nbsp;
    $INFO{'title'} ( $subtitle )</td>
  </tr>
</table>
~;
	$submittxt = "$txt{'105'}";
	$destination = "post2";
	$icon = "xx";
	$waction = "post";
	$post = "post";
	$preview = "preview";
	$yytitle = "$INFO{'title'}";
	&Postpage;
	&doshowthread;
	&template;
	exit;
}

sub Postpage {
	my $extra;
	if ($FORM{'waction'} =~ /preview/) {$txt{'507'}=$txt{'771'};}
	if($waction eq "imsend") {
		if(!$INFO{'to'}) { $INFO{'to'} = $FORM{'to'};}
		if($INFO{'to'}) {$settofield="message";} else {$settofield="to";}
		$extra = qq~
      <tr>
        <td class="windowbg" bgcolor="$color{'windowbg'}" width="23%"><font size=2><b>$txt{'150'}</b></font></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}">
	<input type=text name="to" value="$INFO{'to'}" size="20" maxlength="50" onMouseOver="this.focus()" tabindex="2">
	<font size="1">$txt{'748'}</font></td>
      </tr>
	~;

	}
	else {
	 $extra = qq~
      <tr>
        <td class="windowbg" bgcolor="$color{'windowbg'}" width="23%"><font size=2><b>$txt{'71'}:</b></font></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}">
        <select name="icon" onChange="showimage()">
         <option value="xx"$ic1>$txt{'281'}
         <option value="thumbup"$ic2>$txt{'282'}
         <option value="thumbdown"$ic3>$txt{'283'}
         <option value="exclamation"$ic4>$txt{'284'}
         <option value="question"$ic5>$txt{'285'}
         <option value="lamp"$ic6>$txt{'286'}
         <option value="smiley"$ic7>$txt{'287'}
         <option value="angry"$ic8>$txt{'288'}
         <option value="cheesy"$ic9>$txt{'289'}
         <option value="laugh"$ic10>$txt{'290'}
         <option value="sad"$ic11>$txt{'291'}
         <option value="wink"$ic12>$txt{'292'}
        </select>
        <img src="$imagesdir/$icon.gif" name="icons" border=0 hspace=15></td>
      </tr>
	 ~;
	if ($realname eq '' && $threadid ne '') {$settofield="name";}
	}
	$yymain .= qq~
<table border=0 width="90%" cellspacing="1" cellpadding="0" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td bgcolor="$color{'bordercolor'}">
<script language="JavaScript1.2" src="$ubbcjspath" type="text/javascript"></script>
<script language="JavaScript1.2" type="text/javascript">
<!--
function showimage() {
   document.images.icons.src="$imagesdir/"+document.postmodify.icon.options[document.postmodify.icon.selectedIndex].value+".gif";
}
//-->
</script>
    <form action="$cgi;action=$destination" method="post" name="postmodify" onSubmit="submitonce(this);">
    <input type="hidden" name="threadid" value="$threadid">
    <input type=hidden name="postid" value="$postid">
    <table class="titlebg" bgcolor="$color{'titlebg'}" width="100%">
      <tr>
        <td><font size=2 class="text1" color="$color{'titletext'}"><b>$yytitle</b></font></td>
      </tr>
    </table>
    </td>
  </tr><tr>
    <td bgcolor="$color{'bordercolor'}">
    <table width="100%" cellpadding="3" cellspacing="0" bgcolor="$color{'windowbg'}" class="windowbg">
      <tr>
        <td class="windowbg" bgcolor="$color{'windowbg'}" width="23%"><font size=2><b>$txt{'70'}:</b></font></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><input type=text name="subject" value="$sub" size="40" maxlength="50" onMouseOver="this.focus()" tabindex="1"></font></td>
      </tr>
$name_field
$email_field
$extra
    </table>
    </td>
   </tr>
~;
if($enable_ubbc && $showyabbcbutt) {
	$yymain .= qq~
  <tr>
    <td bgcolor="$color{'bordercolor'}">
    <table width="100%" cellpadding="3" cellspacing="0" bgcolor="$color{'windowbg2'}" class="windowbg2">
      <tr>
        <td class="windowbg2" bgcolor="$color{'windowbg2'}" width="23%"><font size=2><b>$txt{'252'}:</b></font></td>
        <td valign=middle class="windowbg2" bgcolor="$color{'windowbg2'}">
        <script language="JavaScript1.2" type="text/javascript">
        <!--
        if((navigator.appName == "Netscape" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Opera" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "WebTV Plus Receiver" && navigator.appVersion.charAt(0) >= 3)) {
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
        else { document.write("<font size='1'>$txt{'215'}</font>"); }
        //-->
        </script>
        <noscript>
        <font size="1">$txt{'215'}</font>
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
        if((navigator.appName == "Netscape" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "Opera" && navigator.appVersion.charAt(0) >= 4) || (navigator.appName == "WebTV Plus Receiver" && navigator.appVersion.charAt(0) >= 3)) {
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
        else { document.write("<font size='1'>$txt{'215'}</font>"); }
        //-->
        </script>
        <noscript>
        <font size="1">$txt{'215'}</font>
        </noscript>
        </td>
      </tr>
~;
}
else {
	$yymain .= qq~
      <tr>
        <td bgcolor="$color{'bordercolor'}" colspan="2">
        <table width="100%" cellpadding="3" cellspacing="0" bgcolor="$color{'windowbg'}" class="windowbg">
~;
}
	$yymain .= qq~
      <tr>
        <td class="windowbg2" bgcolor="$color{'windowbg2'}" width="23%"><font size=2><b>$txt{'297'}:</b></font></td>
        <td valign=middle class="windowbg2" bgcolor="$color{'windowbg2'}">
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
        else { document.write("<font size='1'>$txt{'215'}</font>"); }
        //-->
        </script>
        <noscript>
        <font size="1">$txt{'215'}</font>
        </noscript>
        </td>
      </tr><tr>
        <td valign=top class="windowbg2" bgcolor="$color{'windowbg2'}" width="23%"><font size=2><b>$txt{'72'}:</b></font></td>
        <td class="windowbg2" bgcolor="$color{'windowbg2'}"><font size="2">
        <textarea name="message" rows="12" cols="60" wrap="soft" ONCLICK="javascript:storeCaret(this);" ONKEYUP="javascript:storeCaret(this);" ONCHANGE="javascript:storeCaret(this);" onMouseOver="this.focus()" tabindex="4">$message</textarea>
        </font><BR><BR></td>
      </tr>
    </table>
    </td>
  </tr><tr>
    <td bgcolor="$color{'bordercolor'}">
    <table width="100%" cellpadding="3" cellspacing="0" bgcolor="$color{'windowbg'}" class="windowbg">
$notification
$lastmod
      <tr>
        <td class="windowbg" bgcolor="$color{'windowbg'}" width="23%"><font size=2><b>$txt{'276'}:</b></font><BR><BR></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}"><input type=checkbox name="ns" value="NS"$nscheck> <font size="1"> $txt{'277'}</font><BR><BR></td>
      </tr>
    </table>
    </td>
  </tr><tr>
    <td bgcolor="$color{'bordercolor'}">
    <table class="titlebg" bgcolor="$color{'titlebg'}" align="center" width="100%">
      <tr>
        <td align="center">
        <font size="1" class="text1" color="$color{'titletext'}"><font size="1">$txt{'329'}</font></font><BR>
		<input type="hidden" name="waction" value="$waction">
		<input type="submit" name="$post" value="$submittxt" onClick="WhichClicked('$post');" accesskey="s" tabindex="5">
		<input type="submit" name="$preview" value="$txt{'507'}" onClick="WhichClicked('$preview');" accesskey="p">
~;
unless ($FORM{'waction'} =~ /preview/){$yymain .= qq~		<input type="reset" value="$txt{'278'}" accesskey="r">~;}

$yymain.=qq~
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</form>
<script language="JavaScript"> <!--
   document.postmodify.$settofield.focus();
//--> </script>
~;
}

sub Preview {
	$name = $FORM{'name'};
	$email = $FORM{'email'};
	$sub = $FORM{'subject'};
	$mess = $FORM{'message'};
	$message = $FORM{'message'};
 	$icon = $FORM{'icon'};
	$ns = $FORM{'ns'};
	$threadid = $FORM{'threadid'};
	$notify = $FORM{'notify'};
	$postid = $FORM{'postid'};
	if (length($subject) > 50) { $sub = substr($subject,0,50); }
	&ToHTML($sub);
	$message =~ s/\cM//g;
	$message =~ s~\[([^\]]{0,30})\n([^\]]{0,30})\]~\[$1$2\]~g;
	$message =~ s~\[/([^\]]{0,30})\n([^\]]{0,30})\]~\[/$1$2\]~g;
	$message =~ s~(\w+://[^<>\s\n\"\]\[]+)\n([^<>\s\n\"\]\[]+)~$1$2~g;
	&ToHTML($message);
	$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
	$message =~ s/\n/<br>/g;
	&CheckIcon;

	if($icon eq "xx") { $ic1 = " selected"; }
	elsif($icon eq "thumbup") { $ic2 = " selected"; }
	elsif($icon eq "thumbdown") { $ic3 = " selected"; }
	elsif($icon eq "exclamation") { $ic4 = " selected"; }
	elsif($icon eq "question") { $ic5 = " selected"; }
	elsif($icon eq "lamp") { $ic6 = " selected"; }
	elsif($icon eq "smiley") { $ic7 = " selected"; }
	elsif($icon eq "angry") { $ic8 = " selected"; }
	elsif($icon eq "cheesy") { $ic9 = " selected"; }
	elsif($icon eq "laugh") { $ic10 = " selected"; }
	elsif($icon eq "sad") { $ic11 = " selected"; }
	elsif($icon eq "wink") { $ic12 = " selected"; }

	$name_field = $realname eq '' ? qq~      <tr>
    <td class="windowbg"><font size=2><b>$txt{'44'}:</b></font></td>
    <td class="windowbg"><input type=text name="name" size=25 value="$FORM{'name'}" maxlength="25" tabindex="2"></td>
      </tr>~ : qq~~;

	$email_field = $realemail eq '' ? qq~      <tr>
    <td class="windowbg"><font size=2><b>$txt{'69'}:</b></font></td>
    <td class="windowbg"><input type=text name="email" size=25 value="$FORM{'email'}" maxlength="40" tabindex="3"></td>
      </tr>~ : qq~~;
	if ($FORM{'notify'} eq "x") {$notify = " checked";}
	if ($FORM{'ns'} eq 'NS') {$nscheck = " checked";}

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
	&wrap;
	if($enable_ubbc) { if(!$yyYaBBCloaded) { require "$sourcedir/YaBBC.pl"; } &DoUBBC; }
	&wrap2;
	if( $FORM{'waction'} eq 'previewmodify' ) {
		$submittxt = "$txt{'10'}";
		$waction = "postmodify";
		$post = "postmodify";
		$preview = "previewmodify";
		$destination = 'modify2';
		$submittxt = $txt{'10'};
	}
	elsif( $FORM{'waction'} eq 'previewim' ) {
		$submittxt = "$txt{'148'}";
		$destination = "imsend2";
		$waction = "imsend";
		$post = "imsend";
		$preview = "previewim";
		$submittxt = $txt{'148'};
	}
	else {
		$notification = ! $enable_notification || $username eq 'Guest' ? '' : <<"~;";
    <tr>
      <td class="windowbg"><font size=2><b>$txt{'131'}:</b></font></td>
      <td class="windowbg"><input type=checkbox name="notify" value="x"$notify> <font size="1">$txt{'750'}</font></td>
    </tr>
~;
		$destination = 'post2';
		$submittxt = $txt{'105'};
		$waction = "post";
		$post = "post";
		$preview = "preview";
	}

	$csubject = $sub;
	&LoadCensorList;	# Load Censor List
	$csubject =~ s/\Q$tmpa\E/$tmpb/gi;
	$message =~ s/\Q$tmpa\E/$tmpb/gi;

	$yymain .= qq~
<script language="JavaScript1.2" type="text/javascript" src="$ubbcjspath"></script>
<script language="JavaScript1.2" type="text/javascript">
<!--
function showimage() {
   document.images.icons.src="$imagesdir/"+document.postmodify.icon.options[document.postmodify.icon.selectedIndex].value+".gif";
}
//-->
</script>
<table border=0 width="90%" cellspacing=1 cellpadding="3" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">
    <img src="$imagesdir/$icon.gif" name="icons" border=0> $csubject</font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><BR>$message<BR><BR></font></td>
  </tr>
</table>
<BR>
~;
	$message = $mess;
	$yytitle = "$txt{'507'} - $csubject";
	$settofield="message";
	&Postpage;
	&template;
	exit;
}

sub Post2 {
	if($username eq 'Guest' && $enable_guestposting == 0) {	&fatal_error($txt{'165'}); }
	my( $email, $subject, $ns, $threadid, $notify, @memberlist, $a, $realname, $membername, $testname, @reserve, @reservecfg, $matchword, $matchcase, $matchuser, $matchname, $namecheck, $reserved, $reservecheck, $newthreadid, @messages, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate, $start, $pageindex, $tempname );

	# If poster is a Guest then evaluate the legality of name and email
	if(!$settings[2]) {
		$FORM{'name'} =~ s/\A\s+//;
		$FORM{'name'} =~ s/\s+\Z//;
		&fatal_error($txt{'75'}) unless ($FORM{'name'} ne '' && $FORM{'name'} ne '_' && $FORM{'name'} ne ' ');
		&fatal_error($txt{'568'}) if(length($FORM{'name'}) > 25);
		&fatal_error("$txt{'76'}") if($FORM{'email'} eq '');
		&fatal_error("$txt{'240'} $txt{'69'} $txt{'241'}") if($FORM{'email'} !~ /^[0-9A-Za-z@\._\-]+$/);
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
		&ToHTML($name);
		$email =~ s/\|//g;
		&ToHTML($email);
		$tempname = $name;	# hold it temporarily so we can put the _'s back later
		$name =~ s/\_/ /g;
	}

	&fatal_error($txt{'75'}) unless($username || $name);
	&fatal_error($txt{'76'}) unless($settings[2] || $email);
	&fatal_error($txt{'77'}) unless($subject && $subject !~ m~\A[\s_.,]+\Z~);
	&fatal_error($txt{'78'}) unless($message);
	if (length($message)>$MaxMessLen) { &fatal_error($txt{'499'}); }

	if( $FORM{'waction'} =~ 'preview' ) { &Preview; }
	&spam_protection;

	if (length($subject) > 50) { $subject = substr($subject,0,50); }
	$message =~ s/\cM//g;
	$message =~ s~\[([^\]]{0,30})\n([^\]]{0,30})\]~\[$1$2\]~g;
	$message =~ s~\[/([^\]]{0,30})\n([^\]]{0,30})\]~\[/$1$2\]~g;
	$message =~ s~(\w+://[^<>\s\n\"\]\[]+)\n([^<>\s\n\"\]\[]+)~$1\n$2~g;
	&ToHTML($subject);
	&ToHTML($message);
	$message =~ s~\t~ \&nbsp; \&nbsp; \&nbsp;~g;
	$message =~ s~\n~<br>~g;
	&CheckIcon;

	if(-e("$datadir/.txt")) { unlink("$datadir/.txt"); }

	if ($username ne 'Guest') {
		# If not guest, get name and email.
		$name = $settings[1];
		$email = $settings[2];
	} else {
		# If user is Guest, then make sure the chosen name
		# is not reserved or used by a member.
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
		for( $a = 0; $a < @reservecfg; $a++ ) { chomp $reservecfg[$a]; }
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

	if($newthreadid) {
		# This is a new thread. Save it.
		fopen(FILE, "+<$boardsdir/$currentboard.txt") || &fatal_error("210 $txt{'106'}: $txt{'23'} $currentboard.txt");
		seek FILE, 0, 0;
		fopen(TEMP, "+>$boardsdir/$currentboard.txt.temp") || &fatal_error("209 $txt{'106'}: $txt{'23'} $boardsdir/$currentboard.txt.temp");
		while( read(FILE,$buffer,1024) ) { print TEMP $buffer; }
		seek TEMP, 0, 0;
		truncate FILE, 0;
		seek FILE, 0, 0;
		print FILE qq~$newthreadid|$subject|$name|$email|$date|0|$username|$icon|0\n~;
		while( read(TEMP,$buffer,1024) ) { print FILE $buffer; }
		fclose(TEMP);
		if (-e "$boardsdir/$currentboard.txt.temp") { unlink("$boardsdir/$currentboard.txt.temp"); }
		fclose(FILE);
		fopen(FILE, ">$datadir/$newthreadid.txt") || &fatal_error("$txt{'23'} $newthreadid.txt");
		print FILE qq~$subject|$name|$email|$date|$username|$icon|0|$user_ip|$message|$ns|\n~;
		fclose(FILE);
		$mreplies = 0;
	} else {
		# This is an old thread. Save it.
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$yyThreadLine);
		if( $mstate == 1 ) { &fatal_error($txt{'90'}); }
		++$mreplies;
		fopen(FILE, "+<$boardsdir/$currentboard.txt") || &fatal_error("211 $txt{'106'}: $txt{'23'} $currentboard.txt");
		seek FILE, 0, 0;
		fopen(TEMP, "+>$boardsdir/$currentboard.txt.temp") || &fatal_error("209 $txt{'106'}: $txt{'23'} $boardsdir/$currentboard.txt.temp");
		seek TEMP, 0, 0;
		while( read(FILE,$buffer,1024) ) {
			print TEMP $buffer;
		}
		truncate FILE, 0;
		seek FILE, 0, 0;
		print FILE qq~$mnum|$msub|$mname|$memail|$date|$mreplies|$musername|$micon|$mstate\n~;
		seek TEMP, 0, 0;
		my $new_count = 0;
		while( $line = <TEMP> ) {
			unless($new_count == $yyThreadPosition) { print FILE $line; }
			$new_count++;
		}
		fclose(TEMP);
		if (-e "$boardsdir/$currentboard.txt.temp") { unlink("$boardsdir/$currentboard.txt.temp"); }
		fclose(FILE);
		fopen(FILE, ">>$datadir/$threadid.txt") || &fatal_error("212 $txt{'106'}: $txt{'23'} $threadid.txt");
		print FILE qq~$subject|$name|$email|$date|$username|$icon|0|$user_ip|$message|$ns|\n~;
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
	if(-e("$datadir/$thread.mail")) { &NotifyUsers; }

	# Mark thread as read for the member.
	&dumplog($currentboard,$date);

	# Let's figure out what page number to show
	$start = 0;
	$pageindex = int($mreplies / $maxmessagedisplay);
	$start = $pageindex * $maxmessagedisplay;

	if($notify) {
		$INFO{'thread'} = $thread;
		$INFO{'start'} = $start;
		require "$sourcedir/Notify.pl";
		&Notify2;
	}
	$yySetLocation = qq~$cgi;action=display;num=$thread;start=$start~;
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
			&sendmail($curmail,"$txt{'127'}\:  $subject","$txt{'128'}, $subject, $txt{'129'} $cgi;action=display;num=$thread\n\n$txt{'130'}");
		}
	}
	return 1;
}

sub doshowthread {
	my( $line, $trash, $tempname, $tempdate, $temppost );

	&LoadCensorList;	# Load Censor List

	if (@messages) {
		$yymain .= qq~
	<BR><BR>
	<table cellspacing=1 cellpadding=0 width="90%" align="center" bgcolor="$color{'bordercolor'}" class="bordercolor">
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
			my @words = split(/\s/,$message);
			&wrap;
			$displayname = $tempname;
			if($enable_ubbc) { if(!$yyYaBBCloaded) { require "$sourcedir/YaBBC.pl"; } &DoUBBC; }
			&wrap2;
			$yymain .= qq~

<tr><td align=left class="catbg">
<font size="1">$txt{'279'}: $tempname</font></td>
<td class="catbg" align=right>
<font size="1">$txt{'280'}: $tempdate</font></td>
</tr>
<tr><td class="windowbg2" colspan=2 bgcolor="$color{'windowbg2'}">
<font size="1">$message</font>
</td></tr>~;
		}
		$yymain .= "</table></td></tr></table>\n";
	}
	else { $yymain .= "<!--no summary-->"; }
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