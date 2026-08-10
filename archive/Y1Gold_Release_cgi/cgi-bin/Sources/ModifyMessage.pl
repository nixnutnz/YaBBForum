###############################################################################
# ModifyMessage.pl                                                            #
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

$modifymessageplver="1 Gold - Release";

sub ModifyMessage {
	if($username eq 'Guest') { &fatal_error($txt{'223'}); }
	if( $currentboard eq '' ) { &fatal_error($txt{'1'}); }
	my( $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate, @messages, $curmessage, $msubject, $mattach, $mip, $mmessage, $mns, $mlm, $mlmb, $lastmodification, $nosmiley,  );
	my $threadid = $INFO{'thread'};
	my $postid = int( $INFO{'message'} );
	
	($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$yyThreadLine);
	if( $mstate == 1 ) {
		&fatal_error($txt{'90'});
	}

	$yytitle = "$txt{'66'}";

	fopen(FILE, "$datadir/$threadid.txt") || &fatal_error("$txt{'23'} $threadid.txt");
	@messages = <FILE>;
	fclose(FILE);

	$curmessage = $messages[$postid];
	chomp $curmessage;
	($msubject, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip,  $mmessage, $mns, $mlm, $mlmb) = split(/\|/,$messages[$postid]);

	if($musername ne $username && (!exists $moderators{$username}) && $settings[7] ne 'Administrator' ) {
		&fatal_error($txt{'67'});
	}

	$lastmodification = $mlm ? &timeformat($mlm) : '-';
	$nosmiley = $mns ? ' checked' : '';

	$mmessage =~ s/<br>/\n/ig;

	&header;
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

<table border=0  width="700" align="center" cellpadding="3" cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
<tr>
	<td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'66'}</b></font></td>
</tr>
<tr>
	<td class="windowbg" bgcolor="$color{'windowbg'}">
<form action="$cgi&action=modify2" method=post name="postmodify" onSubmit="submitonce(this);">
<input type=hidden name="postid" value="$postid">
<input type=hidden name="threadid" value="$threadid">
<table border="0" cellpadding="3">
<tr>
	<td align="right"><font size=2><b>$txt{'68'}:</b></font></td>
	<td><font size=2>$mname</font></td>
</tr>
<tr>
	<td align="right"><font size=2><b>$txt{'69'}:</b></font></td>
	<td><font size=2>$memail</font></td>
</tr>
<tr>
	<td align="right"><font size=2><b>$txt{'70'}:</b></font></td>
	<td><font size=2><input type=text name="subject" value="$msubject" size="40" maxlength="50"></font></td>
</tr>
<tr>
	<td align="right"><font size=2><b>$txt{'71'}:</b></font></td>
	<td>
<select name="icon" onChange="showimage()">
	<option value="$micon">$txt{'112'}
	<option value="$micon">------------
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
	<img src="$imagesdir/$micon.gif" name="icons" border=0 hspace=15></td>
