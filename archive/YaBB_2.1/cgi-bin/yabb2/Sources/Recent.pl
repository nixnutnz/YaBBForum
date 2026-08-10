###############################################################################
# Recent.pl                                                                   #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Community Software for Webmasters                               #
# Version:        YaBB 2.1                                                    #
# Released:       November 8, 2005                                            #
# Distributed by: http://www.yabbforum.com                                    #
# =========================================================================== #
# Copyright (c) 2000-2005 YaBB (www.yabbforum.com) - All Rights Reserved.     #
# Software by: The YaBB Development Team                                      #
#              with assistance from the YaBB community.                       #
# Sponsored by: Xnull Internet Media, Inc. - http://www.ximinc.com            #
#               Your source for web hosting, web design, and domains.         #
###############################################################################

$recentplver = 'YaBB 2.1 $Revision: 1.1 $';
if ($action eq 'detailedversion') { return 1; }

# Sub RecentTopics shows all the most recently posted topics
# Meaning each thread will show up ONCE in the list.

# Sub RecentPosts will show the 10 last POSTS
# Even if they are all from the same thread

# Sub RecentTopicList is just a plain list (without body text)
# Same as Sub RecentTopics.

sub RecentTopics {
	&spam_protection;
	my $display = $INFO{'display'} ||= 10;
	my (@memset, @categories, %data, $numfound, $curcat, %catname, %cataccess, %catboards, $openmemgr, @membergroups, %openmemgr, $curboard, @threads, @boardinfo, $i, $c, @messages, $tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mns, $mtime, $counter, $board, $notify);

	$numfound = 0;

	unless ($mloaded == 1) { require "$boardsdir/forum.master"; }
	foreach $catid (@categoryorder) {
		$boardlist = $cat{$catid};

		(@bdlist) = split(/\,/, $boardlist);
		($catname, $catperms) = split(/\|/, $catinfo{"$catid"});
		$cataccess = &CatAccess($catperms);
		if (!$cataccess) { next; }

		foreach $curboard (@bdlist) {
			($boardname{$curboard}, $boardperms, $boardview) = split(/\|/, $board{"$curboard"});

			my $access = &AccessCheck($curboard, '', $boardperms);
			if (!$iamadmin && $access ne "granted") { next; }

			$catname{$curboard} = $catname;

			fopen(REC_BDTXT, "$boardsdir/$curboard.txt");
			for ($i = 0; $i < $display && ($buffer = <REC_BDTXT>); $i++) {
				($tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate) = split(/\|/, $buffer);
				unless ($tstate =~ /h/) {
					$mtime = $tdate;
					$data[$numfound] = "$mtime|$curboard|$tnum|$treplies|$tusername|$tname|$tstate";
					$numfound++;
				}
			}
			fclose(REC_BDTXT);
		}
	}

	@data     = reverse sort @data;
	$numfound = 0;

	for ($i = 0; $i < @data; $i++) {
		($mtime, $curboard, $tnum, $treplies, $tusername, $tname, $tstate) = split(/\|/, $data[$i]);
		unless ($tstate =~ /h/) {
			fopen(REC_THRETXT, "$datadir/$tnum.txt") || next;
			while (<REC_THRETXT>) { $message = $_; }

			# get only the last post for this thread.
			fclose(REC_THRETXT);
			chomp $message;

			if ($message) {
				($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns) = split(/\|/, $message);
				$messages[$numfound] = "$curboard|$tnum|$treplies|$tusername|$tname|$msub|$mname|$memail|$mdate|$musername|$micon|$mattach|$mip|$message|$mns|$tstate";
				$numfound++;
			}
			if ($numfound == $display) { last; }
		}
	}

	if ($numfound > 0) {
		$counter = 1;
		&LoadCensorList;
	} else {
		$yymain .= qq~<hr class="hr" /><b>$txt{'170'}</b><hr />~;
	}
	for ($i = 0; $i < $numfound; $i++) {
		($board, $tnum, $c, $tusername, $tname, $msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns, $tstate) = split(/\|/, $messages[$i]);
		$displayname = $mname;

		if ($tusername ne 'Guest' && -e ("$memberdir/$tusername.vars")) { &LoadUser($tusername); }
		if (${$uid.$tusername}{'regtime'}) {
			$registrationdate = ${$uid.$tusername}{'regtime'};
		} else {
			$registrationdate = int(time);
		}
		if (${$uid.$tusername}{'regdate'} && $mtime > $registrationdate) {
			$tname = qq~<a href="$scripturl?action=viewprofile;username=$tusername">${$uid.$tusername}{'realname'}</a>~;
		} elsif ($tusername !~ m~Guest~ && $mtime < $registrationdate) {
			$tname = qq~$tusername - $maintxt{'470a'}~;
		} else {
			$tname = "$tusername";
		}

		if ($musername ne 'Guest' && -e ("$memberdir/$musername.vars")) { &LoadUser($musername); }
		if (${$uid.$musername}{'regtime'}) {
			$registrationdate = ${$uid.$musername}{'regtime'};
		} else {
			$registrationdate = int(time);
		}
		if (${$uid.$musername}{'regdate'} && $mdate > $registrationdate) {
			$mname = qq~<a href="$scripturl?action=viewprofile;username=$musername">${$uid.$musername}{'realname'}</a>~;
		} elsif ($musername !~ m~Guest~ && $mdate < $registrationdate) {
			$mname = qq~$musername - $maintxt{'470a'}~;
		} else {
			$mname = "$musername";
		}

		$message = &Censor($message);
		$msub    = &Censor($msub);

		&wrap;
		if ($enable_ubbc) {
			$ns = $mns;
			if (!$yyYaBBCloaded) { require "$sourcedir/YaBBC.pl"; }
			&DoUBBC;
		}
		&wrap2;
		&ToChars($msub);
		&ToChars($message);
		&ToChars($boardname{$board});
		$msub =~ s/\A\[m\]/$maintxt{'758'}/;

		if ($enable_notification) { $notify = qq~$menusep<a href="$scripturl?board=$board;action=notify;thread=$tnum/$startnum">$img{'notify'}</a>~; }
		$mdate = &timeformat($mdate);
		$yymain .= qq~
<table border="0" width="100%" cellspacing="1" class="bordercolor" style="table-layout: fixed;">
  <tr>
    <td width="5%" align="center" class="titlebg">$counter</td>
    <td width="95%" class="titlebg">&nbsp;$catname{$board} / $boardname{$board} / <a href="$scripturl?num=$tnum/$c#$c"><u>$msub</u></a><br />
    &nbsp;<span class="small">$maintxt{'30'}: $mdate&nbsp;</span></td>
  </tr><tr>
    <td colspan="2" class="catbg">$maintxt{'109'} $tname | $maintxt{'197'} $mname</td>
  </tr><tr>
    <td colspan="2" class="windowbg2" valign="top"><div style="max-height: 150px; width: 100%; overflow: auto;">$message</div></td>
  </tr><tr>
    <td colspan="2" class="catbg" align="right">
~;
		if ($tstate != 1) {
			$yymain .= qq~<a href="$scripturl?board=$board;action=post;num=$tnum/$c#$c;title=PostReply">$img{'reply'}</a>$menusep<a href="$scripturl?board=$board;action=post;num=$tnum;quote=$c;title=PostReply">$img{'recentquote'}</a>$notify &nbsp;~;
		}
		$yymain .= qq~
    </td>
  </tr>
</table><br />
~;
		++$counter;
	}

	$yymain .= qq~
<font size="1"><a href="$cgi">$txt{'236'}</a> $txt{'237'}<br /></font>
~;
	$yytitle = $txt{'214'};
	&template;
	exit;
}

