#!/usr/bin/perl

###############################################################################
# Printpage.pl                                                                #
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
require "$sourcedir/Subs.pl";
require "$sourcedir/Load.pl";
require "$sourcedir/Security.pl";

### Log this click ###
&ClickLog;

$printpageplver="1 Gold - Release";

### Load the user's cookie (or set to guest) ###
&LoadCookie;

### Load user settings ###
&LoadUserSettings;

#### Choose what to do based on the form action ####
if ($maintenance == 1 && $settings[7] ne 'Administrator') { require "$sourcedir/Maintenance.pl"; &InMaintenance; }

### Load board information ###
&LoadBoard;

### Banning ###
&banning;

### Write log ###
&WriteLog;

# Load Censor List
&LoadCensorList;

### Set some stuff ###
$num = $INFO{'num'};
if( $yyForceIIS ) { print "HTTP/1.0 200 OK\n"; }
print "Content-type: text/html\n\n";

### Determine what category we are in. ###
fopen(FILE, "$boardsdir/$currentboard.ctb") || &fatal_error("300 $txt{'106'}: $txt{'23'} $currentboard.ctb");
$cat = <FILE>;
fclose(FILE);
$curcat = $cat;
fopen(FILE, "$boardsdir/$cat.cat") || &fatal_error("300 $txt{'106'}: $txt{'23'} $cat.cat");
$cat = <FILE>;
fclose(FILE);


($messagenumber, $messagetitle, $poster, $email, $date, $trash, $trash, $trash) = split (/\|/,$yyThreadLine);
$startedby = $poster;
$startedon = $date;

### Lets open up the thread file itself. ###
fopen(THREADS, "$datadir/$num.txt") || &donoopen;
@threads = <THREADS>;
fclose(THREADS);
$cat =~ s/\n//g;

### Lets output all that info. ###
print qq~
<html>
<head>
<title>$txt{'668'}</title>
</head>

<body bgcolor="#FFFFFF" text="#000000">

<pre>
<font size="3" face="arial">
 <b>$mbname</B>
    $cat >> $boardname >> $txt{'195'}: $startedby $txt{'176'} $startedon
</pre>
~;

