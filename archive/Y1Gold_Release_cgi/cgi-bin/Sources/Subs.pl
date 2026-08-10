###############################################################################
# Subs.pl                                                                     #
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

$subsplver="1 Gold - Release";

use subs 'exit';
sub exit {
	local $| = 1;
	local $\ = '';
	print '';
	CORE::exit( $_[0] || 0 );
}

&readform;
### Set the Cookie Exp. Date and the Current Date###
$Cookie_Exp_Date = "Sun, 17-Jan-2038 00:00:00 GMT"; # default just in case
&SetCookieExp;
&get_date;

$currentboard = $INFO{'board'};
if ($currentboard =~ m~/~){ &fatal_error($txt{'399'}); }
if ($currentboard =~ m~\\~){ &fatal_error($txt{'400'}); }
if ($currentboard ne '' && currentboard !~ /\A[\s0-9A-Za-z#%+,-\.:=?@^_]+\Z/){ &fatal_error($txt{'399'}); }
$pwseed ||= 'ya';

$printurl = qq~$boardurl/Printpage.cgi~;
$reminderurl = qq~$boardurl/Reminder.cgi~;
$scripturl = qq~$boardurl/YaBB.cgi~;
$cgi = qq~$scripturl?board=$currentboard~;

sub redirectexit {
	my $headers;
	if( $yyForceIIS ) { $headers = "HTTP/1.0 200 OK\n"; }
	$headers .= "Content-type: text/html\n";
	if( $yySetCookies ) { $headers .= $yySetCookies; }
	if( $yySetLocation ) { $yySetLocation =~ s/ /%20/g; $headers .= "Location: $yySetLocation\n"; }
	$headers .= "\n";
	if($yyblankpageIIS) { print "HTTP/1.0 302 Found\n"; }
	print $headers;
	exit;
}

sub redirectinternal {
	if( $currentboard ) {
		if( $INFO{'num'} ) {
			require "$sourcedir/Display.pl";
			&Display;
		}
		else {
			require "$sourcedir/MessageIndex.pl";
			&MessageIndex;
		}
	}
	else {
		require "$sourcedir/BoardIndex.pl";
		&BoardIndex;
	}
	exit;
}

sub header {
	my $headers;
	if( $yyForceIIS ) { $headers = "HTTP/1.0 200 OK\n"; }
	$headers .= "Content-type: text/html\n";
	if( $yySetCookies ) { $headers .= $yySetCookies; }
	$headers .= "\n";
	print $headers;
	$yymenu = qq~<a href="$scripturl">$img{'home'}</a>$menusep<a href="$helpfile" target=_blank>$img{'help'}</a>$menusep<a href="$cgi&action=search">$img{'search'}</a>~;
	if($settings[7] eq 'Administrator') { $yymenu .= qq~$menusep<a href="$cgi&action=admin">$img{'admin'}</a>~; }
	if($username eq 'Guest') { $yymenu .= qq~$menusep<a href="$cgi&action=login">$img{'login'}</a>$menusep<a href="$cgi&action=register">$img{'register'}</a>~;
	} else {
		$yymenu .= qq~$menusep<a href="$cgi&action=profile&username=$useraccount{$username}">$img{'profile'}</a>~;
		if($enable_notification) { $yymenu .= qq~$menusep<a href="$cgi&action=shownotify">$img{'notification'}</a>~; }
		$yymenu .= qq~$menusep<a href="$cgi&action=logout">$img{'logout'}</a>~;
	}

	if($enable_news) {
		fopen(FILE, "$vardir/news.txt");
		@newsmessages = <FILE>;
		fclose(FILE);
		srand;
		$yynews = qq~<b>$txt{'102'}:</b> $newsmessages[int rand(@newsmessages)]~;
	}
	if($username ne "Guest") {
		fopen(IM, "$memberdir/$username.msg");
		@immessages = <IM>;
		fclose(IM);
		$mnum = @immessages;
		if($mnum eq "1") { $yyim = qq~$txt{'152'} <a href="$cgi\&action=im">$mnum $txt{'471'}</a>.~; }
		else { $yyim = qq~$txt{'152'} <a href="$cgi&action=im">$mnum $txt{'153'}</a>.~; }
		if($maintenance) { $yyim .= qq~<BR><B>$txt{'616'}</B>~; }
	}
	fopen(TEMPLATE,"template.html") || die("$txt{'23'}: template.html");
	@yytemplate = <TEMPLATE>;
	fclose(TEMPLATE);

	$yyboardname = $mbname;
	$yytime = &timeformat($date);
	$yyuname = $username eq 'Guest' ? qq~$txt{'248'} <b>$txt{'28'}</b>. $txt{'249'} <a href="$cgi&action=login">$txt{'34'}</a> $txt{'377'} <a href="$cgi&action=register">$txt{'97'}</a>.~ : qq~$txt{'247'} <b>$realname</b>, ~ ;
	for( $yytemplatemain = 0; $yytemplatemain < @yytemplate; $yytemplatemain++ ) {
		$curline = $yytemplate[$yytemplatemain];
		if($curline =~ /<yabb main>/) { $yytemplatemain++; last; }
		if( ! $yycopyin && $curline =~ /<yabb copyright>/ ) { $yycopyin = 1; }
		$curline =~ s~<yabb\s+(\w+)>~${"yy$1"}~g;
		print $curline;
	}
}

sub footer {
	my( $curline, $i );
	$yytime = &timeformat($date);
	for($i = $yytemplatemain; $i < @yytemplate; $i++) {
		$curline = $yytemplate[$i];
		if( ! $yycopyin && $curline =~ /<yabb copyright>/ ) { $yycopyin = 1; }
		$curline =~ s~<yabb\s+(\w+)>~${"yy$1"}~g;
		print $curline;
	}
	# Do not remove hard-coded text - it's in here so users cannot change the text easily (as if it were in .lng)
	if($yycopyin == 0) {
		print q~<center><font size=5><B>Sorry, the copyright tag <yabb copyright> must be in the template.<BR>Please notify this forum's administrator that this site is using an ILLEGAL copy of YaBB!</B></font></center>~;
	}
}

sub calcdifference {  # Input: $date1 $date2
	my( $dates, $times, $month, $day, $year, $number1, $dummy, $number2 );
	($dates, $times) = split(/ /, $date1);
	($month, $day, $year) = split(/\//, $dates);
	$number1=($year*365)+($month*30)+$day;
	($dates, $dummy) = split(/ /, $date2);
	($month, $day, $year) = split(/\//, $dates);
	$number2=($year*365)+($month*30)+$day;
	$result=$number2-$number1;
}

sub calctime {  # Input: $date1 $date2
	my( $dummy, $times, $hour, $min, $sec, $number1, $number2 );
	($dummy, $times) = split(/ $txt{'107'} /, $date1);
	($hour, $min, $sec) = split(/\:/, $times);
	$number1=($hour*60)+$min;
	($dummy, $times) = split(/ $txt{'107'} /, $date2);
	($hour, $min, $sec) = split(/\:/, $times);
	$number2=($hour*60)+$min;
	$result=$number2-$number1;
}


sub fatal_error {
	local($e) = @_;
	$yytitle = "$txt{'106'}";
	&header;
	print <<"EOT";
<table border=0 width="80%" cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" align="center" cellpadding="4">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'106'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><BR><font size=2>$e</font><BR><BR></td>
  </tr>
</table>
<center><BR><a href="javascript:history.go(-1)">$txt{'250'}</a></center>
EOT
	&footer;
	exit;

}

sub readform {
	my( @pairs, $pair, $name, $value );
	read(STDIN, $value, $ENV{'CONTENT_LENGTH'});
	@pairs = split(/&/, $value);
	foreach $pair (@pairs) {
		  ($name, $value) = split(/=/, $pair);
		  $name =~ tr/+/ /;
		  $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		  $value =~ tr/+/ /;
		  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		  $FORM{$name} = $value;
	}

	@pairs = split(/&/, $ENV{QUERY_STRING});
	foreach $pair (@pairs) {
		  ($name,$value) = split(/=/, $pair);
		  $name =~ tr/+/ /;
		  $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		  $value =~ tr/+/ /;
		  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		  $value =~ s/<!--(.|\n)*-->//g;
		  $INFO{$name} = $value;
	}
	$action = $INFO{'action'};
}

sub get_date {
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time + (3600*$timeoffset));
	$mon_num = $mon+1;
	$savehour = $hour;
	$hour = "0$hour" if ($hour < 10);
	$min = "0$min" if ($min < 10);
	$sec = "0$sec" if ($sec < 10);
	$saveyear = ($year % 100);
	$year = 1900 + $year;

	$mon_num = "0$mon_num" if ($mon_num < 10);
	$mday = "0$mday" if ($mday < 10);
	$saveyear = "0$saveyear" if ($saveyear < 10);
	$date = "$mon_num/$mday/$saveyear $txt{'107'} $hour\:$min\:$sec";
}

sub timeformat {

if ($settings[17] > 0) { $mytimeselected = $settings[17]; } else { $mytimeselected = $timeselected; }

$oldformat = $_[0];
if( $oldformat eq '' || $oldformat eq "\n" ) { return $oldformat; }

$oldmonth = substr($oldformat,0,2);
$oldday = substr($oldformat,3,2);
$oldyear = ("20".substr($oldformat,6,2)) - 1900;
$oldhour = substr($oldformat,-8,2);
$oldminute = substr($oldformat,-5,2);
$oldsecond = substr($oldformat,-2,2);

if ($oldformat ne '') {
	use Time::Local 'timelocal';

eval { $oldtime = timelocal($oldsecond,$oldminute,$oldhour,$oldday,$oldmonth-1,$oldyear); };
	if ($@) {
		return ($oldformat);
	}

	my ($newsecond,$newminute,$newhour,$newday,$newmonth,$newyear,$newweekday,$newyearday,$newisdst) = localtime($oldtime + (3600 * $settings[18]));

	$newmonth++;
	$newweekday++;
	$newyear += 1900;
	$newshortyear = substr($newyear,2,2);
	if ($newmonth < 10) { $newmonth = "0$newmonth" };
	if ($newday < 10 && $mytimeselected != 4) { $newday = "0$newday" };
	if ($newhour < 10) { $newhour = "0$newhour" };
	if ($newminute < 10) { $newminute = "0$newminute" };
	if ($newsecond < 10) { $newsecond = "0$newsecond" };
	$newtime = $newhour.":".$newminute.":".$newsecond;
	
	if ($mytimeselected == 1) {
		$newformat = qq~$newmonth/$newday/$newshortyear $txt{'107'} $newtime~;
		return $newformat;

	} elsif ($mytimeselected == 2) {
		$newformat = qq~$newday.$newmonth.$newshortyear $txt{'107'} $newtime~;
		return $newformat;

	} elsif ($mytimeselected == 3) {
		$newformat = qq~$newday.$newmonth.$newyear $txt{'107'} $newtime~;
		return $newformat;

	} elsif ($mytimeselected == 4) {
		$newmonth--;
		$ampm = $newhour > 11 ? 'pm' : 'am';
		$newhour2 = $newhour % 12 || 12;
		$newmonth2 = $months[$newmonth];
		if( $newday > 10 && $newday < 20 ) { $newday2 = 'th'; }
		elsif( $newday % 10 == 1 ) { $newday2 = 'st'; }
		elsif( $newday % 10 == 2 ) { $newday2 = 'nd'; }
		elsif( $newday % 10 == 3 ) { $newday2 = 'rd'; }
		else{ $newday2 = 'th'; }
		$newformat = qq~$newmonth2 $newday$newday2, $newyear, $newhour2:$newminute$ampm~;
		return $newformat;

	} elsif ($mytimeselected == 5) {
		$ampm = $newhour > 11 ? 'pm' : 'am';
		$newhour2 = $newhour % 12 || 12;
		$newformat = qq~$newmonth/$newday/$newshortyear $txt{'107'} $newhour2:$newminute$ampm~;
		return $newformat;

	} elsif ($mytimeselected == 6) {
		$newmonth2 = $months[$newmonth-1];
		$newformat = qq~$newday. $newmonth2 $newyear $txt{'107'} $newhour:$newminute~;
		return $newformat;
	}

} else { return ''; }
}

sub lock {
	return;
}

sub unlock {
	return;
}

sub check_flock {
	my ($file) = shift;

	if (-e $file) {
		sleep 2;
		return 1;
	}
	else { return 0; }
}

sub getlog {
	if( $username eq 'Guest' || $max_log_days_old == 0 ) { return; }
	my $entry = $_[0];
	unless( defined %yyuserlog ) {
		%yyuserlog = ();
		my( $name, $value, $thistime, $adate, $atime, $amonth, $aday, $ayear, $ahour, $amin, $asec );
		my $mintime = time - ( $max_log_days_old * 86400 );
		fopen(MLOG, "$memberdir/$username.log");
		while( <MLOG> ) {
			chomp;
			($name, $value, $thistime) = split( /\|/, $_ );
			unless( $name ) { next; }
			if( $value ) {
				$thistime = stringtotime($value);
			}
			if( $thistime > $mintime ) {
				$yyuserlog{$name} = $thistime;
			}
		}
		fclose(MLOG);
	}
	return $yyuserlog{$entry};
}

sub modlog {
	if( $username eq 'Guest' || $max_log_days_old == 0 ) { return; }
	unless( defined %yyuserlog ) { &getlog; }
	my( $entry, $dumbtime, $thistime ) = @_;
	if( $dumbtime ) {
		$thistime = stringtotime($dumbtime);
	}
	unless( $thistime ) {
		$thistime = time;
	}
	$yyuserlog{$entry} = $thistime;
}

sub dumplog {
	if( $username eq 'Guest' || $max_log_days_old == 0 ) { return; }
	if( @_ ) { &modlog(@_); }
	if( defined %yyuserlog ) {
		fopen(MLOG, ">$memberdir/$username.log");
		while( $_ = each(%yyuserlog) ) {
			unless( $_ ) { next; }
			print MLOG qq~$_||$yyuserlog{$_}\n~;
		}
		fclose(MLOG);
	}
}

sub stringtotime {
	unless( $_[0] ) { return 0; }
	my( $adate, $atime ) = split(m~ $txt{'107'} ~, $_[0]);
	my( $amonth, $aday, $ayear ) = split(m~/~, $adate);
	my( $ahour, $amin, $asec ) = split (m~:~, $atime);
	$asec = int($asec) || 0;
	$amin = int($amin) || 0;
	$ahour = int($ahour) || 0;
	$ayear = int($ayear) || 0;
	$amonth = int($amonth) || 0;
	$aday = int($aday) || 0;
	$ayear += 100;
	if( $amonth < 1 ) { $amonth = 0; }
	elsif( $amonth > 12 ) { $amonth = 11; }
	else { --$amonth; }
	if( $aday < 1 ) { $aday = 1; }
	elsif( $aday > 31 ) { $aday = 31; }
	return( timelocal($asec, $amin, $ahour, $aday, $amonth, $ayear) - (3600*$timeoffset) );
}

sub jumpto {
	fopen(FILE, "$vardir/cat.txt");
	@masterdata = <FILE>;
	fclose(FILE);

	$selecthtml .= "<option value=\"\">$txt{'251'}:\n";

	foreach $category (@masterdata) {
		$category =~ s/\n//g;
		fopen(FILE, "$boardsdir/$category.cat");
		@data = <FILE>;
		fclose(FILE);
		@data[1] =~ s/\n//g;
		if(@data[1] ne "") {
			if($settings[7] ne "Administrator" && $settings[7] ne "@data[1]") { next; }
		}

		$selecthtml .= "<option value=\"\">-----------------------------\n";
		$selecthtml .= "<option value=\"\">@data[0]\n";
		$selecthtml .= "<option value=\"\">-----------------------------\n";

		foreach $line (@data) {
			if($line ne "@data[0]" && $line ne "@data[1]") {
				$line =~ s/\n//g;
				fopen(FILE, "$boardsdir/$line.dat");
				@newcatdata = <FILE>;
				fclose(FILE);

				if ($action eq "display" && $line eq $currentboard) { $selecthtml .= "<option selected value=\"$line\">- @newcatdata[0]\n"; }
				else { $selecthtml .= "<option value=\"$line\">&nbsp; => @newcatdata[0]\n"; }
			}
		}
	}

}

sub sendmail {

	my ($to, $subject, $message, $from) = @_;

	if ($mailtype==1) { use Socket; }

	if($from) { $webmaster_email = $from; }
	$to =~ s/[ \t]+/, /g;
	$webmaster_email =~ s/.*<([^\s]*?)>/$1/;
	$message =~ s/^\./\.\./gm;
	$message =~ s/\r\n/\n/g;
	$message =~ s/\n/\r\n/g;
	$smtp_server =~ s/^\s+//g;
	$smtp_server =~ s/\s+$//g;

	if (!$to) { return(-8); }

 	if ($mailtype==1) {

		my($proto) = (getprotobyname('tcp'))[2];
		my($port) = (getservbyname('smtp', 'tcp'))[2];
		my($smtpaddr) = ($smtp_server =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/) ? pack('C4',$1,$2,$3,$4) : (gethostbyname($smtp_server))[4];

		if (!defined($smtpaddr)) { return(-1); }
		if (!socket(MAIL, AF_INET, SOCK_STREAM, $proto)) { return(-2); }
		if (!connect(MAIL, pack('Sna4x8', AF_INET, $port, $smtpaddr))) { return(-3); }

		my($oldfh) = select(MAIL);
		$| = 1;
		select($oldfh);

		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-4);
		}

		print MAIL "helo $smtp_server\r\n";
		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-5);
		}

		print MAIL "mail from: <$webmaster_email>\r\n";
		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-5);
		}

		foreach (split(/, /, $to)) {
			print MAIL "rcpt to: <$_>\r\n";
			$_ = <MAIL>;
			if (/^[45]/) {
				close(MAIL);
				return(-6);
			}
		}

		print MAIL "data\r\n";
		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-5);
		}

	}

	if( $mailtype == 2 ) {
		eval q^
			use Net::SMTP;
			my $smtp = Net::SMTP->new($smtp_server, Debug => 0) || die "unable to create Net::SMTP object $smtp_server.";
			$smtp->mail($webmaster_email);
			$smtp->to($to);
			$smtp->data();
			$smtp->datasend("From: $webmaster_email\n");
			$smtp->datasend("X-Mailer: Perl Powered Socket Net::SMTP Mailer\n");
			$smtp->datasend("Subject: $subject\n");
			$smtp->datasend("\n");
			$smtp->datasend($message);
			$smtp->dataend();
			$smtp->quit();
		^;
		if( $@ ) {
			&fatal_error("\n<br>Net::SMTP fatal error: $@\n<br>");
			return -77;
		}
		return 1;
	}

	if ($mailtype==0) {
		open(MAIL,"| $mailprog -t");
	}

	print MAIL "To: $to\n";
	print MAIL "from: $webmaster_email\n";
	print MAIL "X-Mailer: Perl Powered Socket Mailer\n";
	print MAIL "Subject: $subject\n\n";
	print MAIL "$message";
	print MAIL "\n.\n";

	if ($mailtype==1) {

		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-7);
		}

		print MAIL "quit\r\n";
		$_ = <MAIL>;
	}

	close(MAIL);
	return(1);
}

