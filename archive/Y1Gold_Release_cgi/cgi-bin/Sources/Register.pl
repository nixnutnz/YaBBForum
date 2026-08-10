###############################################################################
# Register.pl                                                                 #
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

$registerplver="1 Gold - Release";

sub Register {
	$yytitle = "$txt{'97'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" cellpadding="2">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'97'}</b> $txt{'517'}</font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" width="100%"><font size=2>
    <form action="$cgi&action=register2" method="POST" name="creator">
    <table cellpadding="3" cellspacing="0" border=0 width="100%">
      <tr>
        <td width="40%"><font size=2>* <b>$txt{'98'}:</b></font>
        <BR><font size="1">$txt{'520'}</font></td>
        <td><input type=text name=username size=20 maxlength=18></td>
      </tr><tr>
        <td width="40%"><font size=2>* <b>$txt{'69'}:</b></font>
        <BR><font size="1">$txt{'679'}</font></td>
EOT
if ($allow_hide_email == 1) { print <<"EOT";
        <td><font size=2><input type=text name=email size=30> <input type="checkbox" name="hideemail" value="checked"> $txt{'721'}</font></td>
EOT
} else { print <<"EOT";
        <td><input type=text name=email size=30>
        <BR><font size="1">$txt{'679'}</font></td>
EOT
}
print <<"EOT";
      </tr>
EOT
	unless( $emailpassword ) {
		print <<"EOT";
      <tr>
        <td width="40%"><font size=2>* <b>$txt{'81'}:</b></font></td>
        <td><font size=2><input type=password name=passwrd1 size=30></font></td>
      </tr><tr>
        <td width="40%"><font size=2>* <b>$txt{'82'}:</b></font></td>
        <td><font size=2><input type=password name=passwrd2 size=30></font></td>
      </tr>
EOT
}
print <<"EOT";
    </table>
    </td>
  </tr>
</table>
EOT
if ($RegAgree) {
	fopen(FILE, "$vardir/agreement.txt");
	@agreement = <FILE>;
	fclose(FILE);
	$fullagree = join( "", @agreement );
	$fullagree =~ s/\n/<BR>/g;
	print <<"EOT";
<table border=0 cellspacing=1 cellpadding="5" bgcolor="$color{'bordercolor'}" class="bordercolor" width="100%" align="center">
  <tr>
    <td bgcolor="$color{'windowbg2'}">
    <font size=2><BR>$fullagree<BR><BR></font>
    </td>
  </tr><tr>
    <td bgcolor="$color{'windowbg'}" align="center"><font size=2>
    <B>$txt{'585'}</B> <input type=radio name=regagree value="yes">
    &nbsp;&nbsp;&nbsp; <B>$txt{'586'}</B> <input type=radio name=regagree value="no" checked>
    </font></td>
  </tr>
</table>
EOT
}
	print <<"EOT";
<BR><center><input type=submit value="$txt{'97'}"></center>
</form>
EOT
	&footer;
	exit;
}

