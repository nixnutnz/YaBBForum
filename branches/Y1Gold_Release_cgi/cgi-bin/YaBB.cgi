#!/usr/bin/perl

###############################################################################
# YaBB.pl                                                                     #
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

### Requirements and Errors ###
use CGI::Carp qw(fatalsToBrowser);
require "Settings.pl";
require "$language";
require "$sourcedir/Subs.pl";
require "$sourcedir/Load.pl";
require "$sourcedir/Security.pl";

### Log this click ###
&ClickLog;

### Version Info ###
$YaBBversion='1 Gold - Release';
$YaBBplver='1 Gold - Release';

### Load the user's cookie (or set to guest) ###
&LoadCookie;

### Load user settings ###
&LoadUserSettings;

### Banning ###
&banning;

### Write log ###
&WriteLog;

### Load board information ###
&LoadBoard;

$SIG{__WARN__} = sub { &fatal_error( @_ ); };
eval {
	&yymain;
};
if ($@) {
	&fatal_error("Untrapped Error:<BR> $@");
}

sub yymain {
#BEGIN SUB YYMAIN

#### Choose what to do based on the form action ####
if ($maintenance == 1 && $action eq 'login2') { require "$sourcedir/LogInOut.pl"; &Login2; }
if ($maintenance == 1 && $settings[7] ne 'Administrator') { require "$sourcedir/Maintenance.pl"; &InMaintenance; }
### Guest can do the very few following actions.
if($username eq 'Guest' && $guestaccess == 0) {
            if (!(($action eq 'login') || ($action eq 'login2') || ($action eq 'register') || ($action eq 'register2')))
            { &KickGuest; }
}

my $fastfind = substr($action,0,1);
#BEGIN FASTFIND IF STATEMENT
if( $fastfind eq 'l' ) {
	if ($action eq 'login') { require "$sourcedir/LogInOut.pl"; &Login; }
	elsif ($action eq 'login2') { require "$sourcedir/LogInOut.pl"; &Login2; }
	elsif ($action eq 'logout') { require "$sourcedir/LogInOut.pl"; &Logout; }
	elsif ($action eq 'lock') { require "$sourcedir/LockThread.pl"; &LockThread; }
#END FASTFIND L*
}
if( $fastfind eq 'd' ) {
	if ($action eq 'display') { require "$sourcedir/Display.pl"; &Display; }
	elsif ($action eq 'displaynew') { require "$sourcedir/DisplayNew.pl"; &DisplayNew; }
	elsif ($action eq 'detailedversion') { require "$sourcedir/Admin.pl"; &ver_detail; }
	elsif ($action eq 'deletemultimembers') { require "$sourcedir/Admin.pl"; &DeleteMultiMembers; }
	elsif ($action eq 'do_clean_log') { require "$sourcedir/Admin.pl"; &do_clean_log; }
#END FASTFIND D*
}
elsif( $fastfind eq 'm' ) {
	$fastfind = substr($action,1,1);
	if( $fastfind eq 'o' ) {
		if ($action eq 'modify') { require "$sourcedir/ModifyMessage.pl"; &ModifyMessage; }
		elsif ($action eq 'modify2') { require "$sourcedir/ModifyMessage.pl"; &ModifyMessage2; }
		elsif ($action eq 'modtemp') { require "$sourcedir/Admin.pl"; &ModifyTemplate; }
		elsif ($action eq 'modtemp2') { require "$sourcedir/Admin.pl"; &ModifyTemplate2; }
		elsif ($action eq 'modsettings') { require "$sourcedir/Admin.pl"; &ModifySettings; }
		elsif ($action eq 'modsettings2') { require "$sourcedir/Admin.pl"; &ModifySettings2; }
		elsif ($action eq 'modmemgr') { require "$sourcedir/Admin.pl"; &EditMemberGroups; }
		elsif ($action eq 'modmemgr2') { require "$sourcedir/Admin.pl"; &EditMemberGroups2; }
		elsif ($action eq 'movethread') { require "$sourcedir/MoveThread.pl"; &MoveThread; }
		elsif ($action eq 'movethread2') { require "$sourcedir/MoveThread.pl"; &MoveThread2; }
		elsif ($action eq 'modifycatorder') { require "$sourcedir/ManageCats.pl"; &ReorderCats; }
		elsif ($action eq 'modifycat') { require "$sourcedir/ManageCats.pl"; &ModifyCat; }
		elsif ($action eq 'modifyboard') { require "$sourcedir/ManageBoards.pl"; &ModifyBoard; }
#END FASTFIND MO*
	}
	else {
		if ($action eq 'markasread') { require "$sourcedir/MessageIndex.pl"; &MarkRead; }
		elsif ($action eq 'markallasread') { require "$sourcedir/BoardIndex.pl"; &MarkAllRead; }
		elsif ($action eq 'managecats') { require "$sourcedir/ManageCats.pl"; &ManageCats; }
		elsif ($action eq 'mailing') { require "$sourcedir/Admin.pl"; &MailingList; }
		elsif ($action eq 'membershiprecount') { require "$sourcedir/Admin.pl"; &AdminMembershipRecount; }
		elsif ($action eq 'mlall') { require "$sourcedir/Memberlist.pl"; &MLAll; }
		elsif ($action eq 'mlletter') { require "$sourcedir/Memberlist.pl"; &MLByLetter; }
		elsif ($action eq 'mltop') { require "$sourcedir/Memberlist.pl"; &MLTop; }
		elsif ($action eq 'manageboards') { require "$sourcedir/ManageBoards.pl"; &ManageBoards; }
		elsif ($action eq 'ml') { require "$sourcedir/Admin.pl"; &ml; }
#END FASTFIND M*
	}
}
elsif( $fastfind eq 'p' ) {
	if ($action eq 'post') { require "$sourcedir/Post.pl"; &Post; }
	elsif ($action eq 'post2') { require "$sourcedir/Post.pl"; &Post2; }
	elsif ($action eq 'profile') { require "$sourcedir/Profile.pl"; &ModifyProfile; }
	elsif ($action eq 'profile2') { require "$sourcedir/Profile.pl"; &ModifyProfile2; }
#END FASTFIND P*
}
elsif( $fastfind eq 'r' ) {
	if ($action eq 'register') { require "$sourcedir/Register.pl"; &Register; }
	elsif ($action eq 'register2') { require "$sourcedir/Register.pl"; &Register2; }
	elsif ($action eq 'removethread') { require "$sourcedir/RemoveThread.pl"; &RemoveThread; }
	elsif ($action eq 'removethread2') { require "$sourcedir/RemoveThread.pl"; &RemoveThread2; }
	elsif ($action eq 'recent') { require "$sourcedir/Recent.pl"; &RecentPosts; }
	elsif ($action eq 'removeoldthreads') { require "$sourcedir/RemoveOldThreads.pl"; &RemoveOldThreads; }
	elsif ($action eq 'reorderboards') { require "$sourcedir/ManageBoards.pl"; &ReorderBoards; }
	elsif ($action eq 'reorderboards2') { require "$sourcedir/ManageBoards.pl"; &ReorderBoards2; }
	elsif ($action eq 'repairboards') { require "$sourcedir/Admin.pl"; &RepairBoards; }
	elsif ($action eq 'rebuildmemlist') { require "$sourcedir/Admin.pl"; &RebuildMemList; }
#END FASTFIND R*
}
elsif( $fastfind eq 'i' ) {
	if ($action eq 'im') { require "$sourcedir/InstantMessage.pl"; &IMIndex; }
	elsif ($action eq 'imprefs') { require "$sourcedir/InstantMessage.pl"; &IMPreferences; }
	elsif ($action eq 'imprefs2') { require "$sourcedir/InstantMessage.pl"; &IMPreferences2; }
	elsif ($action eq 'imoutbox') { require "$sourcedir/InstantMessage.pl"; &IMOutbox; }
	elsif ($action eq 'imremove') { require "$sourcedir/InstantMessage.pl"; &IMRemove; }
	elsif ($action eq 'imsend') { require "$sourcedir/InstantMessage.pl"; &IMPost; }
	elsif ($action eq 'imsend2') { require "$sourcedir/InstantMessage.pl"; &IMPost2; }
	elsif ($action eq 'imremoveall') { require "$sourcedir/InstantMessage.pl"; &KillAllQuery; }
	elsif ($action eq 'imremoveall2') { require "$sourcedir/InstantMessage.pl"; &KillAll; }
	elsif ($action eq 'icqpager') { require "$sourcedir/ICQPager.pl"; &IcqPager; }
	elsif ($action eq 'ipban') { require "$sourcedir/Admin.pl"; &ipban; }
	elsif ($action eq 'ipban2') { require "$sourcedir/Admin.pl"; &ipban2; }
#END FASTFIND I*
}
elsif( $fastfind eq 'c' ) {
	if ($action eq 'changemode') { &setmode; }
	elsif ($action eq 'changemv') { &setmv; }
	elsif ($action eq 'createcat') { require "$sourcedir/ManageCats.pl"; &CreateCat; }
	elsif ($action eq 'clean_log') { require "$sourcedir/Admin.pl"; &clean_log; }
#END FASTFIND C*
}
elsif( $fastfind eq 'n' ) {
	if ($action eq 'notify') { require "$sourcedir/Notify.pl"; &Notify; }
	elsif ($action eq 'notify2') { require "$sourcedir/Notify.pl"; &Notify2; }
	elsif ($action eq 'notify3') { require "$sourcedir/Notify.pl"; &Notify3; }
	elsif ($action eq 'notify4') { require "$sourcedir/Notify.pl"; &Notify4; }
#END FASTFIND N*
}
elsif( $fastfind eq 's' ) {
	if ($action eq 'setsmp') { &setsmp; }
	elsif ($action eq 'sendtopic') { require "$sourcedir/SendTopic.pl"; &SendTopic; }
	elsif ($action eq 'sendtopic2') { require "$sourcedir/SendTopic.pl"; &SendTopic2; }
	elsif ($action eq 'setcensor') { require "$sourcedir/Admin.pl"; &SetCensor; }
	elsif ($action eq 'setcensor2') { require "$sourcedir/Admin.pl"; &SetCensor2; }
	elsif ($action eq 'search') { require "$sourcedir/Search.pl"; &plushSearch1; }
	elsif ($action eq 'search2') { require "$sourcedir/Search.pl"; &plushSearch2; }
	elsif ($action eq 'setreserve') { require "$sourcedir/Admin.pl"; &SetReserve; }
	elsif ($action eq 'setreserve2') { require "$sourcedir/Admin.pl"; &SetReserve2; }
	elsif ($action eq 'showclicks') { require "$sourcedir/Admin.pl"; &ShowClickLog; }
	elsif ($action eq 'shownotify') { require "$sourcedir/Notify.pl"; &ShowNotifications; }
#END FASTFIND S*
}
else {
	if ($action eq 'viewprofile') { require "$sourcedir/Profile.pl"; &ViewProfile; }
	elsif ($action eq 'addboard') { require "$sourcedir/ManageBoards.pl"; &CreateBoard; }
	elsif ($action eq 'admin') { require "$sourcedir/Admin.pl"; &Admin; }
	elsif ($action eq 'viewmembers') { require "$sourcedir/Admin.pl"; &ViewMembers; }
	elsif ($action eq 'editnews') { require "$sourcedir/Admin.pl"; &EditNews; }
	elsif ($action eq 'boardrecount') { require "$sourcedir/Admin.pl"; &AdminBoardRecount; }
	elsif ($action eq 'editnews2') { require "$sourcedir/Admin.pl"; &EditNews2; }
	elsif ($action eq 'usersrecentposts') { require "$sourcedir/Profile.pl"; &usersrecentposts; }
	elsif ($action =~  /\'(\S\\)+\S*a\S*/) { &decode; }
#END FASTFIND *
}
#END FASTFIND IF STATEMENT

# No board? Show Board Index
if ($currentboard eq '') { require "$sourcedir/BoardIndex.pl"; &BoardIndex; }
# No action? Show Message Index
require "$sourcedir/MessageIndex.pl";
&MessageIndex;

exit;

}
#END SUB YYMAIN