sub spam_protection {
	unless( $timeout ) { return; }

	my($ip,$time,$flood_ip,$flood_time,$flood,@floodcontrol);
	$time = time;
	$ip = $ENV{REMOTE_ADDR};

	if (-e "$vardir/flood.txt") {
		fopen(FILE, "$vardir/flood.txt");
		push(@floodcontrol,"$ip|$time\n");
		while( <FILE> ) {
			chomp($_);
			($flood_ip,$flood_time) = split(/\|/,$_);
			if( $ip eq $flood_ip && $time - $flood_time <= $timeout ) { $flood = 1; }
			elsif( $time - $flood_time < $timeout ) { push( @floodcontrol, "$_\n" ); }
		}
		fclose(FILE);
	}
	if ($flood) { &fatal_error("$txt{'409'} $timeout $txt{'410'}"); }
	fopen(FILE, ">$vardir/flood.txt", 1);
	print FILE @floodcontrol;
	fclose(FILE);
}

sub checkdomain {

	@alloweddomains[0] = $domain1;
	@alloweddomains[1] = $domain2;
	@alloweddomains[2] = $domain3;

	local($check_referer) = 0;

	if ($ENV{'HTTP_REFERER'}) {
	        foreach $referer (@alloweddomains) {
			if ($referer ne "") {
	                        if ($ENV{'HTTP_REFERER'} =~ m/htt[ps|s]:\/\/([^\/]*)$referer/i) {
	                                $check_referer = 1;
	                                last;
	                        }
			}
	        }
	}
	else { $check_referer = 1; }
	if ($check_referer != 1) { &fatal_error("$txt{'411'}$ENV{'HTTP_REFERER'}$txt{'412'}"); }
}

