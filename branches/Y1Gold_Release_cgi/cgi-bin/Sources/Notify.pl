###############################################################################
# Notify.pl                                                                   #
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

$notifyplver="1 Gold - Release";

sub Notify {
	if( $currentboard eq '' ) { &fatal_error($txt{'1'}); }
	if($username eq "Guest") { &fatal_error("$txt{'138'}"); }
	$yytitle = "$txt{'125'}";
	&header;

	# Check, if User already gets a notification
	fopen(FILE, "$datadir/$INFO{'thread'}.mail");
	@mails = <FILE>;
	fclose(FILE);

	$isonlist = 0;

	foreach $curmail (@mails) {
		$curmail =~ s/[\n\r]//g;
		if($settings[2] eq "$curmail") { $isonlist = 1; }
	}

	if ($isonlist){

	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'125'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>
    $txt{'212'}<br>
    <b><a href="$cgi&action=notify3&thread=$INFO{'thread'}&start=$INFO{'start'}">$txt{'163'}</a> - <a href="$cgi&action=display&num=$INFO{'thread'}&start=$INFO{'start'}">$txt{'164'}</a></b>
    </font></td>
  </tr>
</table>
EOT

	} else
	{

	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'125'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2>
    $txt{'126'}<br>
    <b><a href="$cgi&action=notify2&thread=$INFO{'thread'}&start=$INFO{'start'}">$txt{'163'}</a> - <a href="$cgi&action=display&num=$INFO{'thread'}&start=$INFO{'start'}">$txt{'164'}</a></b>
    </font></td>
  </tr>
</table>
EOT

	}

	&footer;
	exit;
}

sub Notify2 {
	if( $currentboard eq '' ) { &fatal_error($txt{'1'}); }
	if($username eq 'Guest') { &fatal_error($txt{'138'}); }
	$thread = $INFO{'thread'};
	$start = $INFO{'start'} ne '' ? $INFO{'start'} : 9999999;
	fopen(FILE, "$datadir/$thread.mail");
	@mails = <FILE>;
	fclose(FILE);
	fopen(FILE, ">$datadir/$thread.mail", 1) || &fatal_error("$txt{'23'} $thread.mail");
	print FILE "$settings[2]\n";
	foreach $curmail (@mails) {
		$curmail =~ s/[\n\r]//g;
		if($settings[2] ne $curmail) { print FILE "$curmail\n"; }
	}
	fclose(FILE);
	$yySetLocation = qq~$cgi&action=display&num=$thread&start=$start~;
	&redirectexit;
}

sub Notify3 {
	if( $currentboard eq '' ) { &fatal_error($txt{'1'}); }
	if($username eq "Guest") { &fatal_error("$txt{'138'}"); }
	$thread = $INFO{'thread'};
	$start = $INFO{'start'} ne '' ? $INFO{'start'} : 9999999;
	fopen(FILE, "$datadir/$thread.mail");
	@mails = <FILE>;
	fclose(FILE);
	fopen(FILE, ">$datadir/$thread.mail", 1) || &fatal_error("$txt{'23'} $thread.mail");
	foreach $curmail (@mails) {
		$curmail =~ s/[\n\r]//g;
		if($settings[2] ne "$curmail") { print FILE "$curmail\n"; }
	}
	fclose(FILE);
	$yySetLocation = qq~$cgi&action=display&num=$thread&start=$start~;
	&redirectexit;
}

sub Notify4 {
	if($username eq "Guest") { &fatal_error("$txt{'138'}"); }
	my( $variable, $dummy, $dummy2, $threadno, @mails, $curmail );

	foreach $variable (keys %FORM) {
	 	$dummy = $FORM{$variable};
		($dummy2,$threadno) = split(/-/,$variable);
		if ($dummy2 eq "thread") {

			fopen(FILE, "$datadir/$threadno.mail");
			@mails = <FILE>;
			fclose(FILE);

			fopen(FILE, ">$datadir/$threadno.mail") || &fatal_error("$txt{'23'} $threadno.mail");
			foreach $curmail (@mails) {
				$curmail =~ s/[\n\r]//g;
				if($settings[2] ne $curmail) { print FILE "$curmail\n"; }
			}
			fclose(FILE);

		}

	}
	&ShowNotifications;
}

sub ShowNotifications {
	if($username eq "Guest") { &error("$txt{'138'}"); }

	my(@dirdata,@datdata,$filename,$entry,@entries,$mnum,$dummy,$msub,$mname,$memail,$mdate,$musername,$micon,$mattach,$mip,$mmessage,@messages,@found_number,@found_subject,@found_date,@found_username);

	# Read all .mail-Files and search for username
	opendir (DIRECTORY,"$datadir");
	@dirdata = readdir(DIRECTORY);
	closedir (DIRECTORY);
	@datdata = grep(/mail/,@dirdata);

	# Load Censor List
	&LoadCensorList;
	
	$yytitle = "$txt{'417'}";
	&header;

	foreach $filename (@datdata) {

		fopen(FILE, "$datadir/$filename");
		@entries = <FILE>;
		fclose(FILE);

	        foreach $entry (@entries) {
	        	$entry =~ s/[\n\r]//g;

	        	if ($entry eq $settings[2]) {
				($mnum, $dummy) = split(/\./,$filename);
				fopen(FILE, "$datadir/$mnum.txt");
				@messages = <FILE>;
				fclose(FILE);
				($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip,  $mmessage) = split(/\|/,$messages[0]);
				push(@found_number,$mnum);
				push(@found_subject,$msub);
				push(@found_date,$mdate);
				push(@found_username,$musername);
				push(@found_name,$mname);
			}

		}

	}

	# Display all Entries

	print <<"EOT";
<table border=0 width=100% cellspacing=1 cellpadding=6 bgcolor="$color{'bordercolor'}" class="bordercolor">
 <tr>
  <td bgcolor="$color{'titlebg'}">
   <font size=2 color="$color{'titletext'}"><b>$txt{'418'}</b></font>
  </td>
 </tr><tr>
  <td bgcolor="$color{'windowbg'}">
   <font size=2>
    <br>
EOT


	if (@found_number==0) {
		print "$txt{'414'}<br><br>&nbsp;";
	} else {
		foreach (@censored) {
		($tmpa,$tmpb) = @{$_};
		$found_subject[$counter] =~ s~\Q$tmpa\E~$tmpb~gi;
		}
		print "<form action=\"$cgi&action=notify4\" method=post>";
		print "<table>\n";
		print "<tr><td colspan=2><font size=2>$txt{'415'}:</font><br>&nbsp;</td></tr>";
		$counter=0;
		foreach $entry (@found_number) {
			&FormatUserName($found_username[$counter]);
			print "<tr><td><font size=2>";
			print qq~<input type=checkbox name="thread-$found_number[$counter]" value="1"></font></td>~;
			print qq~<td><font size=2><b><i>$found_subject[$counter]</i></b> $txt{'525'} <a href="$scripturl?board=&action=viewprofile&username=$useraccount{$found_username[$counter]}">$found_name[$counter]</a></font></td></tr>\n~;
			$counter++;
		}
		print "<tr><td colspan=2><br><font size=2>$txt{'416'}</font><br>&nbsp;</td></tr>\n";
		print qq~<tr><td>&nbsp;</td><td><input type=reset value="$txt{'329'}">&nbsp;&nbsp;&nbsp;<input type=submit value="$txt{'417'}"></td></tr>~;
		print "</table></form><br>&nbsp;\n";
	}

	print <<"EOT";
   </font>
  </td>
 </tr>
</table>
EOT
	&footer;
	exit;

}


1;