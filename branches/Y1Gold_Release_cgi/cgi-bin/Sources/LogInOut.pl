###############################################################################
# LogInOut.pl                                                                 #
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

$loginoutplver="1 Gold - Release";

sub Login {
	$yytitle = "$txt{'34'}";
	&header;
	print <<"EOT";
<BR><BR>
<form action="$cgi\&action=login2" method="POST">
<table border="0" width="400" cellspacing="1" cellpadding="0" bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" width="100%">
    <table width="100%" cellspacing="0" cellpadding="3">
      <tr>
        <td class="titlebg" bgcolor="$color{'titlebg'}" colspan="2">
        <img src="$imagesdir/login_sm.gif">
        <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'34'}</b></font></td>
      </tr><tr>
        <td align="right" class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><b>$txt{'35'}:</b></font></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><input type=text name="username" size=20></font></td>
      </tr><tr>
        <td align="right" class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><b>$txt{'36'}:</b></font></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><input type=password name="passwrd" size=20></font></td>
      </tr><tr>
        <td align="right" class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><b>$txt{'497'}:</b></font></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><input type=text name="cookielength" size=4 maxlength="4" value="$Cookie_Length"></font></td>
      </tr><tr>
        <td align="right" class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><b>$txt{'508'}:</b></font></td>
        <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><input type=checkbox name="cookieneverexp"></font></td>
      </tr><tr>
        <td align=center colspan=2 class="windowbg" bgcolor="$color{'windowbg'}"><BR><input type=submit value="$txt{'34'}"></td>
      </tr><tr>
        <td align=center colspan=2 class="windowbg" bgcolor="$color{'windowbg'}"><small><small><a href="$reminderurl?action=input_user">$txt{'315'}</small></small></a><BR><BR></td>
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

sub Login2 {
	&fatal_error("$txt{'37'}") if($FORM{'username'} eq "");
	&fatal_error("$txt{'38'}") if($FORM{'passwrd'} eq "");
	$FORM{'username'} =~ s/\s/_/g;
	$username = $FORM{'username'};
	&fatal_error("$txt{'240'}") if($username !~ /^[\s0-9A-Za-z#%+,-\.:=?@^_]+$/);
	&fatal_error("$txt{'337'}") if($FORM{'cookielength'} !~ /^[0-9]+$/);

	if(-e("$memberdir/$username.dat")) {
		fopen(FILE, "$memberdir/$username.dat");
		@settings = <FILE>;
		fclose(FILE);
		$settings[0] =~ s/[\n\r]//g;
		if($settings[0] ne "$FORM{'passwrd'}") { $username = "Guest"; &fatal_error("$txt{'39'}"); }
		$settings[0] = "$settings[0]\n";
	}
	else { $username = "Guest"; &fatal_error("$txt{'40'}"); }

	if($FORM{'cookielength'} < 1 || $FORM{'cookielength'} > 9999) { $FORM{'cookielength'} = $Cookie_Length; }
	if($FORM{'cookieneverexp'} ne 'on') {
		$Cookie_Length = $FORM{'cookielength'};
		&SetCookieExp;
	}
	else { $Cookie_Exp_Date = 'Sun, 17-Jan-2038 00:00:00 GMT'; }
	$password = crypt("$FORM{'passwrd'}",$pwseed);

	$yySetCookies = qq~Set-Cookie: $cookieusername=$username; path=/; expires=$Cookie_Exp_Date;\n~;
	$yySetCookies .= qq~Set-Cookie: $cookiepassword=$password; path=/; expires=$Cookie_Exp_Date;\n~;
	&LoadUserSettings;
	&WriteLog;
	&redirectinternal;
}

sub Logout {
	# Write log
	fopen(LOG, "$vardir/log.txt");
	@entries = <LOG>;
	fclose(LOG);
	fopen(LOG, ">$vardir/log.txt", 1);
	$field="$username";
	foreach $curentry (@entries) {
	        $curentry =~ s/\n//g;
     		($name, $value) = split(/\|/, $curentry);
	        if($name ne "$field") {
	                print LOG "$curentry\n";
	        }
	}
	fclose(LOG);

	$yySetCookies = qq~Set-Cookie: $cookieusername=; expires=Thu, 01-Jan-1970 00:00:00 GMT;\n~;
	$yySetCookies .= qq~Set-Cookie: $cookiepassword=; expires=Thu, 01-Jan-1970 00:00:00 GMT;\n~;
	$yySetCookies .= qq~Set-Cookie: $cookieusername=; path=/; expires=Thu, 01-Jan-1970 00:00:00 GMT;\n~;
	$yySetCookies .= qq~Set-Cookie: $cookiepassword=; path=/; expires=Thu, 01-Jan-1970 00:00:00 GMT;\n~;
	$username = 'Guest';
	$password = '';
	@settings = ();
	$realname = '';
	$realemail = '';
	$ENV{'HTTP_COOKIE'} = '';
	&redirectinternal;
}

1;