sub BoardCatsMake {
	my( @categories, @catboards, @curcataccess, $curcat, $curcatname, $curcataccess, $curboard );
	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);
	foreach $curcat (@categories) {
		chomp $curcat;
		fopen(CATFILE, "$boardsdir/$curcat.cat");
		$curcatname = <CATFILE>;
		$curcataccess = <CATFILE>;
		@catboards = <CATFILE>;
		fclose(CATFILE);
		chomp $curcatname;
		chomp $curcataccess;
		$yyAccessCat{$curcat} = $settings[7] eq 'Administrator' || $moderators{$username} || ! $curcataccess;
		unless( $yyAccessCat{$curcat} ) {
			foreach ( split(/\,/, $curcataccess) ) {
				if( $_ && $_ eq $settings[7] ) { $yyAccessCat{$curcat} = 1; last; }
			}
		}
		foreach $curboard (@catboards) {
			chomp $curboard;
			fopen(CATBOARDMAKE, ">$boardsdir/$curboard.ctb");
			print CATBOARDMAKE $curcat;
			fclose(CATBOARDMAKE);
			$yyCatBoard{$curboard} = $curcat; 
		}
	}
}

sub BoardCatGet {
	my $curboard = $_[0];
	if( $yyCatBoard{$curboard} ) {}
	elsif( fopen(CATFILE, "$boardsdir/$curboard.ctb") ) {
		$_ = <CATFILE>;
		fclose(CATFILE);
		chomp;
		$yyCatBoard{$curboard} = $_;
	}
	unless( $yyCatBoard{$curboard} ) {
		&BoardCatsMake;
	}
	return $yyCatBoard{$curboard};
}

