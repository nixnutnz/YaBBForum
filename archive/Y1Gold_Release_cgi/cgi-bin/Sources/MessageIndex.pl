###############################################################################
# MessageIndex.pl                                                             #
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

$messageindexplver="1 Gold - Release";

sub MessageIndex {
	my $start = int( $INFO{'start'} ) || 0;
	my( $bdescrip, $counter, $buffer, $pages, $showmods, $mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate, $dlp, $threadlength, $threaddate );
	my( @boardinfo, @threads );
	my( $threadcount, $messagecount, $lastposttime, $lastposter ) = &BoardCountGet($currentboard);
	my $maxindex = $INFO{'view'} eq 'all' ? $threadcount : $maxdisplay;

	# Make sure the starting place makes sense.
	if( $start > $threadcount ) { $start = int( $threadcount % $maxindex ) * $maxindex; }
	elsif( $start < 0 ) { $start = 0; }

	# Construct the page links for this board.
	$tmpa = $start - $maxindex;
	$pageindex .= $start == 0 ? qq~ ~ : qq~<a href="$cgi&action=messageindex&start=$tmpa">&#171;</a> ~;
	$tmpa = 1;
	for( $counter = 0; $counter < $threadcount; $counter += $maxindex ) {
		$pageindex .= $start == $counter ? qq~<B>$tmpa</B> ~ : qq~<a href="$cgi&action=messageindex&start=$counter">$tmpa</a> ~;
		++$tmpa;
	}
	$tmpa = $start + $maxindex;
	$tmpa = $tmpa > $threadcount ? $threadcount : $tmpa;
	if($start != $counter-$threadcount) {
		$pageindex .= $tmpa > $counter-$maxindex ? qq~ ~ : qq~<a href="$cgi&action=messageindex&start=$tmpa">&#187;</a> ~;
	}


	# Determine what category we are in.
	fopen(FILE, "$boardsdir/$currentboard.ctb") || &fatal_error("300 $txt{'106'}: $txt{'23'} $currentboard.ctb");
	$cat = <FILE>;
	fclose(FILE);
	fopen(FILE, "$boardsdir/$cat.cat") || &fatal_error("300 $txt{'106'}: $txt{'23'} $cat.cat");
	$currcat = $cat;
	$cat = <FILE>;
	fclose(FILE);
	#$counter = 0;
	#while($counter == 0) { $cat = $temp; }

	# Get the board's description
	fopen(FILE, "$boardsdir/$currentboard.dat") || &fatal_error("300 $txt{'106'}: $txt{'23'} $currentboard.dat");
	@boardinfo = <FILE>;
	fclose(FILE);
	chomp @boardinfo;
	$bdescrip = $boardinfo[1];
	
	# Open and quickly read the current board thread list.
	# Skip past threads until we reach the "page" we want.
	fopen(FILE, "$boardsdir/$currentboard.txt") || &fatal_error("300 $txt{'106'}: $txt{'23'} $currentboard.txt");
	$counter = 0;
	$tmpa = '';
	if( $counter < $start && ( $buffer = <FILE> ) ) {
		$tmpa = $buffer;
		$counter++;
	}
	while( $counter < $start && ( $buffer = <FILE> ) ) {
		$counter++;
	}

	$#threads = $maxindex - 1;
	$counter = 0;
	while( $counter < $maxindex && ( $buffer = <FILE> ) ) {
		chomp $buffer;
		$threads[$counter] = $buffer;
		$counter++;
	}
	fclose(FILE);
	$#threads = $counter - 1;

	# Let's get the info for the first thread in this forum.
	$tmpa ||= $threads[0];
	($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split( /\|/, $tmpa );

	# Mark current board as seen.
	&dumplog($currentboard);

	# Build a list of the board's moderators.
	if( scalar keys %moderators > 0 ) {
		if( scalar keys %moderators == 1 ) {
			$showmods = qq~($txt{'298'}: ~;
		}
		else {
			$showmods = qq~($txt{'299'}: ~;
		}
		while( $_ = each(%moderators) ) {
			&FormatUserName($_);
			$showmods .= qq~<a href="$scripturl?action=viewprofile&username=$useraccount{$_}" class="nav">$moderators{$_}</a>, ~;
		}
		$showmods =~ s/, \Z/)/;
	}

	# Load censor list.
	fopen(FILE,"$vardir/censor.txt");
	while( chomp( $buffer = <FILE> ) ) {
		($tmpa,$tmpb) = split(/=/,$buffer);
		push(@censored,[$tmpa,$tmpb]);
	}
	fclose(FILE);

	# Print the header and board info.
	$yytitle = $boardname;
	&header;
	$curboardurl = $curposlinks ? qq~<a href="$cgi" class="nav">$boardname</a>~ : $boardname;
	print << "EOT";
<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td><font size="2" class="nav"><b>
    <IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
    <a href="$scripturl" class="nav">$mbname</a><br>
    <IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
    <a href="$scripturl#$currcat" class="nav">$cat</a><br>
    <IMG SRC="$imagesdir/tline2.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;
    $curboardurl</b>
    $showmods</font></td>
  </tr>
</table>
EOT
if($ShowBDescrip) {
print <<EOT;
<table width="100%" cellpadding=3 cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr height="30">
    <td align="left" class="catbg" bgcolor="$color{'catbg'}" width="100%">
    <table cellpadding="3" cellspacing="0" width="100%">
      <tr>
        <td width="100%"><font size="1">$bdescrip</font></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
EOT
}
print <<EOT;
<table width="100%" cellpadding=3 cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr height="30">
    <td align="left" class="catbg" bgcolor="$color{'catbg'}" width="100%">
    <table cellpadding="3" cellspacing="0" width="100%">
      <tr>
        <td><font size=2><b>$txt{'139'}:</b> $pageindex</font></td>
	<td align="right" width="200" nowrap><font size=-1>
EOT
	if ($username ne 'Guest') {
if($showmarkread) { 
	print qq~	<a href="$cgi&action=markasread">$img{'markboardread'}</a>~;
}
}
	print << "EOT";
	$menusep<a href="$cgi&action=post&title=$txt{'464'}">$img{'newthread'}</a>&nbsp;
	</font></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
<table border=0 width="100%" cellspacing=1 cellpadding="4" bgcolor="$color{'bordercolor'}" class="bordercolor">
<tr>
	<td class="titlebg" bgcolor="$color{'titlebg'}" width="10%" colspan="2"><font size=2>&nbsp;</font></td>
	<td class="titlebg" bgcolor="$color{'titlebg'}" width="48%"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'70'}</b></font></td>
	<td class="titlebg" bgcolor="$color{'titlebg'}" width="14%"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'109'}</b></font></td>
	<td class="titlebg" bgcolor="$color{'titlebg'}" width="4%" align="center"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'110'}</b></font></td>
	<td class="titlebg" bgcolor="$color{'titlebg'}" width="4%" align="center"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'301'}</b></font></td>
	<td class="titlebg" bgcolor="$color{'titlebg'}" width="27%"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'111'}</b></font></td>