sub RecentPosts {
	&spam_protection;
	my $display = $INFO{'display'} ||= 10;
	my (@memset, @categories, %data, $numfound, $curcat, %catname, %cataccess, %catboards, $openmemgr, @membergroups, %openmemgr, $curboard, @threads, @boardinfo, $i, $c, @messages, $tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mns, $mtime, $counter, $board, $notify);

	$numfound = 0;

	unless ($mloaded == 1) { require "$boardsdir/forum.master"; }
	foreach $catid (@categoryorder) {
		$boardlist = $cat{$catid};

		(@bdlist) = split(/\,/, $boardlist);
		($catname, $catperms) = split(/\|/, $catinfo{"$catid"});
		$cataccess = &CatAccess($catperms);
		if (!$cataccess) { next; }

		foreach $curboard (@bdlist) {
			($boardname{$curboard}, $boardperms, $boardview) = split(/\|/, $board{"$curboard"});

			my $access = &AccessCheck($curboard, '', $boardperms);
			if (!$iamadmin && $access ne "granted") { next; }

			$catname{$curboard} = $catname;

			fopen(REC_BDTXT, "$boardsdir/$curboard.txt");
			for ($i = 0; $i < $display && ($buffer = <REC_BDTXT>); $i++) {
				($tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate) = split(/\|/, $buffer);
				unless ($tstate =~ /h/) {
					$mtime = $tdate;
					$data[$numfound] = "$mtime|$curboard|$tnum|$treplies|$tusername|$tname|$tstate";
					$numfound++;
				}
			}
			fclose(REC_BDTXT);
		}
	}

	@data = reverse sort @data;

	$numfound    = 0;
	$threadfound = @data > $display ? $display : @data;

	for ($i = 0; $i < $threadfound; $i++) {
		($mtime, $curboard, $tnum, $treplies, $tusername, $tname, $tstate) = split(/\|/, $data[$i]);
		unless ($tstate =~ /h/) {
			$tstart = $mtime;
			fopen(REC_THRETXT, "$datadir/$tnum.txt") || next;
			@mess = <REC_THRETXT>;
			fclose(REC_THRETXT);

			$threadfrom = @mess > $display ? @mess - $display : 0;
			for ($ii = $threadfrom; $ii < @mess + 1; $ii++) {
				if ($mess[$ii]) {
					($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns) = split(/\|/, $mess[$ii]);
					$mtime = $mdate;
					$messages[$numfound] = "$mtime|$curboard|$tnum|$ii|$tusername|$tname|$msub|$mname|$memail|$mdate|$musername|$micon|$mattach|$mip|$message|$mns|$tstate|$tstart";
					$numfound++;
				}
			}
		}
	}

	@messages = reverse sort @messages;

	if ($numfound > 0) {
		if ($numfound > $display) { $numfound = $display; }
		$counter = 1;
		&LoadCensorList;
	} else {
		$yymain .= qq~<hr class="hr"><b>$txt{'170'}</b><hr>~;
	}
	for ($i = 0; $i < $numfound; $i++) {
		($dummy, $board, $tnum, $c, $tusername, $tname, $msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns, $tstate, $trstart) = split(/\|/, $messages[$i]);
		$displayname = $mname;

		if ($tusername ne 'Guest' && -e ("$memberdir/$tusername.vars")) { &LoadUser($tusername); }
		if (${$uid.$tusername}{'regtime'}) {
			$registrationdate = ${$uid.$tusername}{'regtime'};
		} else {
			$registrationdate = int(time);
		}
		if (${$uid.$tusername}{'regdate'} && $trstart > $registrationdate) {
			$tname = qq~<a href="$scripturl?action=viewprofile;username=$tusername">${$uid.$tusername}{'realname'}</a>~;
		} elsif ($tusername !~ m~Guest~ && $trstart < $registrationdate) {
			$tname = qq~$tusername - $maintxt{'470a'}~;
		} else {
			$tname = "$tusername";
		}

		if ($musername ne 'Guest' && -e ("$memberdir/$musername.vars")) { &LoadUser($musername); }
		if (${$uid.$musername}{'regtime'}) {
			$registrationdate = ${$uid.$musername}{'regtime'};
		} else {
			$registrationdate = int(time);
		}
		if (${$uid.$musername}{'regdate'} && $mdate > $registrationdate) {
			$mname = qq~<a href="$scripturl?action=viewprofile;username=$musername">${$uid.$musername}{'realname'}</a>~;
		} elsif ($musername !~ m~Guest~ && $mdate < $registrationdate) {
			$mname = qq~$musername - $maintxt{'470a'}~;
		} else {
			$mname = "$musername";
		}

		$message = &Censor($message);
		$msub    = &Censor($msub);
		&wrap;
		if ($enable_ubbc) {
			$ns = $mns;
			if (!$yyYaBBCloaded) { require "$sourcedir/YaBBC.pl"; }
			&DoUBBC;
		}
		&wrap2;
		&ToChars($msub);
		&ToChars($message);
		&ToChars($boardname{$board});
		$msub =~ s/\A\[m\]/$maintxt{'758'}/;

		if ($enable_notification) { $notify = qq~$menusep<a href="$scripturl?board=$board;action=notify;thread=$tnum/$startnum">$img{'notify'}</a>~; }
		$mdate = &timeformat($mdate);
		$yymain .= qq~
<table border="0" width="100%" cellspacing="1" class="bordercolor" style="table-layout: fixed;">
  <tr>
    <td width="5%" align="center" class="titlebg">$counter</td>
    <td width="95%" class="titlebg">&nbsp;$catname{$board} / $boardname{$board} / <a href="$scripturl?num=$tnum/$c#$c"><u>$msub</u></a><br />
    &nbsp;<span class="small">$maintxt{'30'}: $mdate&nbsp;</span></td>
  </tr><tr>
    <td colspan="2" class="catbg">$maintxt{'109'} $tname | $maintxt{'197'} $mname</td>
  </tr><tr>
    <td colspan="2" class="windowbg2" valign="top">$message</td>
  </tr><tr>
    <td colspan="2" class="catbg" align="right">
~;
		if ($tstate != 1) {
			$yymain .= qq~<a href="$scripturl?board=$board;action=post;num=$tnum/$c#$c;title=PostReply">$img{'reply'}</a>$menusep<a href="$scripturl?board=$board;action=post;num=$tnum;quote=$c;title=PostReply">$img{'recentquote'}</a>$notify &nbsp;~;
		}
		$yymain .= qq~
    </td>
  </tr>
</table><br />
~;
		++$counter;
	}

	$yymain .= qq~
<font size="1"><a href="$cgi">$txt{'236'}</a> $txt{'237'}<br /></font>
~;
	$yytitle = $txt{'214'};
	&template;
	exit;
}