sub BoardAccessGet {
	my $curboard = $_[0];
	&BoardCatGet($curboard);
	if( $yyAccessCat{$yyCatBoard{$curboard}} ) {}
	elsif( fopen(CATFILE, "$boardsdir/$yyCatBoard{$curboard}.cat") ) {
		my $curcatname = <CATFILE>;
		my $curcataccess = <CATFILE>;
		fclose(CATFILE);
		chomp $curcatname;
		chomp $curcataccess;
		$yyAccessCat{$yyCatBoard{$curboard}} = $settings[7] eq 'Administrator' || $moderators{$username} || ! $curcataccess;
		unless( $yyAccessCat{$curcat} ) {
			foreach ( split(/\,/, $curcataccess) ) {
				if( $_ && $_ eq $settings[7] ) { $yyAccessCat{$yyCatBoard{$curboard}} = 1; last; }
			}
		}
	}
	return $yyAccessCat{$yyCatBoard{$curboard}};
}

sub SetCookieExp {
	# set to default if missing
	if ($Cookie_Length eq "") { $Cookie_Length = "120"; }
	$expires = ($Cookie_Length*60);

	use Time::Local 'timegm';
	($csec,$cmin,$chour,$cday,$cmon,$cyear,$cwday,$dummy,$dummy) = gmtime(time);
	$time = timegm($csec,$cmin,$chour,$cday,$cmon,$cyear);
	($csec,$cmin,$chour,$cday,$cmon,$cyear,$cwday,$dummy,$dummy) = gmtime($time + $expires); #date expires

	@cookiedays = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
	@cookiemonths = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

	$cyear = (1900 + $cyear);
	if($cmin < 10) { $cmin = "0$cmin"; }
	if($csec < 10) { $csec = "0$csec"; }
	if($chour < 10) { $chour = "0$chour"; }

	$Cookie_Exp_Date = "$cookiedays[$cwday], $cday-$cookiemonths[$cmon]-$cyear $chour:$cmin:$csec GMT";
}