EOT

	# Begin printing the message index for current board.
	$counter = $start;
	foreach( @threads ) {
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split( /\|/, $_ );
		# Set thread class depending on locked status and number of replies.
		if( $mstate == 1 ) { $threadclass = 'locked'; }
		elsif( $mreplies > 24 ) { $threadclass = 'veryhotthread'; }
		elsif( $mreplies > 14 ) { $threadclass = 'hotthread'; }
		elsif( $mstate == 0 ) { $threadclass = 'thread'; }

		# Decide if thread should have the "NEW" indicator next to it.
		# Do this by reading the user's log for last read time on thread,
		# and compare to the last post time on the thread.
		$dlp = &getlog($mnum);
		$threaddate = stringtotime($mdate);
		if( $max_log_days_old && $dlp != $threaddate && $username ne 'Guest' && &getlog("$currentboard--mark") < $threaddate ) {
			$new = qq~<img src="$imagesdir/new.gif" alt="$txt{'302'}">~;
		}
		else { $new = ''; }

		# Load the current nickname of the account name of the thread starter.
		if( $musername ne 'Guest' && -e "$memberdir/$musername.dat" ) {
			&LoadUser($musername);
			$mname = $userprofile{$musername}->[1] || $mname || $txt{'470'};
			$mname = qq~<a href="$scripturl?action=viewprofile&username=$useraccount{$musername}" alt="$txt{'27'}: $musername">$mname</a>~;
		}
		else {
			$mname ||= $txt{'470'};
		}

		# Censor the subject of the thread.
		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$msub =~ s~\Q$tmpa\E~$tmpb~gi;
		}

		# Decide how many pages the thread should have.
		$threadlength = $mreplies + 1;
		$pages = '';
		if( $threadlength > $maxmessagedisplay ) {
			$tmpa = 1;
			for( $tmpb = 0; $tmpb < $threadlength; $tmpb += $maxmessagedisplay ) {
				$pages .= qq~<a href="$cgi&action=display&num=$mnum&start=$tmpb">$tmpa</a>\n~;
				++$tmpa;
			}
			$pages =~ s/\n\Z//;
			$pages = qq~<font size="1">&#171; $pages &#187;</font>~;
		}

		if( fopen(FILE, "$datadir/$mnum.data") ) {
			$tmpa = <FILE>;
			fclose(FILE);
		}
		elsif( -e "$datadir/$mnum.data" ) {
			&fatal_error("301 $txt{'106'}: $txt{'23'} $mnum.data");
		}
		else {
			$tmpa = '0';
		}


		($views, $lastposter) = split(/\|/, $tmpa);
		if( $lastposter =~ m~\AGuest-(.*)~ ) {
			$lastposter = $1;
		}
		else {
			unless( $lastposter eq $txt{'470'} ) {
				$lastposterid = $lastposter;
				&LoadUser($lastposterid);
				if($userprofile{$lastposter}->[1]) { $lastposter = qq~<a href="$scripturl?action=viewprofile&username=$lastposterid">$userprofile{$lastposter}->[1]</a>~; }
			}
			&LoadUser($lastposter);
		}
		$lastpostername = $lastposter || $txt{'470'};
		$views = $views ? $views - 1 : 0;

		# Print the thread info.
		$mydate = &timeformat($mdate);
		print << "EOT";