### Split the threads up so we can print them.
foreach $thread (@threads) { # start foreach
	($threadtitle, $threadposter, $trash, $threaddate, $trash, $trash, $trash, $trash, $threadpost) = split (/\|/,$thread);

	### Do YaBBC Stuff ###
	$threadpost =~ s~<br>~\n~ig;
	$threadpost =~ s~\[code\]\n*(.+?)\n*\[/code\]~<BR><B>Code:</B><br><table bgcolor=#000000 cellspacing=1><tr><td><table cellpadding=2 cellspacing=0 bgcolor=#FFFFFF><tr><td><font face=Courier size=1 color=#000000>$1</font></td></tr></table></td></tr></table>~isg;

	$threadpost =~ s~\[([^\]]{0,30})\n([^\]]{0,30})\]~\[$1$2\]~g;
	$threadpost =~ s~\[/([^\]]{0,30})\n([^\]]{0,30})\]~\[/$1$2\]~g;
	$threadpost =~ s~(\w+://[^<>\s\n\"\]\[]+)\n([^<>\s\n\"\]\[]+)~$1\n$2~g;
	$threadpost =~ s~\[b\](.+?)\[/b\]~<b>$1</b>~isg;
	$threadpost =~ s~\[i\](.+?)\[/i\]~<i>$1</i>~isg;
	$threadpost =~ s~\[u\](.+?)\[/u\]~<u>$1</u>~isg;
	$threadpost =~ s~\[s\](.+?)\[/s\]~<s>$1</s>~isg;
	$threadpost =~ s~\[move\](.+?)\[/move\]~$1~isg;

	$threadpost =~ s~\[glow(.*?)\](.*?)\[/glow\]~&elimnests($2)~eisg;
	$threadpost =~ s~\[shadow(.*?)\](.*?)\[/shadow\]~&elimnests($2)~eisg;

	$threadpost =~ s~\[shadow=(\S+?),(.+?),(.+?)\](.+?)\[/shadow\]~$4~eisg;
	$threadpost =~ s~\[glow=(\S+?),(.+?),(.+?)\](.+?)\[/glow\]~$4~eisg;

	$threadpost =~ s~\[color=([\w#]+)\](.*?)\[/color\]~$2~isg;
	$threadpost =~ s~\[black\](.*?)\[/black\]~$1~isg;
	$threadpost =~ s~\[white\](.*?)\[/white\]~$1~isg;
	$threadpost =~ s~\[red\](.*?)\[/red\]~$1~isg;
	$threadpost =~ s~\[green\](.*?)\[/green\]~$1~isg;
	$threadpost =~ s~\[blue\](.*?)\[/blue\]~$1~isg;

	$threadpost =~ s~\[font=(.+?)\](.+?)\[/font\]~<font face="$1">$2</font>~isg;
	$threadpost =~ s~\[size=(.+?)\](.+?)\[/size\]~<font size="$1">$2</font>~isg;

	$threadpost =~ s~\[img\](.+?)\[/img\]~$1~isg;
	$threadpost =~ s~\[img width=(\d+) height=(\d+)\](.+?)\[/img\]~$3~eisg;

	$threadpost =~ s~\[tt\](.*?)\[/tt\]~<tt>$1</tt>~isg;
	$threadpost =~ s~\[left\](.+?)\[/left\]~<p align=left>$1</p>~isg;
	$threadpost =~ s~\[center\](.+?)\[/center\]~<center>$1</center>~isg;
	$threadpost =~ s~\[right\](.+?)\[/right\]~<p align=right>$1</p>~isg;
	$threadpost =~ s~\[sub\](.+?)\[/sub\]~<sub>$1</sub>~isg;
	$threadpost =~ s~\[sup\](.+?)\[/sup\]~<sup>$1</sup>~isg;
	$threadpost =~ s~\[fixed\](.+?)\[/fixed\]~<font face="Courier New">$1</font>~isg;

	$threadpost =~ s~\[\[~\{\{~g;
	$threadpost =~ s~\]\]~\}\}~g;
	$threadpost =~ s~\|~\&#124;~g;
	$threadpost =~ s~\[hr\]\n~<hr width=40% align=left size=1>~g;
	$threadpost =~ s~\[hr\]~<hr width=40% align=left size=1>~g;
	$threadpost =~ s~\[br\]~\n~ig;

	$threadpost =~ s~\[url\]www\.\s*(.+?)\s*\[/url\]~www.$1~isg;
	$threadpost =~ s~\[url=\s*(\w+\://.+?)\](.+?)\s*\[/url\]~$2 ($1)~isg;
	$threadpost =~ s~\[url=\s*(.+?)\]\s*(.+?)\s*\[/url\]~$2 (http://$1)~isg;
	$threadpost =~ s~\[url\]\s*(.+?)\s*\[/url\]~$1~isg;

	$threadpost =~ s~\[email\]\s*(\S+?\@\S+?)\s*\[/email\]~$1~isg;
	$threadpost =~ s~\[email=\s*(\S+?\@\S+?)\]\s*(.*?)\s*\[/email\]~$2 ($1)~isg;

	$threadpost =~ s~\[news\](.+?)\[/news\]~$1~isg;
	$threadpost =~ s~\[gopher\](.+?)\[/gopher\]~$1~isg;
	$threadpost =~ s~\[ftp\](.+?)\[/ftp\]~$1~isg;

	$threadpost =~ s~\[quote\s+author=(.*?)link=(.*?)\s+date=(.*?)\s*\]\n*(.*?)\n*\[/quote\]~<BR><i>on $3, <a href=$scripturl?action=display&$2>$1 wrote</a>:</i><table bgcolor=#000000 cellspacing=1 width=90%><tr><td width=100%><table cellpadding=2 cellspacing=0 width=100% bgcolor=#FFFFFF><tr><td width=100%><font size=1 color=#000000>$4</font></td></tr></table></td></tr></table>~isg;
	$threadpost =~ s~\[quote\]\n*(.+?)\n*\[/quote\]~<BR><i>Quote:</i><table bgcolor=#000000 cellspacing=1 width=90%><tr><td width=100%><table cellpadding=2 cellspacing=0 width=100% bgcolor=#FFFFFF><tr><td width="100%"><font face="Arial,Helvetica" size="1" color=#000000>$1</font></td></tr></table></td></tr></table>~isg;

	$threadpost =~ s~\[list\]~<ul>~isg;
	$threadpost =~ s~\[\*\]~<li>~isg;
	$threadpost =~ s~\[/list\]~</ul>~isg;

	$threadpost =~ s~\[pre\](.+?)\[/pre\]~'<pre>' . dopre($1) . '</pre>'~iseg;

	$threadpost =~ s~\[flash=(\S+?),(\S+?)\](\S+?)\[/flash\]~$3~isg;

	$threadpost =~ s~\{\{~\[~g;
	$threadpost =~ s~\}\}~\]~g;

	if( $threadpost =~ m~\[table\]~i ) {
		$threadpost =~ s~\n{0,1}\[table\]\n*(.+?)\n*\[/table\]\n{0,1}~<table>$1</table>~isg;
		while( $threadpost =~ s~\<table\>(.*?)\n*\[tr\]\n*(.*?)\n*\[/tr\]\n*(.*?)\</table\>~<table>$1<tr>$2</tr>$3</table>~is ) {}
		while( $threadpost =~ s~\<tr\>(.*?)\n*\[td\]\n{0,1}(.*?)\n{0,1}\[/td\]\n*(.*?)\</tr\>~<tr>$1<td>$2</td>$3</tr>~is ) {}
	}

	$threadpost =~ s~\[\&table(.*?)\]~<table$1>~g;
	$threadpost =~ s~\[/\&table\]~</table>~g;
	$threadpost =~ s~\n~<br>~g;
	
	### Censor it ###
	foreach (@censored) {
		($tmpa,$tmpb) = @{$_};
		$threadtitle =~ s~\Q$tmpa\E~$tmpb~gi;
		$threadpost =~ s~\Q$tmpa\E~$tmpb~gi;
	}
	
print qq~
<hr size=2 width="100%">
<font size=2>$txt{'196'}: <b>$threadtitle</b>
<BR>$txt{'197'}: <b>$threadposter</b> $txt{'176'} <b>$threaddate</b>
<hr>
$threadpost</font><p>
~;

}

print qq~
<BR><BR>
<center><font size="1">$yycopyright</font></center>
</body></html>
~;

sub donoopen {

print qq~
<html><head><title>$txt{'199'}</title></head>
<body bgcolor=#ffffff>
<center>$txt{'199'}</center>
</body></html>

~;
}

exit;