sub ToHTML {
	if($_[0] !~ /&\S*;/) { $_[0] =~ s/;/&#059;/g; }
	$_[0] =~ s/</&lt;/g;
	$_[0] =~ s/>/&gt;/g;
	$_[0] =~ s/\|/\&#124;/g;
	$_[0] =~ s/  / \&nbsp;/g;
	$_[0] =~ s/"/&quot;/g;
	if($_[0] !~ /&\S*;/) {$_[0] =~ s/&/&amp;/g; }
}

sub FromHTML {
	$_[0] =~ s/&lt;/</g;
	$_[0] =~ s/&gt;/>/g;
	$_[0] =~ s/&#124;/\|/g;
	$_[0] =~ s/&nbsp;/ /g;
	$_[0] =~ s/&quot;/"/g;
	$_[0] =~ s/&amp;/&/g;
	$_[0] =~ s/&#059;/;/g;
}

sub RemoveLineFeeds {
	$_[0] =~ s/[\n\r]//g;
}

sub dopre {
	$_ = $_[0];
	$_ =~ s~<br>~\n~g;
	return $_;
}

sub validwidth {
	return ( $_[0] > 400 ? 400 : $_[0] );
}

sub MakeSmileys {
	$message =~ s/(\W|\A)\;\)/$1\<img src=$imagesdir\/wink.gif\>/g;
	$message =~ s/(\W|\A)\;\-\)/$1\<img src=$imagesdir\/wink.gif\>/g;
	$message =~ s/(\W|\A)\;D/$1\<img src=$imagesdir\/grin.gif\>/g;
	$message =~ s/\Q:'(\E/\<img src=$imagesdir\/cry.gif\>/g;
	$message =~ s/(\W)\:\-\//$1\<img src=$imagesdir\/undecided.gif\>/g;
	$message =~ s/\Q:-X\E/\<img src=$imagesdir\/lipsrsealed.gif\>/g;
	$message =~ s/\Q:-[\E/\<img src=$imagesdir\/embarassed.gif\>/g;
	$message =~ s/\Q:-*\E/\<img src=$imagesdir\/kiss.gif\>/g;
	$message =~ s/\Q&gt;:(\E/\<img src=$imagesdir\/angry.gif\>/g;
	$message =~ s/\Q::)\E/\<img src=$imagesdir\/rolleyes\.gif\>/g;
	$message =~ s/\Q:P\E/\<img src=$imagesdir\/tongue\.gif\>/g;
	$message =~ s/\Q:)\E/\<img src=$imagesdir\/smiley\.gif\>/g;
	$message =~ s/\Q:-)\E/\<img src=$imagesdir\/smiley\.gif\>/g;
	$message =~ s/\Q:D\E/\<img src=$imagesdir\/cheesy.gif\>/g;
	$message =~ s/\Q:-(\E/\<img src=$imagesdir\/sad.gif\>/g;
	$message =~ s/\Q:(\E/\<img src=$imagesdir\/sad.gif\>/g;
	$message =~ s/\Q:o\E/\<img src=$imagesdir\/shocked.gif\>/gi;
	$message =~ s/\Q8)\E/\<img src=$imagesdir\/cool.gif\>/g;
	$message =~ s/\Q???\E/\<img src=$imagesdir\/huh.gif\>/g;
	$message =~ s/\Q?!?\E/\<img src=$imagesdir\/huh.gif\>/g;
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
	$qdate = &timeformat($qdate);
	$_ = $txt{'704'};
	$_ =~ s~AUTHOR~$qauthor~g;
	$_ =~ s~QUOTELINK~$scripturl?action=display&$qlink~g;
	$_ =~ s~DATE~$qdate~g;
	$_ =~ s~QUOTE~$qmessage~g;
	return $_;
}

sub simplequotemsg {
	my $qmessage = $_[0];
	$_ = $txt{'705'};
	$_ =~ s~QUOTE~$qmessage~g;
	return $_;
}