sub RecentTopicsList {
	&spam_protection;

	# Can pass items to this sub, to decide what to show:
	my ($show_count, $show_board, $show_poster, $show_date) = @_;

	$display = $INFO{'display'} ||= 10;
	if    ($display < 0)   { $display = 5; }
	elsif ($display > 100) { $display = 100; }

	my (@memset, @categories, %data, $numfound, $curcat, %catname, %cataccess, %catboards, $openmemgr, @membergroups, %openmemgr, $curboard, @threads, @boardinfo, $i, $c, @messages, $tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mns, $mtime, $counter, $board, $notify);
	$numfound = 0;

	foreach $catid (@categoryorder) {
		$boardlist = $cat{$catid};

		(@bdlist) = split(/\,/, $boardlist);
		($catname, $catperms) = split(/\|/, $catinfo{"$catid"});
		$cataccess = &CatAccess($catperms);
		if (!$cataccess) { next; }

		foreach $curboard (@bdlist) {
			($boardname{$curboard}, $boardperms, $boardview) = split(/\|/, $board{"$curboard"});

			my $access = &AccessCheck($curboard, '', $boardperms);
			if (!$iamadmin && $access ne "granted") { next; }

			$catname{$curboard} = $catname;

			fopen(REC_BDTXT, "$boardsdir/$curboard.txt");
			for ($i = 0; $i < $display && ($buffer = <REC_BDTXT>); $i++) {
				($tnum, $tsub, $tname, $temail, $tdate, $treplies, $tusername, $ticon, $tstate) = split(/\|/, $buffer);
				unless ($tstate =~ /h/) {
					$mtime = $tdate;
					$data[$numfound] = "$mtime|$curboard|$tnum|$treplies";
					$numfound++;
				}
			}
			fclose(REC_BDTXT);
		}
	}

	@data     = reverse sort @data;
	$numfound = 0;

	for ($i = 0; $i < @data; $i++) {
		($mtime, $curboard, $tnum, $treplies) = split(/\|/, $data[$i]);

		fopen(REC_THRETXT, "$datadir/$tnum.txt") || next;
		while (<REC_THRETXT>) { $message = $_; }

		# get only the last post for this thread.
		fclose(REC_THRETXT);
		chomp $message;

		if ($message) {
			($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $message, $mns) = split(/\|/, $message);
			$messages[$numfound] = "$curboard|$tnum|$treplies|$msub|$mname|$mdate|$musername";
			$numfound++;
		}
		if ($numfound == $display) { last; }
	}
	&LoadCensorList;

	$counter = 1;

	$yymain .= qq~
    <div class="bordercolor">
        <div class="titlebg" align="center">
        <b>$display most recent topics</b></td>
		</div>
        <table width="100%" cellpadding="0" align="center" class="windowbg2">
~;
	for ($i = 0; $i < $numfound; $i++) {
		($board, $tnum, $c, $msub, $mname, $mdate, $musername) = split(/\|/, $messages[$i]);
		$msub = &Censor($msub);
		&ToChars($msub);
		if ($musername ne 'Guest' && -e "$memberdir/$musername.vars") {
			&LoadUser($musername);
			$mname = exists ${$uid.$musername}{'realname'} ? ${$uid.$musername}{'realname'} : $mname;
			$mname ||= $txt{'470'};
			$mname = qq~<a href="$scripturl?action=viewprofile;username=$useraccount{$musername}" title="$txt{'27'}: $musername">$mname</a>~;
		}
		$mdate = &timeformat($mdate);

		# Strip all Re: from subject lines
		# only if it occurs at the start.
		$msub =~ s/\ARe: //ig;

		# Change [m] to Moved:
		$msub =~ s/\A\[m\]/$maintxt{'758'}/;

		$yymain .= qq~          <tr>~;

		if ($show_count) {
			$yymain .= qq~

            <td valign="top" align="left"><span class="small">
                $counter.</span>
            </td>
~;
		}

		if ($show_board) {
			$yymain .= qq~
             <td valign="top" align="left"><span class="small">
                &nbsp; &nbsp; $boardname{$board} &nbsp;
				</span>
            </td>
~;
		}

		$yymain .= qq~
       	    <td valign="top" align="left"><span class="small">
                <a href="$scripturl?num=$tnum/$c#$c" class="nav" target="_parent">$msub</a> $txt{'525'}
~;

		if ($show_poster) {
			$yymain .= qq~$mname
~;
		}

		$yymain .= qq~
				</span>
            </td>
~;

		if ($show_date) {
			$yymain .= qq~
       	    <td valign="top" align="right"><font size="1">
				$mdate &nbsp;
            </td>
          </tr>
~;
		}

		++$counter;
	}

	$yymain .= qq~
        </table>
      </div><br />
~;
	&template;
	exit;

}

1;
