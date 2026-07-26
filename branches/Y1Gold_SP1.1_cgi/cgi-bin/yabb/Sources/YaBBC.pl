###############################################################################
# YaBBC.pl                                                                    #
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

$yabbcplver = "1 Gold - SP 1.1";

$yyYaBBCloaded = 1;

sub validwidth {
	return ( $_[0] > 400 ? 400 : $_[0] );
}

sub MakeSmileys {
	$message =~ s/(\W|\A)\;\)/$1\<img border=0 src=$imagesdir\/wink.gif\>/g;
	$message =~ s/(\W|\A)\;\-\)/$1\<img border=0 src=$imagesdir\/wink.gif\>/g;
	$message =~ s/(\W|\A)\;D/$1\<img border=0 src=$imagesdir\/grin.gif\>/g;
	$message =~ s/\Q:'(\E/\<img border=0 src=$imagesdir\/cry.gif\>/g;
	$message =~ s/(\W)\:\-\//$1\<img border=0 src=$imagesdir\/undecided.gif\>/g;
	$message =~ s/\Q:-X\E/\<img border=0 src=$imagesdir\/lipsrsealed.gif\>/g;
	$message =~ s/\Q:-[\E/\<img border=0 src=$imagesdir\/embarassed.gif\>/g;
	$message =~ s/\Q:-*\E/\<img border=0 src=$imagesdir\/kiss.gif\>/g;
	$message =~ s/\Q&gt;:(\E/\<img border=0 src=$imagesdir\/angry.gif\>/g;
	$message =~ s/\Q::)\E/\<img border=0 src=$imagesdir\/rolleyes\.gif\>/g;
	$message =~ s/\Q:P\E/\<img border=0 src=$imagesdir\/tongue\.gif\>/g;
	$message =~ s/\Q:)\E/\<img border=0 src=$imagesdir\/smiley\.gif\>/g;
	$message =~ s/\Q:-)\E/\<img border=0 src=$imagesdir\/smiley\.gif\>/g;
	$message =~ s/\Q:D\E/\<img border=0 border=0 src=$imagesdir\/cheesy.gif\>/g;
	$message =~ s/\Q:-(\E/\<img border=0 src=$imagesdir\/sad.gif\>/g;
	$message =~ s/\Q:(\E/\<img border=0 src=$imagesdir\/sad.gif\>/g;
	$message =~ s/\Q:o\E/\<img border=0 src=$imagesdir\/shocked.gif\>/gi;
	$message =~ s/\Q8)\E/\<img border=0 src=$imagesdir\/cool.gif\>/g;
	$message =~ s/\Q???\E/\<img border=0 src=$imagesdir\/huh.gif\>/g;
	$message =~ s/\Q?!?\E/\<img border=0 src=$imagesdir\/huh.gif\>/g;
}

$MAXIMGWIDTH = 400;
$MAXIMGHEIGHT = 500;
sub restrictimage {
	my($w,$h,$s) = @_;
	$w = $w <= $MAXIMGWIDTH ? $w : $MAXIMGWIDTH;
	$h = $h <= $MAXIMGHEIGHT ? $h : $MAXIMGHEIGHT;
	return qq~<img src="$s" width="$w" height="$h" alt="" border="0">~;
}

sub quotemsg {
	my( $qauthor, $qlink, $qdate, $qmessage ) = @_;
	$qmessage =~ s~\/me\s+(.*?)(\n.*?)~<font color="#FF0000">* $qauthor $1</font>$2~ig;
	$qmessage =~ s~<font color="#FF0000">(.*?)\/me~<font color="#FF0000">$1\&\#47\;me~ig;
	$qmessage =~ s~\/me\s+([\s\S]*)~<font color="#FF0000">* $qauthor $1</font>~ig;
	$qdate = &timeformat($qdate);
	$_ = $txt{'704'};
	$_ =~ s~AUTHOR~$qauthor~g;
	$_ =~ s~QUOTELINK~$scripturl?action=display;$qlink~g;
	$_ =~ s~DATE~$qdate~g;
	$_ =~ s~QUOTE~$qmessage~g;
	return $_;
}