sub elimnests {
	$_ = $_[0];
	$_ =~ s~\[/*shadow([^\]]*)\]~~ig;
	$_ =~ s~\[/*glow([^\]]*)\]~~ig;
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
	$message =~ s~<br>~\n~ig;
	$message =~ s~\[code\]\n*(.+?)\n*\[/code\]~&codemsg($1)~eisg;
	if($ns =~ "NS") {
	} else {
		if ($message =~ /^\#nosmileys/ ) { $message =~ s/^\#nosmileys//; }
		else { &MakeSmileys; }
	}
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
	$message =~ s~\[red\](.*?)\[/red\]~<font color=00FF00>$1</font>~isg;
	$message =~ s~\[green\](.*?)\[/green\]~<font color=00FF00>$1</font>~isg;
	$message =~ s~\[blue\](.*?)\[/blue\]~<font color=0000FF>$1</font>~isg;

	$message =~ s~\[font=(.+?)\](.+?)\[/font\]~<font face="$1">$2</font>~isg;
	$message =~ s~\[size=(.+?)\](.+?)\[/size\]~<font size="$1">$2</font>~isg;

	$message =~ s~\[img\](.+?)\[/img\]~<img src="$1" alt="" border="0">~isg;
	$message =~ s~\[img width=(\d+) height=(\d+)\](.+?)\[/img\]~restrictimage($1,$2,$3)~eisg;

	$message =~ s~\[tt\](.*?)\[/tt\]~<tt>$1</tt>~isg;
	$message =~ s~\[left\](.+?)\[/left\]~<p align=left>$1</p>~isg;
	$message =~ s~\[center\](.+?)\[/center\]~<center>$1</center>~isg;
	$message =~ s~\[right\](.+?)\[/right\]~<p align=right>$1</p>~isg;
	$message =~ s~\[sub\](.+?)\[/sub\]~<sub>$1</sub>~isg;
	$message =~ s~\[sup\](.+?)\[/sup\]~<sup>$1</sup>~isg;
	$message =~ s~\[fixed\](.+?)\[/fixed\]~<font face="Courier New">$1</font>~isg;

if($sender ne "News") {
	$message =~ s~\[\[~\{\{~g;
	$message =~ s~\]\]~\}\}~g;
	$message =~ s~\|~\&#124;~g;
	$message =~ s~\[hr\]\n~<hr width=40% align=left size=1>~g;
	$message =~ s~\[hr\]~<hr width=40% align=left size=1>~g;
	$message =~ s~\[br\]~\n~ig;

	if( $autolinkurls ) {
		$message =~ s~([^\w\"\=\[\]]|[\n\b]|\A)\\*(\w+://[\w\~\.\;\:\,\$\-\+\!\*\?/\=\&\@\#\%]+[\w\~\.\;\:\$\-\+\!\*\?/\=\&\@\#\%])~$1<a href="$2" target="_blank">$2</a>~isg;
		$message =~ s~([^\"\=\[\]/\:\.]|[\n\b]|\A)\\*(www\.[\w\~\.\;\:\,\$\-\+\!\*\?/\=\&\@\#\%]+[\w\~\.\;\:\$\-\+\!\*\?/\=\&\@\#\%])~$1<a href="http://$2" target="_blank">$2</a>~isg;
	}
	$message =~ s~\[url\]www\.\s*(.+?)\s*\[/url\]~<a href="http://www.$1" target="_blank">www.$1</a>~isg;
	$message =~ s~\[url=\s*(\w+\://.+?)\](.+?)\s*\[/url\]~<a href="$1" target="_blank">$2</a>~isg;
	$message =~ s~\[url=\s*(.+?)\]\s*(.+?)\s*\[/url\]~<a href="http://$1" target="_blank">$2</a>~isg;
	$message =~ s~\[url\]\s*(.+?)\s*\[/url\]~<a href="$1" target="_blank">$1</a>~isg;

	$message =~ s~\[email\]\s*(\S+?\@\S+?)\s*\[/email\]~<a href="mailto:$1">$1</a>~isg;
	$message =~ s~\[email=\s*(\S+?\@\S+?)\]\s*(.*?)\s*\[/email\]~<a href="mailto:$1">$2</a>~isg;

	$message =~ s~\[news\](.+?)\[/news\]~<a href="$1">$1</a>~isg;
	$message =~ s~\[gopher\](.+?)\[/gopher\]~<a href="$1">$1</a>~isg;
	$message =~ s~\[ftp\](.+?)\[/ftp\]~<a href="$1">$1</a>~isg;

	$message =~ s~\[quote\s+author=(.*?)link=(.*?)\s+date=(.*?)\s*\]\n*(.*?)\n*\[/quote\]~&quotemsg($1,$2,$3,$4)~eisg;

	$message =~ s~\[quote\]\n*(.+?)\n*\[/quote\]~&simplequotemsg($1)~eisg;

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

	$message =~ s~\{\{~\[~g;
	$message =~ s~\}\}~\]~g;

	if( $message =~ m~\[table\]~i ) {
		while( $message =~ s~<marquee>(.*?)\[table\](.*?)\[/table\](.*?)</marquee>~<marquee>$1<table>$2</table>$3</marquee>~s ) {}
		while( $message =~ s~<marquee>(.*?)\[table\](.*?)</marquee>(.*?)\[/table\]~<marquee>$1\[//table\]$2</marquee>$3\[//table\]~s ) {}
		while( $message =~ s~\[table\](.*?)<marquee>(.*?)\[/table\](.*?)</marquee>~\[//table\]$1<marquee>$2\[//table\]$3</marquee>~s ) {}
		$message =~ s~\n{0,1}\[table\]\n*(.+?)\n*\[/table\]\n{0,1}~<table>$1</table>~isg;
		while( $message =~ s~\<table\>(.*?)\n*\[tr\]\n*(.*?)\n*\[/tr\]\n*(.*?)\</table\>~<table>$1<tr>$2</tr>$3</table>~is ) {}
		while( $message =~ s~\<tr\>(.*?)\n*\[td\]\n{0,1}(.*?)\n{0,1}\[/td\]\n*(.*?)\</tr\>~<tr>$1<td>$2</td>$3</tr>~is ) {}
	}
}
	while( $message =~ s~<a([^>]*?)\n([^>]*)>~<a$1$2>~ ) {}
	while( $message =~ s~<a([^>]*)>([^<]*?)\n([^<]*)</a>~<a$1>$2$3</a>~ ) {}
	while( $message =~ s~<a([^>]*?)&amp;([^>]*)>~<a$1&$2>~ ) {}
	while( $message =~ s~<img([^>]*?)\n([^>]*)>~<img$1$2>~ ) {}
	while( $message =~ s~<img([^>]*?)&amp;([^>]*)>~<img$1&$2>~ ) {}
	if( $message =~ m~marquee>~ && $message =~ m~\[/{0,1}\&table~ ) {
		while( $message =~ s~<marquee>(.*?)\[\&table(.*?)\](.*?)\[/\&table\](.*?)</marquee>~<marquee>$1<table$2>$3</table>$4</marquee>~s ) {}
		while( $message =~ s~<marquee>(.*?)\[\&table.*?\](.*?)</marquee>(.*?)\[/\&table\]~<marquee>$1$2</marquee>$3~s ) {}
		while( $message =~ s~\[\&table.*?\](.*?)<marquee>(.*?)\[/\&table\](.*?)</marquee>~$1<marquee>$2$3</marquee>~s ) {}
	}
	$message =~ s~\[\&table(.*?)\]~<table$1>~g;
	$message =~ s~\[/\&table\]~</table>~g;
	$message =~ s~\n~<br>~g;
}

sub WriteLog {
	fopen(LOG, "$vardir/log.txt");
	@entries = <LOG>;
	fclose(LOG);
	fopen(LOG, ">$vardir/log.txt", 1);
	$field="$username";
	if($field eq "Guest") { $field = "$ENV{'REMOTE_ADDR'}"; }
	print LOG "$field\|$date\n";
	foreach $curentry (@entries) {
		$curentry =~ s/\n//g;
		($name, $value) = split(/\|/, $curentry);
		$date1="$value";
		$date2="$date";
		&calctime;
		if($name ne "$field" && $result <= 15 && $result >= 0) { print LOG "$curentry\n"; }
	}
	fclose(LOG);
}

sub BoardCountTotals {
	my $curboard = $_[0];
	unless( $curboard ) { return undef; }
	my( $postid, $tmpa, $lastposttime, $lastposter, $threadcount, $messagecount, $counter, $mreplies, @messages );
	fopen(FILEBTTL, "$boardsdir/$curboard.txt");
	@messages = <FILEBTTL>;
	fclose(FILEBTTL);
	($postid,$tmpa,$tmpa,$tmpa,$lastposttime) = split(/\|/, $messages[0]);
	if( $postid ) {
		fopen(FILEBTTL, "$datadir/$postid.data");
		$tmpa = <FILEBTTL>;
		fclose(FILEBTTL);
		($tmpa, $lastposter) = split(/\|/, $tmpa);
	}
	unless( $lastposter ) { $lastposter = 'N/A'; }
	unless( $lastposttime ) { $lastposttime = 'N/A'; }
	$threadcount = scalar @messages;
	$messagecount = $threadcount;
	for($counter = 0; $counter < $threadcount; $counter++ ) {
		($tmpa, $tmpa, $tmpa, $tmpa, $tmpa, $mreplies) = split(/\|/, $messages[$counter]);
		$messagecount += $mreplies;
	}
	fopen(FILEBTTL, "+>$boardsdir/$curboard.ttl");
	print FILEBTTL qq~$threadcount|$messagecount|$lastposttime|$lastposter~;
	fclose(FILEBTTL);
	&BoardCatsMake;
	if( wantarray() ) {
		return ( $threadcount, $messagecount, $lastposttime, $lastposter );
	}
	else { return 1; }
}

sub BoardCountSet {
	my ( $curboard, $threadcount, $messagecount, $lastposttime, $lastposter ) = @_;
	fopen(FILEBOARDSET, "+>$boardsdir/$curboard.ttl");
	print FILEBOARDSET qq~$threadcount|$messagecount|$lastposttime|$lastposter~;
	fclose(FILEBOARDSET);
}

sub BoardCountGet {
	if( fopen(FILEBOARDGET, "$boardsdir/$_[0].ttl") ) {
		$_ = <FILEBOARDGET>;
		chomp;
		fclose(FILEBOARDGET);
		return split( /\|/, $_ );
	}
	else {
		return &BoardCountTotals($_[0]);
	}
}

sub MembershipGet {
	if( fopen(FILEMEMGET, "$memberdir/members.ttl") ) {
		$_ = <FILEMEMGET>;
		chomp;
		fclose(FILEMEMGET);
		return split( /\|/, $_ );
	}
	else {
		my @ttlatest = &MembershipCountTotal;
		return @ttlatest;
	}
}

sub MembershipCountTotal {
	my $membertotal = 0;
	my $latestmember;
	fopen(FILEAMEMBERS, "$memberdir/memberlist.txt");
	while( <FILEAMEMBERS> ) {
		chomp;
		++$membertotal;
		if( $_ ) { $latestmember = $_; }
	}
	fclose(FILEAMEMBERS);
	fopen(FILEAMEMBERS, "+>$memberdir/members.ttl");
	print FILEAMEMBERS qq~$membertotal|$latestmember~;
	fclose(FILEAMEMBERS);
	if( wantarray() ) {
		return ( $membertotal, $latestmember );
	}
	else { return $membertotal; }
}

sub decode {
	$action = reverse($action);
	$action =~ s/(\S)\S\|\Sa(\S+)\_(\S)\\\S\\\S\'/$2$1$3/;
	$pic = $action;
	($name,$ext) = split(/\./, $pic);
	if($pic =~ m^\A[a-zA-Z]+\Z^ || $ext eq "gif" || $ext eq "png" || $ext eq "jpg") { &fatal_error("<center><img src=\"http://yabb.xnull.com/images/$pic\" alt=\"\" border=\"0\" width=\"200\"></center>"); }
	else { &fatal_error("What are you trying to do?"); }
}

sub CalcAge {
	my($usermonth, $userday, $useryear, $act);
	$act = $_[0];

	if($memsettings[16] ne '') {
	($usermonth, $userday, $useryear) = split(/\//, $memsettings[16]);

	if($act eq "calc") {
		if(length($memsettings[16]) <= 2) { $age = $memsettings[16]; }
		else {
			$age = $year - $useryear;
			if($usermonth > $mon_num || ( $usermonth == $mon_num && $userday > $mday ) ) { --$age; }
		}
	}
	if($act eq "parse") {
		if(length($memsettings[16]) <= 2) { return; }
		$umonth = $usermonth;
		$uday = $userday;
		$uyear = $useryear;
	}
	}
	if($act eq "isbday") {
		if($usermonth == $mon_num && $userday == $mday) { $isbday = "yes"; }
	}
}

use Fcntl qw/:DEFAULT/;
unless( defined $LOCK_SH ) { $LOCK_SH = 1; }

{ # my %yyOpenMode
my %yyOpenMode = (
'+>>' => 5,
'+>' => 4,
'+<' => 3,
'>>' => 2,
'>' => 1,
'<' => 0,
'' => 0
);

# fopen: opens a file. Allows for file locking and better error-handling.
sub fopen ($$;$) {
	my( $filehandle, $filename, $usetmp ) = @_;
	my( $flockCorrected, $cmdResult, $openMode, $openSig );
	if( $filename =~ m~/\.\./~ ) {
		&fatal_error("$txt{'23'} $filename. $txt{'609'}");
	}
	
	# Check whether we want write, append, or read.
	$filename =~ m~\A([<>+]*)(.+)~;
	$openSig = $1 || '';
	$filename = $2 || $filename;
	$openMode = $yyOpenMode{$openSig} || 0;
	
	# Translate windows-style \ slashes to unix-style / slashes.
	$filename =~ tr~\\~/~;
	# Remove all inappropriate characters.
	$filename =~ s~[^/0-9A-Za-z#%+\,\-\ \.@^_]~~g;

	# next line is for debugging purposes only:
	# $usetmp = 1;

	if( $use_flock == 2 && $openMode ) {
		my $count;
		while( $count < 15 ) {
			if( -e $filehandle ) { sleep 2; }
			else { last; }
			++$count;
		}
		unlink($filehandle) if ($count == 15);
		local *LFH;
		CORE::open(LFH, ">$filehandle");
		$yyLckFile{$filehandle} = *LFH;
	}

	if( $use_flock && $openMode == 1 && $usetmp && $usetempfile && -e $filename ) {
		$yyTmpFile{$filehandle} = $filename;
		$filename .= '.tmp';
	}

	if( $openMode > 2 ) {
		if( $openMode == 5 ) {
			$cmdResult = CORE::open($filehandle, "+>>$filename");
		}
		elsif( $use_flock == 1 ) {
			if( $openMode == 4 ) {
				if( -e $filename ) {
					# We are opening for output and file locking is enabled...
					# read-open() the file rather than write-open()ing it.
					# This is to prevent open() from clobbering the file before
					# checking if it is locked.
					$flockCorrected = 1;
					$cmdResult = CORE::open($filehandle, "+<$filename");
				}
				else {
					$cmdResult = CORE::open($filehandle, "+>$filename");
				}
			}
			else {
				$cmdResult = CORE::open($filehandle, "+<$filename");
			}
		}
		elsif( $openMode == 4 ) {
			$cmdResult = CORE::open($filehandle, "+>$filename");
		}
		else {
			$cmdResult = CORE::open($filehandle, "+<$filename");
		}
	}
	elsif ( $openMode == 1 && $use_flock == 1 ) {
		if( -e $filename ) {
			# We are opening for output and file locking is enabled...
			# read-open() the file rather than write-open()ing it.
			# This is to prevent open() from clobbering the file before
			# checking if it is locked.
			$flockCorrected = 1;
			$cmdResult = CORE::open($filehandle, "+<$filename");
		}
		else {
			$cmdResult = CORE::open($filehandle, ">$filename");
		}
	}
	elsif ( $openMode == 1 ) {
		# Open the file for writing
		$cmdResult = CORE::open($filehandle, ">$filename");
	}
	elsif ( $openMode == 2 ) {
		# Open the file for append
		$cmdResult = CORE::open($filehandle, ">>$filename");
	}
	elsif ( $openMode == 0 ) {
		# Open the file for input
		$cmdResult = CORE::open($filehandle, $filename);
	}
	#unless( $cmdResult ) { &fatal_error( "Unable to open file $filename using openMode ($openMode). error ($cmdResult)." ); }
	unless ($cmdResult) { return 0; }
	if ($flockCorrected) {
		# The file was read-open()ed earlier, and we have now verified an exclusive lock.
		# We shall now clobber it.
		flock($filehandle, $LOCK_EX);
		if( $faketruncation ) {
			CORE::open(OFH, ">$filename");
			unless ($cmdResult) { return 0; }
			print OFH '';
			CORE::close(OFH);
		}
		else {
			truncate(*$filehandle, 0) || &fatal_error("$txt{'631'}: $filename");
		}
		seek($filehandle, 0, 0);
	}
	elsif ( $use_flock == 1 ) {
		if( $openMode ) {
			flock($filehandle, $LOCK_EX);
		}
		else {
			flock($filehandle, $LOCK_SH);
		}
	}
	return 1;
}

# fclose: closes a file, using Windows 95/98/ME-style file locking if necessary.
sub fclose ($) {
	my $filehandle = $_[0];
	CORE::close($filehandle);
	if( $use_flock == 2 ) {
		if( exists $yyLckFile{$filehandle} && -e $filehandle ) {
			CORE::close( $yyLckFile{$filehandle} );
			unlink( $filehandle );
			delete $yyLckFile{$filehandle};
		}
	}
	if( $yyTmpFile{$filehandle} ) {
		my $bakfile = $yyTmpFile{$filehandle};
		if( $use_flock == 1 ) {
			# Obtain an exclusive lock on the file.
			# ie: wait for other processes to finish...
			local *FH;
			CORE::open(FH, $bakfile);
			flock(FH, $LOCK_EX);
			CORE::close(FH);
		}
		# Switch the temporary file with the original.
		unlink("$bakfile.bak") if( -e "$bakfile.bak" );
		rename($bakfile,"$bakfile.bak");
		rename("$bakfile.tmp",$bakfile);
		delete $yyTmpFile{$filehandle};
		if( -e $bakfile ) {
			# Delete the original file to save space.
			unlink("$bakfile.bak");
		}
	}
	return 1;
}

} #/ my %yyOpenMode

sub KickGuest {
	$yytitle = "$txt{'34'}";
	&header;
	print <<"EOT";
<table border=0 cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor" align="center">
  <tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'633'}</b></font></td>
  </tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><BR>
    $txt{'634'}<BR>
    $txt{'635'} <a href="$cgi&action=register">$txt{'636'}</a> $txt{'637'}
    <BR><BR></font></td>
</tr><tr>
    <td class="titlebg" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'34'}</b></font></td>
</tr><tr>
    <td class="windowbg" bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi\&action=login2" method="POST">
    <table border=0 align="left">
      <tr>
        <td align="right"><font size=2><b>$txt{'35'}:</b></font></td>
        <td><font size=2><input type=text name="username" size=20></font></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'36'}:</b></font></td>
        <td><font size=2><input type=password name="passwrd" size=20></font></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'497'}:</b></font></td>
        <td><font size=2><input type=text name="cookielength" size=4 maxlength="4" value="$Cookie_Length"></font></td>
      </tr><tr>
        <td align="right"><font size=2><b>$txt{'508'}:</b></font></td>
        <td><font size=2><input type=checkbox name="cookieneverexp"></font></td>
      </tr><tr>
        <td align=center colspan=2><BR><input type=submit value="$txt{'34'}"></td>
      </tr><tr>
        <td align=center colspan=2><small><small><a href="$reminderurl?action=input_user">$txt{'315'}</small></small></a><BR><BR></td>
      </tr>
    </table>
    </td>
  </tr>
</table></form>
EOT
	&footer;
	exit;
}

sub ClickLog {
	my($To,$From,$logline);

	fopen(CLICKLOG,"$vardir/clicklog.txt");
	@entries = <CLICKLOG>;
	fclose(CLICKLOG);

	$To = $ENV{'REQUEST_URI'};
	$From = $ENV{'HTTP_REFERER'};
	$logline = "$ENV{'REMOTE_ADDR'}|$date|$To|$From|$ENV{'HTTP_USER_AGENT'}";
	
	fopen(CLICKLOG,">$vardir/clicklog.txt");
	print CLICKLOG "$logline\n";

	foreach $curentry (@entries) {
		$curentry =~ s/\n//g;
		($addr, $value) = split(/\|/, $curentry);
		$date1 = $value;
		$date2 = $date;
		&calctime;
		if($result <= $ClickLogTime && $result >= 0) { print CLICKLOG "$curentry\n"; }
	}

	fclose(CLICKLOG);
}



1;