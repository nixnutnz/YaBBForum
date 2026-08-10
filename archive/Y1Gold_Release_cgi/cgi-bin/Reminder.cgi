#!/usr/bin/perl

###############################################################################
# Reminder.pl                                                                 #
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

if( $ENV{'SERVER_SOFTWARE'} =~ /IIS/ ) {
	$yyIIS = 1;
	$0 =~ m~(.*)(\\|/)~;
	$yypath = $1;
	$yypath =~ s~\\~/~g;
	chdir($yypath);
	push(@INC,$yypath);
}

require "Settings.pl";
require "$language";
require "$sourcedir/Load.pl";
require "$sourcedir/Subs.pl";
require "$sourcedir/Security.pl";

### Log this click ###
&ClickLog;

$reminderplver="1 Gold - Release";

$username = 'Guest';

### Banning ###
&banning;

### Write log ###
&WriteLog;

###############################################################################

$yytitle="$mbname $txt{'669'}";
&header;
if ($ENV{'QUERY_STRING'} =~ /input_user/i) {
	&input;
	&footer;
	exit;
}

$user = $INFO{'user'};

fopen(FILE, "$memberdir/$user.dat") || &no_user_error;
@member=<FILE>;
fclose(FILE);
$password = $member[0];
$name = $member[1];
$email = $member[2];
$status = $member[7];

chomp($name);
chomp($email);
chomp($password);
chomp($status);

$subject = "$txt{'36'} $mbname : $name";
&sendmail($email, $subject, qq~$txt{'711'} $name,\n\n$mbname ==>\n\n$txt{'35'}: $user\n$txt{'36'}: $password\n$txt{'87'}: $status\n\n$txt{'130'}~);

print << "EOT";
<BR><BR><table border=0 width=400 cellspacing=1 bgcolor="$color{'bgcolor'}" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$mbname $txt{'36'} $txt{'194'}</b></b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}">
    <table border=0 align="center">
      <tr>
        <td align="center"><font size="2"><b>$txt{'192'}: $user</b></font></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
<br><center><a href="javascript:history.back(-2)">$txt{'193'}</a></center><br>
EOT
&footer;
exit;
	
###############################################################################

sub input {
	print << "EOT";
<BR><BR><table border=0 width=400 cellspacing=1 bgcolor="$color{'bgcolor'}" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}">
    <font size=2 class="text1" color="$color{'titletext'}"><b>$mbname $txt{'36'} $txt{'194'}</b></b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}">
    <form action="$reminderurl?user=">
    <table border=0 align="center">
      <tr>
        <td><font size="2">$txt{'35'}: <input type="text" name="user">
        <input type="submit" value="$txt{'339'}"></font></td>
      </tr>
    </table>
    </form>
    </td>
  </tr>
</table>
EOT
}

sub mailprog_error {
	print "<br><center><b>$txt{'394'}<br>$txt{'395'} <a href=\"mailto:$webmaster_email\">Webmaster</a> $txt{'396'}.</b></center>\n";
	print "<br><a href=\"javascript:history.back(-1)\">Back</a><br>\n";
	&footer;
	exit;
}

sub no_user_error {
	print "<br><center><b>$txt{'40'}</b></center>\n";
	print "<br><a href=\"javascript:history.back(-1)\">$txt{'193'}</a><br>\n";
	&footer;
	exit;
}