<tr>
	<td class="windowbg2" valign="middle" align="center" width="6%" bgcolor="$color{'windowbg2'}"><img src="$imagesdir/$threadclass.gif"></td>
	<td class="windowbg2" valign="middle" align="center" width="4%" bgcolor="$color{'windowbg2'}"><img src="$imagesdir/$micon.gif" alt="" border="0" align=middle></td>
	<td class="windowbg" valign="middle" width="48%" bgcolor="$color{'windowbg'}"><font size=2><a href="$cgi&action=display&num=$mnum"><b>$msub</b></a> $new $pages</font></td>
	<td class="windowbg2" valign="middle" width="14%" bgcolor="$color{'windowbg2'}"><font size=2>$mname</font></td>
	<td class="windowbg" valign="middle" width="4%" align="center" bgcolor="$color{'windowbg'}"><font size=2>$mreplies</font></td>
	<td class="windowbg" valign="middle" width="4%" align="center" bgcolor="$color{'windowbg'}"><font size=2>$views</font></td>
	<td class="windowbg2" valign="middle" width="27%" bgcolor="$color{'windowbg2'}"><font size=1>$mydate<br>$txt{'525'} $lastpostername</font></td>
</tr>
EOT
		++$counter;
	}

	print << "EOT";
</table>
<table width="100%" cellpadding=3 cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr height="30">
    <td align="left" class="catbg" bgcolor="$color{'catbg'}" width="100%">
    <table cellpadding="3" cellspacing="0" width="100%">
      <tr>
        <td><font size=2><b>$txt{'139'}:</b> $pageindex</font></td>
	<td class="catbg" bgcolor="$color{'catbg'}" align=right width="200"><font size=-1>
EOT
	if ($username ne 'Guest') {
if($showmarkread) { 
	print qq~<a href="$cgi&action=markasread">$img{'markboardread'}</a>~;
}
}
	&jumpto;
	print << "EOT";
	$menusep<a href="$cgi&action=post&title=$txt{'464'}">$img{'newthread'}</a>&nbsp;
	</font></td>
      </tr>
    </table>
    </td>
  </tr>
</table>
<table cellpadding=0 cellspacing=0 width="100%">
  <tr>
    <td align="left" valign="middle"><font size=1>
    <img src="$imagesdir/hotthread.gif"> $txt{'454'}
    <BR><img src="$imagesdir/veryhotthread.gif"> $txt{'455'}</td>
    <td align="left" valign="middle"><font size=1>
    <img src="$imagesdir/locked.gif"> $txt{'456'}
    <BR><img src="$imagesdir/thread.gif"> $txt{'457'}</font></td>
    <td align="right" valign="middle"><form action="$scripturl" method="GET">
    <font size=1>$txt{'160'}: <select name="board">$selecthtml</select> <input type=submit value="$txt{'161'}"></form></td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub MarkRead {
	# Mark all threads in this board as read.
	&dumplog("$currentboard--mark");
	&MessageIndex;
}
1;