sub Register2 {
	if($FORM{'regagree'} eq "no") {
		$yySetLocation = qq~$scripturl~;
		&redirectexit;
	}
	my %member;
	while( ($key,$value) = each(%FORM) ) {
		$value =~ s~\A\s+~~;
		$value =~ s~\s+\Z~~;
		$value =~ s~[\n\r]~~g;
		$member{$key} = $value;
	}
	$member{'username'} =~ s/\s/_/g;
	if (length($member{'username'}) > 25) { $member{'username'} = substr($member{'username'},0,25); }
	&fatal_error("($member{'username'}) $txt{'37'}") if($member{'username'} eq '');
	&fatal_error("($member{'username'}) $txt{'99'}") if($member{'username'} eq '_' || $member{'username'} eq '|');
	&fatal_error("$txt{'244'} $member{'username'}") if($member{'username'} =~ /guest/i);
	&fatal_error("$txt{'240'}") if($member{'username'} !~ /\A[0-9A-Za-z#%+,-\.@^_]+\Z/);
	&fatal_error("($member{'username'}) $txt{'76'}") if($member{'email'} eq "");
	&fatal_error("($member{'username'}) $txt{'100'}") if(-e ("$memberdir/$member{'username'}.dat"));

	if( $emailpassword ) {
		srand();
		$member{'passwrd1'} = int( rand(100) );
		$member{'passwrd1'} =~ tr/0123456789/ymifxupbck/;
		$_ = int( rand(77) );
		$_ =~ tr/0123456789/q8dv7w4jm3/;
		$member{'passwrd1'} .= $_;
		$_ = int( rand(89) );
		$_ =~ tr/0123456789/y6uivpkcxw/;
		$member{'passwrd1'} .= $_;
		$_ = int( rand(188) );
		$_ =~ tr/0123456789/poiuytrewq/;
		$member{'passwrd1'} .= $_;
		$_ = int( rand(65) );
		$_ =~ tr/0123456789/lkjhgfdaut/;
		$member{'passwrd1'} .= $_;
	} else {
		&fatal_error("($member{'username'}) $txt{'213'}") if($member{'passwrd1'} ne $member{'passwrd2'});
		&fatal_error("($member{'username'}) $txt{'91'}") if($member{'passwrd1'} eq '');
		&fatal_error("$txt{'241'}") if($member{'passwrd1'} !~ /\A[\s0-9A-Za-z!@#$%\^&*\(\)_\+|`~\-=\\:;'",\.\/?\[\]\{\}]+\Z/);
	}
	&fatal_error("$txt{'243'}") if($member{'email'} !~ /\A[0-9A-Za-z@\._\-]+\Z/);
	&fatal_error("$txt{'500'}") if(($member{'email'} =~ /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|(\.$)/) || ($member{'email'} !~ /\A.+@\[?(\w|[-.])+\.[a-zA-Z]{2,4}|[0-9]{1,4}\]?\Z/));
	fopen(FILE, "$vardir/ban_email.txt");
	@banned = <FILE>;
	fclose(FILE);
	foreach $curban (@banned) {
		if($member{'email'} eq "$curban") { &fatal_error("$txt{'678'}$txt{'430'}!"); }
	}


	fopen(FILE, "$memberdir/memberlist.txt");
	@memberlist = <FILE>;
	fclose(FILE);
	$testname = lc $member{'username'};
	for ($a = 0; $a < @memberlist; $a++) {
		chomp $memberlist[$a];
		$membername = lc $memberlist[$a];
		if( fopen(FILE2, "$memberdir/$memberlist[$a].dat") ) {

			# Load users and check email
			if( !$yyUDLoaded{$memberlist[$a]} && -e("$memberdir/$memberlist[$a].dat") ) {
				# If user is not in memory, s/he must be loaded.
				&LoadUser($memberlist[$a]);
				if($userprofile{$memberlist[$a]}->[2] eq $member{'email'}) { &fatal_error("$txt{'730'} ($member{'email'}) $txt{'731'}"); }
			}

			$tmpa=<FILE2>;
			$realname=<FILE2>;
			fclose(FILE2);
			chomp $realname;
			$realname = lc $realname;
			if ($realname eq $testname || $membername eq $testname) { &fatal_error("($member{'username'}) $txt{'473'}"); }
		}
		elsif( $testname eq $membername ) { &fatal_error("($member{'username'}) $txt{'473'}"); }
	}
	&ToHTML($member{'email'});

	fopen(FILE, "$vardir/reserve.txt") || &fatal_error("$txt{'23'} reserve.txt");
	@reserve = <FILE>;
	fclose(FILE);
	fopen(FILE, "$vardir/reservecfg.txt") || &fatal_error("$txt{'23'} reservecfg.txt");
	@reservecfg = <FILE>;
	fclose(FILE);
	for( $a = 0; $a < @reservecfg; $a++ ) {
		chomp $reservecfg[$a];
	}
	$matchword = $reservecfg[0] eq 'checked';
	$matchcase = $reservecfg[1] eq 'checked';
	$matchuser = $reservecfg[2] eq 'checked';
	$matchname = $reservecfg[3] eq 'checked';
	$namecheck = $matchcase eq 'checked' ? $member{'username'} : lc $member{'username'};

	foreach $reserved (@reserve) {
		chomp $reserved;
		$reservecheck = $matchcase ? $reserved : lc $reserved;
		if ($matchuser) {
			if ($matchword) {
				if ($namecheck eq $reservecheck) { &fatal_error("$txt{'244'} $reserved"); }
			}
			else {
				if ($namecheck =~ $reservecheck) { &fatal_error("$txt{'244'} $reserved"); }
			}
		}
	}

	&fatal_error("$txt{'100'})") if(-e ("$memberdir/$member{'username'}.dat"));
	fopen(FILE, ">$memberdir/$member{'username'}.dat");
	print FILE "$member{'passwrd1'}\n";
	print FILE "$member{'username'}\n";
	print FILE "$member{'email'}\n";
	print FILE "\n\n\n0\n\n\n\n\n\n$txt{'209'}\nblank.gif\n$date\n\n\n\n\n";
	if ($FORM{'hideemail'} ne "checked") { $FORM{'hideemail'} = ""; }
	print FILE "$FORM{'hideemail'}\n";
	fclose(FILE);
	fopen(FILE, ">$memberdir/memberlist.txt", 1);
	foreach $curmem (@memberlist) {
		print FILE "$curmem\n";
	}
	print FILE "$member{'username'}\n";
	fclose(FILE);

	my $membershiptotal = @memberlist + 1;
	fopen(FILE, "+>$memberdir/members.ttl");
	print FILE qq~$membershiptotal|$member{'username'}~;
	fclose(FILE);

	$yytitle="$txt{'245'}";
	&header;
	&FormatUserName($member{'username'});
	
	if( $emailpassword ) {
		&sendmail($member{'email'},"$txt{'700'} $mbname", "$txt{'248'} $member{'username'}!\n\n$txt{'719'} $member{'username'}, $txt{'492'} $member{'passwrd1'}.\n\n$txt{'701'}\n$scripturl?action=profile&username=$useraccount{$member{'username'}}\n\n$txt{'130'}");
		print <<"EOT";
<BR>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'97'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" align="left" cellpadding=3><font size=2>$txt{'703'}</font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" valign=top><form action="$cgi&action=login2" method="POST">
    <table border=0 cellpadding="0" cellspacing="0">
      <tr>
        <td><font size=2><b>$txt{'35'}:</b></font></td>
        <td><font size=2><input type=text name="username" size=15 value="$member{'username'}"></font></td>
        <td><font size=2><b>$txt{'36'}:</b></font></td>
        <td><font size=2><input type=password name="passwrd" size=10></font> &nbsp;</td>
        <td><font size=2><b>$txt{'497'}:</b></font></td>
        <td><font size=2><input type=text name="cookielength" size=4 value="$Cookie_Length">
        <td><font size=2><b>$txt{'508'}:</B></font></td>
        <td><font size=2><input type=checkbox name="cookieneverexp"></font></td> &nbsp;</font></td>
        <td align=center colspan=2><input type=submit value="$txt{'34'}"></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
EOT
	}
	else {
	if( $emailwelcome ) {
		&sendmail($member{'email'},"$txt{'700'} $mbname", "$txt{'248'} $member{'username'}!\n\n$txt{'719'} $member{'username'}, $txt{'492'} $member{'passwrd1'}.\n\n$txt{'701'}\n$scripturl?action=profile&username=$useraccount{$member{'username'}}\n\n$txt{'130'}");
	}
		print <<"EOT";
<BR><BR><BR>
<center>$txt{'431'}</center>
<BR><BR>
<table border=0 width=300 cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'97'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}" align="center"><font size=2><form action="$cgi&action=login2" method="POST">
    <input type=hidden name="username" value="$member{'username'}">
    <input type=hidden name="passwrd" value="$member{'passwrd1'}">
    <input type=hidden name="cookielength" value="$Cookie_Length">
    <input type=submit value="$txt{'34'}"></td>
    </form></font>
    </td>
  </tr>
</table>
EOT
	}
	&footer;
	exit;
}

1;