sub simplequotemsg {
	my $qmessage = $_[0];
	$qmessage =~ s~\/me\s+(.*?)(\n.*?)~<font color="#FF0000">* $1</font>~ig;
	$qmessage =~ s~<font color="#FF0000">(.*?)\/me~<font color="#FF0000">$1\&\#47\;me~ig;
	$qmessage =~ s~\/me\s+([\s\S]*)~<font color="#FF0000">* $1</font>~ig;
	$qmessage =~ s~\/me~\&\#47\;me~ig;
	$_ = $txt{'705'};
	$_ =~ s~QUOTE~$qmessage~g;
	return $_;
}

{
	my %killhash = (
	';' => '&#059;',
	'!' => '&#33;',
	'(' => '&#40;',
	')' => '&#41;',
	'-' => '&#45;',
	'.' => '&#46;',
	'/' => '&#47;',
	':' => '&#58;',
	'?' => '&#63;',
	'[' => '&#91;',
	'\\' => '&#92;',
	']' => '&#93;',
	'^' => '&#94;'
	);
	sub codemsg {
		my $code = $_[0];
		if($code !~ /&\S*;/) { $code =~ s/;/&#059;/g; }
		$code =~ s~([\(\)\-\:\\\/\?\!\]\[\.\^])~$killhash{$1}~g;
		$_ = $txt{'706'};
		$_ =~ s~CODE~$code~g;
		return $_;
	}
}

sub DoUBBC {
	$message =~ s~\[code\]~ \[code\]~ig;
	$message =~ s~\[/code\]~ \[/code\]~ig;
	$message =~ s~\[quote\]~ \[quote\]~ig;
	$message =~ s~\[/quote\]~ \[/quote\]~ig;
	$message =~ s~\[glow\]~ \[glow\]~ig;
	$message =~ s~\[/glow\]~ \[/glow\]~ig;
	$message =~ s~<br>~\n~ig;
	$message =~ s~\[code\]\n*(.+?)\n*\[/code\]~&codemsg($1)~eisg;
	if ($message =~ /\#nosmileys/isg || $ns =~ "NS") {$message =~ s/\#nosmileys//isg;} else { &MakeSmileys; }
	$message =~ s~\[([^\]]{0,30})\n([^\]]{0,30})\]~\[$1$2\]~g;
	$message =~ s~\[/([^\]]{0,30})\n([^\]]{0,30})\]~\[/$1$2\]~g;
	$message =~ s~(\w+://[^<>\s\n\"\]\[]+)\n([^<>\s\n\"\]\[]+)~$1\n$2~g;
	$message =~ s~\[b\](.+?)\[/b\]~<b>$1</b>~isg;
	$message =~ s~\[i\](.+?)\[/i\]~<i>$1</i>~isg;
	$message =~ s~\[u\](.+?)\[/u\]~<u>$1</u>~isg;
	$message =~ s~\[s\](.+?)\[/s\]~<s>$1</s>~isg;
	$message =~ s~\[move\](.+?)\[/move\]~<marquee>$1</marquee>~isg;

	$message =~ s~\[glow(.*?)\](.*?)\[/glow\]~qq^[glow$1]^ . &elimnests($2) . q^[/glow]^~eisg;
	$message =~ s~\[shadow(.*?)\](.*?)\[/shadow\]~qq^[shadow$1]^ . &elimnests($2) . q^[/shadow]^~eisg;

	$message =~ s~\[shadow=(\S+?),(.+?),(.+?)\](.+?)\[/shadow\]~q^[&table width=^ . validwidth($3) . qq^ style="filter:shadow\(color=$1, direction=$2\)"\]$4\[/\&table\]^~eisg;
	$message =~ s~\[glow=(\S+?),(.+?),(.+?)\](.+?)\[/glow\]~q^[&table width=^ . validwidth($3) . qq^ style="filter:glow\(color=$1, strength=$2\)"\]$4\[/\&table\]^~eisg;



	$message =~ s~\[color=([\w#]+)\](.*?)\[/color\]~<font color="$1">$2</font>~isg;
	$message =~ s~\[black\](.*?)\[/black\]~<font color=000000>$1</font>~isg;
	$message =~ s~\[white\](.*?)\[/white\]~<font color=FFFFFF>$1</font>~isg;
	$message =~ s~\[red\](.*?)\[/red\]~<font color=FF0000>$1</font>~isg;
	$message =~ s~\[green\](.*?)\[/green\]~<font color=00FF00>$1</font>~isg;
	$message =~ s~\[blue\](.*?)\[/blue\]~<font color=0000FF>$1</font>~isg;

	$message =~ s~\[font=(.+?)\](.+?)\[/font\]~<font face="$1">$2</font>~isg;
	$message =~ s~\[size=(.+?)\](.+?)\[/size\]~<font size="$1">$2</font>~isg;

	$char_160 = chr(160);
	$message =~ s~\[img\][\s*\t*\n*(&nbsp;)*($char_160)*]*(http\:\/\/)*(.+?)[\s*\t*\n*(&nbsp;)*($char_160)*]*\[/img\]~<img src="http\:\/\/$2" alt="" border="0">~isg;
	$message =~ s~\[img width=(\d+) height=(\d+)\][\s*\t*\n*(&nbsp;)*($char_160)*]*(http\:\/\/)*(.+?)[\s*\t*\n*(&nbsp;)*($char_160)*]*\[/img\]~restrictimage($1,$2,'http://'.$4)~eisg;

	$message =~ s~\[tt\](.*?)\[/tt\]~<tt>$1</tt>~isg;
	$message =~ s~\[left\](.+?)\[/left\]~<p align=left>$1</p>~isg;
	$message =~ s~\[center\](.+?)\[/center\]~<center>$1</center>~isg;
	$message =~ s~\[right\](.+?)\[/right\]~<p align=right>$1</p>~isg;
	$message =~ s~\[sub\](.+?)\[/sub\]~<sub>$1</sub>~isg;
	$message =~ s~\[sup\](.+?)\[/sup\]~<sup>$1</sup>~isg;
	$message =~ s~\[fixed\](.+?)\[/fixed\]~<font face="Courier New">$1</font>~isg;

	$message =~ s~\[hr\]\n~<hr width=40% align=left size=1 class="hr">~g;
	$message =~ s~\[hr\]~<hr width=40% align=left size=1 class="hr">~g;
	$message =~ s~\[br\]~\n~ig;

	if( $autolinkurls ) {
		$message =~ s~([^\w\"\=\[\]]|[\n\b]|\A)\\*(\w+://[\w\~\.\;\:\,\$\-\+\!\*\?/\=\&\@\#\%]+\.[\w\~\;\:\$\-\+\!\*\?/\=\&\@\#\%]+[\w\~\;\:\$\-\+\!\*\?/\=\&\@\#\%])~$1<a href="$2" target="_blank">$2</a>~isg;
		$message =~ s~([^\"\=\[\]/\:\.(\://\w+)]|[\n\b]|\A)\\*(www\.[^\.][\w\~\.\;\:\,\$\-\+\!\*\?/\=\&\@\#\%]+\.[\w\~\;\:\$\-\+\!\*\?/\=\&\@\#\%]+[\w\~\;\:\$\-\+\!\*\?/\=\&\@\#\%])~$1<a href="http://$2" target="_blank">$2</a>~isg;
	}
	$message =~ s~\[url\]www\.\s*(.+?)\s*\[/url\]~<a href="http://www.$1" target="_blank">www.$1</a>~isg;
	$message =~ s~\[url=\s*(\w+\://.+?)\](.+?)\s*\[/url\]~<a href="$1" target="_blank">$2</a>~isg;
	$message =~ s~\[url=\s*(.+?)\]\s*(.+?)\s*\[/url\]~<a href="http://$1" target="_blank">$2</a>~isg;
	$message =~ s~\[url\]\s*(.+?)\s*\[/url\]~<a href="$1" target="_blank">$1</a>~isg;

	$message =~ s~\[link\]www\.\s*(.+?)\s*\[/link\]~<a href="http://www.$1">www.$1</a>~isg;
	$message =~ s~\[link=\s*(\w+\://.+?)\](.+?)\s*\[/link\]~<a href="$1">$2</a>~isg;
	$message =~ s~\[link=\s*(.+?)\]\s*(.+?)\s*\[/link\]~<a href="http://$1">$2</a>~isg;
	$message =~ s~\[link\]\s*(.+?)\s*\[/link\]~<a href="$1">$1</a>~isg;

	$message =~ s~\[email\]\s*(\S+?\@\S+?)\s*\[/email\]~<a href="mailto:$1">$1</a>~isg;
	$message =~ s~\[email=\s*(\S+?\@\S+?)\]\s*(.*?)\s*\[/email\]~<a href="mailto:$1">$2</a>~isg;

	$message =~ s~\[news\](.+?)\[/news\]~<a href="$1">$1</a>~isg;
	$message =~ s~\[gopher\](.+?)\[/gopher\]~<a href="$1">$1</a>~isg;
	$message =~ s~\[ftp\](.+?)\[/ftp\]~<a href="$1">$1</a>~isg;

	$message =~ s~\[quote\s+author=(.*?)link=(.*?)\s+date=(.*?)\s*\]\n*(.*?)\n*\[/quote\]~&quotemsg($1,$2,$3,$4)~eisg;
	$message =~ s~\[quote\]\n*(.+?)\n*\[/quote\]~&simplequotemsg($1)~eisg;

	$message =~ s~\/me\s+(.*)~<font color="#FF0000">* $displayname $1</font>~ig;


	$message =~ s~\[list\]~<ul>~isg;
	$message =~ s~\[\*\]~<li>~isg;
	$message =~ s~\[/list\]~</ul>~isg;

	$message =~ s~\[pre\](.+?)\[/pre\]~'<pre>' . dopre($1) . '</pre>'~iseg;

	$message =~ /\[flash\=(\S+?),(\S+?)](\S+?)\[\/flash\]/;
	$width = $1;
	$height = $2;
	if ($width > 500) { $width = 500; }
	if ($height > 500) { $height = 500; }
	$message =~ s~\[flash\=(\S+?),(\S+?)](\S+?)\[\/flash\]~<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" width=$width height=$height><param name=movie value=$3><param name=play value=true><param name=loop value=true><param name=quality value=high><embed src=$3 width=$width height=$height play=true loop=true quality=high></embed></object>~g;

	if( $message =~ m~\[table\]\s*(.+?)\s*\[tr\]~i ) {
		while( $message =~ s~<marquee>(.*?)\[table\](.*?)\[/table\](.*?)</marquee>~<marquee>$1<table>$2</table>$3</marquee>~s ) {}
		while( $message =~ s~<marquee>(.*?)\[table\](.*?)</marquee>(.*?)\[/table\]~<marquee>$1\[//table\]$2</marquee>$3\[//table\]~s ) {}
		while( $message =~ s~\[table\](.*?)<marquee>(.*?)\[/table\](.*?)</marquee>~\[//table\]$1<marquee>$2\[//table\]$3</marquee>~s ) {}
		$message =~ s~\n{0,1}\[table\]\n*(.+?)\n*\[/table\]\n{0,1}~<table>$1</table>~isg;
		while( $message =~ s~\<table\>(.*?)\n*\[tr\]\n*(.*?)\n*\[/tr\]\n*(.*?)\</table\>~<table>$1<tr>$2</tr>$3</table>~is ) {}
		while( $message =~ s~\<tr\>(.*?)\n*\[td\]\n{0,1}(.*?)\n{0,1}\[/td\]\n*(.*?)\</tr\>~<tr>$1<td>$2</td>$3</tr>~is ) {}
	}

	while( $message =~ s~<a([^>]*?)\n([^>]*)>~<a$1$2>~ ) {}
	while( $message =~ s~<a([^>]*)>([^<]*?)\n([^<]*)</a>~<a$1>$2$3</a>~ ) {}
	while( $message =~ s~<a([^>]*?)&amp;([^>]*)>~<a$1&$2>~ ) {}
	while( $message =~ s~<img([^>]*?)\n([^>]*)>~<img$1$2>~ ) {}
	while( $message =~ s~<img([^>]*?)&amp;([^>]*)>~<img$1&$2>~ ) {}

	$message =~ s~\[\&table(.*?)\]~<table$1>~g;
	$message =~ s~\[/\&table\]~</table>~g;
	$message =~ s~\n~<br>~ig;
}

1;