</tr>
EOT
if($enable_ubbc && $showyabbcbutt) {
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
</td>
</tr>
<tr>
	<td valign=top align="right"><font size=2><b>$txt{'72'}:</b></font></td>
	<td><textarea name=message rows=12 cols=60 wrap="virtual" ONSELECT="javascript:storeCaret(this);" ONCLICK="javascript:storeCaret(this);" ONKEYUP="javascript:storeCaret(this);" ONCHANGE="javascript:storeCaret(this);">$mmessage</textarea></td>
</tr>
<tr>
	<td valign=top align="right"><font size=2><b>$txt{'211'}:</b></font></td>
	<td><font size=2>$lastmodification</td>
</tr>
<tr>
      <td align="right"><font size=2><b>$txt{'276'}:</b></font><BR><BR></td>
      <td><font size=2><input type=checkbox name="ns" value="NS"$nosmiley></font>
      <font size=1>$txt{'277'}</font><BR><BR></td>
</tr>
<tr>
	<td align=center colspan=2>
	<input type="hidden" name="waction" value="postmodify">
	<input type="submit" name="postmodify" value="$txt{'10'}" onClick="WhichClicked('postmodify');">
	<input type="submit" name="previewmodify" value="$txt{'507'}" onClick="WhichClicked('previewmodify');">
	<input type="submit" name="deletemodify" value="$txt{'31'}" onClick="WhichClicked('deletemodify');">
	<input type="reset" value="$txt{'278'}">
	</td>
</tr>
</table></form>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ModifyMessage2 {
	if($username eq 'Guest') { &fatal_error($txt{'223'}); }
	if( $FORM{'waction'} eq 'previewmodify' ) {
		require "$sourcedir/Post.pl";
		&Preview;
	}
	my( $deletepost, $threadid, $postid, @messages, $msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns, $mlm, $mlmb, $tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate, @threads, $tmpa, $tmpb, $tnum2, $tdate2, $newlastposttime, $newlastposter, $lastpostid, $views, $name, $email, $subject, $message, $ns, $postkilled, $threadkilled );
	$deletepost = $INFO{'d'} eq '1' || $FORM{'waction'} eq 'deletemodify';
	if( $deletepost ) {
		if( $FORM{'waction'} eq 'deletemodify' ) {
			$INFO{'id'} = $FORM{'postid'};
			$INFO{'thread'} = $FORM{'threadid'};
		}
		elsif( $INFO{'d'} eq 1 && $settings[7] ne 'Administrator' && ! exists $moderators{$username} ) {
			&fatal_error($txt{'73'});
		}
		$threadid = $INFO{'thread'};
		$postid = $INFO{'id'};
	}
	else {
		$threadid = $FORM{'threadid'};
		$postid = $FORM{'postid'};
	}

	fopen(FILE, "$datadir/$threadid.txt") || &fatal_error("$txt{'23'} $threadid.txt");
	@messages = <FILE>;
	fclose(FILE);

	# Make sure the user is allowed to edit this post.
	if( $postid >= 0 && $postid < @messages ) {
		chomp $messages[$postid];
		($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns, $mlm, $mlmb) = split( /\|/, $messages[$postid]);
		unless( $musername eq $username || exists $moderators{$username} || $settings[7] eq 'Administrator' ) {
			&fatal_error($txt{'67'});
		}
	}
	else { &fatal_error("$txt{'580'} $postid"); }

	# Look for the current thread in the current board.
	fopen(FILE, "$boardsdir/$currentboard.txt");
	@threads = <FILE>;
	fclose(FILE);
	($tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate) = split( /\|/, $yyThreadLine );
	$threadnum = $yyThreadPosition;
	if( $tstate == 1 ) {
		&fatal_error($txt{'90'});
	}

	if( $deletepost ) {
		if( $musername ne 'Guest' ) {
			fopen(FILE, "$memberdir/$musername.dat");
			@userprofile = <FILE>;
			fclose(FILE);
			chomp $userprofile[6];
			--$userprofile[6];
			$userprofile[6] .= "\n";
			fopen(FILE, ">$memberdir/$musername.dat", 1);
			print FILE @userprofile;
			fclose(FILE);
		}
		# If the post is to be deleted.
		--$treplies;
		$postkilled = 1;
		if( $treplies < 0 ) {
			# If the post is the only one in the thread,
			# then delete the thread as well.
			$threads[$threadnum] = '';
			$threadkilled = 1;
			unlink("$datadir/$tnum.txt");
			unlink("$datadir/$tnum.mail");
			unlink("$datadir/$tnum.data");
			if( $threadnum == 0 ) {
				($tnum2, $tmpa, $tmpa, $tmpa, $tdate2) = split( /\|/, $threads[1] );
				if( $tnum2 ) {
					$newlastposttime = $tdate2;
					fopen(FILE, "$datadir/$tnum2.data");
					$tmpa = <FILE>;
					fclose(FILE);
					($views,$newlastposter) = split(/\|/, $tmpa);
				}
				else {
					$newlastposttime = 'N/A';
					$newlastposter = 'N/A';
				}
			}
		}
		else {
			# If the post is not the only one in the thread...
			if( $postid == $#messages ) {
				($tmpa,$tmpa,$tmpa,$tdate) = split( /\|/, $messages[$postid-1] );
			}
			elsif( $postid == 0 ) {
				$_ = $messages[1];
				chomp;
				($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns, $mlm, $mlmb) = split( /\|/, $_ );
				$tsub = $msub;
				$ticon = $micon;
			}
			$threads[$threadnum] = qq~$tnum|$tsub|$tname|$temail|$tdate|$treplies|$tusername|$ticon|$tstate\n~;
			if( $postid == $#messages ) {
				# If the post is the last one in the thread, then make sure
				# all the lastposter/lastposttime stuff is correct for the thread.
				$lastpostid = $postid - 1;
				$_ = $messages[$lastpostid];
				chomp;
				($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns, $mlm, $mlmb) = split( /\|/, $_ );
				if( $threadnum == 0 ) {
					$newlastposttime = $mdate;
					$newlastposter = $mname
				}
				fopen(FILE, "$datadir/$tnum.data");
				$tmpa = <FILE>;
				fclose(FILE);
				($views,$tmpa) = split(/\|/, $tmpa);
				fopen(FILE, "+>$datadir/$tnum.data");
				print FILE qq~$views|$mname~;
				fclose(FILE);
			}
			$messages[$postid] = '';
			# Save thread without the deleted post.
			fopen(FILE, ">$datadir/$threadid.txt", 1) || &fatal_error("$txt{'23'} $threadid.txt");
			print FILE @messages;
			fclose(FILE);
		}
	}
	else {
		# If the post is to be modified...
		$name = $FORM{'name'};
		$email = $FORM{'email'};
		$subject = $FORM{'subject'};
		$message = $FORM{'message'};
		$icon = $FORM{'icon'};
		$ns = $FORM{'ns'};
		&CheckIcon;

		&fatal_error($txt{'78'}) unless($message);
		if (length($message)>$MaxMessLen) { &fatal_error($txt{'499'}); }

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
		$subject =~ s/\&/\&amp;/g;
		$subject =~ s/"/\&quot;/g;
		$subject =~ s/  / \&nbsp;/g;
		$subject =~ s/</&lt;/g;
		$subject =~ s/>/&gt;/g;
		$subject =~ s/\|/\&#124;/g;	
		&fatal_error($txt{'77'}) unless($subject && $subject !~ m~\A[\s_.,]+\Z~ );
		$message =~ s/\cM//g;
		$message =~ s~\[([^\]]{0,30})\n([^\]]{0,30})\]~\[$1$2\]~g;
		$message =~ s~\[/([^\]]{0,30})\n([^\]]{0,30})\]~\[/$1$2\]~g;
		$message =~ s~(\w+://[^<>\s\n\"\]\[]+)\n([^<>\s\n\"\]\[]+)~$1\n$2~g;
		#$message =~ s~(\S{80})(?=\S)~$1\n~g;
		$message =~ s/\&/\&amp;/g;
		$message =~ s/"/\&quot;/g;
		$message =~ s/  / \&nbsp;/g;
		$message =~ s/</&lt;/g;
		$message =~ s/>/&gt;/g;
		$message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
		$message =~ s/\n/<br>/g;
		$message =~ s/\|/\&#124;/g;
		if( $postid == 0 ) {
			$tsub = $subject;
			$ticon = $icon;
		}
		$threads[$threadnum] = qq~$tnum|$tsub|$tname|$temail|$tdate|$treplies|$tusername|$ticon|$tstate\n~;
		$messages[$postid] = qq~$subject|$mname|$memail|$mdate|$musername|$icon|0|$ENV{'REMOTE_ADDR'}|$message|$ns|$date|$username\n~;
		fopen(FILE, ">$datadir/$threadid.txt", 1) || &fatal_error("$txt{'23'} $threadid.txt");
		print FILE @messages;
		fclose(FILE);
	}
	# Save the current board.
	fopen(FILE, ">$boardsdir/$currentboard.txt", 1) || &fatal_error("$txt{'23'} $currentboard.txt");
	print FILE @threads;
	fclose(FILE);

	if( $postkilled ) {
		# If post was killed, update the current board.
		my( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
		--$messagecount;
		if( $threadkilled ) {
			--$threadcount;
		}
		&BoardCountSet( $currentboard, $threadcount, $messagecount, $newlastposttime || $lastposttime, $newlastposter || $lastposter );
	}

	&dumplog($currentboard);
	if( $threadkilled ) {
		$yySetLocation = qq~$cgi~;
		&redirectexit;
	}
	else {
		# Let's figure out what page number to show
		my $pageindex = int($postid / $maxmessagedisplay);
		my $start = $pageindex * $maxmessagedisplay;
		$yySetLocation = qq~$cgi&action=display&num=$threadid&start=$start~;
		&redirectexit;
	}
}

1;