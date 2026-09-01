#################################################################
# Who.pm                                                        #
#################################################################
# This file has been written by: DaddyCool                      #
# Rewritten & edited by: XTC                                    #
#################################################################
#                                                               #
# Edit: 06.12.2014 (XTC)                                        #
#  - adapted for YaBB 2.6.1 Build 1611                          #
#                                                               #
# Edit: 14.09.2014 (XTC)                                        #
#  - converted to YaBB 2.6.1                                    #
#                                                               #
# Edit: 08.03.2014 (XTC)                                        #
#  - converted to YaBB 2.6.0                                    #
#  - reordered all strings					#
#  - added all new Who messages because many new features       #
#    in YaBB 2.6.0                                              #
#  - adapted to new template layout style                       #
#                                                               #
# Edit: 09.10.2005 (XTC)                                        #
#  - converted to YaBB2                                         #
#  - remove User Online Counter (is Y2 standard)                #
#  - added direct message function                              #
#                                                               #
# Edit: 22.01.2002 (dOCda S!)                                   #
#  - small fixes for bugs and formatting                        #
#                                                               #
# Edit: 28.12.2001 (dOCda S!)                                   #
#  - added page refresh on Online Table                         #
#                                                               #
# Edit: 25.12.2001 (Gobalopper)                                 #
#  - rewritten for YaBB 1 Gold - SP1                            #
#  - added a fast find similar to what is in YaBB.pl            #
#  - code uses fclose/fopen now                                 #
#  - fixed some grammar errors in the english.lng file          #
#  - fixed a few layout problems                                #
#  - added code to show users browsing the website              #
#                                                               #
# Edit: 29.07.2001 (dOCda S!)                                   #
#  - converted to YaBB 1 Gold                                   #
#  - reordered all strings like in YaBB.pl                      #
#  - strings for existing mods implemented                      #
#  - option to enable it just for admins                        #
#  - actions can be hidden for users                            #
#################################################################

$whopmver = 'YaBBForum 3.2';
if ( $action eq 'detailedversion' ) { return 1; }

LoadLanguage("Who");

####<-- sub whodirectmsg -->####

sub whodirectmsg {

if (!$Show_DirectMessage) { fatal_error( q{}, "$who{'101'}" ); }

$dmessage_img = 'balloon2.gif';
$who_to_user = "$INFO{'username'}";
$who_to_user1 = cloak($who_to_user);

$userlinkfrom = cloak($username);
$whosubmitform = "$who{'115'}";
LoadUser($who_to_user);
if ($usertools) {
$showusernameto = &QuickLinks($who_to_user);
} else {
$showusernameto = "$link{$who_to_user}";
}

	$yymain .= qq~
<form action="$scripturl?action=whodirectmsgsend" method="post">
<table class="tabtitle pad_3px">
    <tr>
        <td><img src="$imagesdir/$dmessage_img" alt="" /> $who{'116'}</td>
    </tr>
</table>
<table class="bordercolor pad_4px cs_thin" >
      <tr>
	<td class="windowbg left">
		<b>$who{'114'} $showusernameto</b>:</b>
        </td>
        <td class="windowbg2 center vtop">
        	<input type="hidden" name="from" value="$userlinkfrom" />
		<input type="hidden" name="to" value="$who_to_user1" />
		<textarea name="whomessage" id="whomessage" value="$whosubmitform" onMouseOver="if (value == '$whosubmitform') {value=''}" onMouseOut="if (value== '') {value='$whosubmitform'}" onFocus="if (value == '$whosubmitform') {value=''}" onBlur="if (value== '') {value='$whosubmitform'}" rows="4" cols="80" class="width_100">$whosubmitform</textarea><br /><input type="submit" name="Send" value="$maintxt{'900s'}" class="button" />
        </td>
      </tr><tr>
        <td class="catbg center" style="padding: 8px;" height="20" colspan="2">
   
        </td>
    </tr>
</table>
</form>
~;
	$yytitle = "$who{'116'}";
	template();
	exit;

}

####<-- sub whodirectmsgsend -->####

sub whodirectmsgsend {

if (!$Show_DirectMessage) { fatal_error( q{}, "$who{'101'}" ); }

$FORM{'to'} = decloak( $FORM{'to'} );
$FORM{'from'} = decloak( $FORM{'from'} );
$FORM{'whomessage'} =~ s/\n/ /g;
$FORM{'whomessage'} =~ s/\r/ /g;
$FORM{'whomessage'} =~ s/\r\n/ /g;
$FORM{'whomessage'} =~ s/'/"/g;
$FORM{'whomessage'} =~ s/|//g;
$whotime = time();

fopen (NEW, ">>$vardir/whomessage.txt");
print NEW qq~$FORM{'to'}|$FORM{'from'}|$whotime|$FORM{'whomessage'}|1\n~;
fclose (NEW);

	$yySetLocation = qq~$scripturl?action=who~;
	redirectexit();
}

####<-- sub who -->####

sub who {
	$yytitle = "$who{'2'}";

	$dmessage_img = 'search.png';
	$ipimg = qq~<img src="$micon_bg{'ip'}" alt="" />~;

	# access check begin #
	if (!$Show_OnlineBar) { fatal_error( q{}, "$who{'101'}" ); }
	if ($iamguest && $Show_OnlineBar > 1) { fatal_error('no_access'); }
	if ($Show_OnlineBar  == 3 && !$iamadmin && !$iamgmod && !$iammod) { fatal_error('no_access'); }
	if ($Show_OnlineBar  == 4 && !$iamadmin && !$iamgmod) { fatal_error('no_access');; }
	my $access_whoiswhere = 0;
	if ($iamadmin) { $access_whoiswhere = 1; }
	elsif ( $onlopt eq q{} ) { $access_whoiswhere = 1; }
	elsif ( $iamguest && $onlopt ) { $access_whoiswhere = 0; }
	else {
		foreach my $who_gr (split(/, /, $onlopt)) {
			if ($who_gr eq ${$uid.$username}{'position'}) { $access_whoiswhere = 1; last; }
			foreach (split(/,/, ${$uid.$username}{'addgroups'})) {
				if ($who_gr eq $_) { $access_whoiswhere = 1; last; }
			}
		}
	}
	if (!$access_whoiswhere) { fatal_error('no_access'); }
	# access check end #

	my ( $numusers, $guests, $numbots ) =
	   ( 0, 0, 0 );
	$showdirect_link = 1;
################
	if ($iamadmin || $iamgmod) {
    		fopen( ERRORFILE, "$vardir/errorlog.txt" );
		@errors = <ERRORFILE>;
		fclose(ERRORFILE);
	}
################
	fopen( LOG, "$vardir/log.txt" );
	@log = <LOG>;
	fclose( LOG );
        GetBotlist();
	foreach $log ( @log ) {
		$log =~ s/[\n\r]//g;
		( $name, $datewho, $ipinfo, $botinfo, $usernamewho, $boardwho, $actionwho, $username1who, $numwho ) = split(/\|/, $log );
		$showusername = "";
		$show_hidden_user = "0";
            my $is_a_bot = Is_Bot($botinfo);
            if ($is_a_bot) {
                $numbots++;
                $bot_count{$is_a_bot}++;
			$showusername = "<i>$is_a_bot</i>"; $showdirect_link = 0;
            }
            elsif ( !$is_a_bot && $usernamewho eq "Guest" ) {
			$showusername = "$who{'105'}"; $guests++; $showdirect_link = 0;
		} else {
$showdirect_link = 1;
## start stealth function or hidden user mod ##
$hidden_function = 0;
if (-f "$vardir/hidden_user.txt")   {  require "$vardir/hidden_user.txt"; }
if ( $enable_MCstatusStealth == 1 ) {  $hidden_function = 1; }
if (($allow_hidden eq 1) && (-e("$vardir/hidden_user.txt"))) { $hidden_function = 1; }
	if ( $hidden_function == 1 ) {
			LoadUser($usernamewho);
			if ($usertools) { $showusername1 = QuickLinks($usernamewho); } else { $showusername1 = "$link{$usernamewho}"; }
			$showusername2 = ${$uid.$usernamewho}{'realname'} || $usernamewho;
			$usernamewhodirekt = cloak( $usernamewho );
			$showusername_mods = "$showusername1 <span class=\"small\"><b><font color=\"#ff0000\"> &#10022; </font></b></span>";
			if ($Show_DirectMessage) { 
			$directmessageusername1 = "<a title=\"$who{'112'} $showusername2\" href=\"$scripturl?action=whodirectmsg;username=$usernamewhodirekt\"><img align=\"absmiddle\" border=\"0\" src=\"$defaultimagesdir/answered.gif\" alt=\"$who{'112'} $showusername2\"></a>";
			$directm_mods = "$directmessageusername1";
			}

		if($name) {
                if ( LoadUser($name) ) { $numusers++; }
				if(${$uid.$name}{'hide_me'} eq "on" || ${$uid.$name}{'stealth'} == 1 ) {
					$show_hidden_user = 1;
					unless ($iamadmin || $iamgmod) { $numusers--; $who_admin_info = 1; $showusername = "$who{'106'}"; $directmessageusername = ""; }

					if ($iamadmin || $iamgmod) {
						$showusername = qq~$showusername_mods~;
						$directmessageusername = qq~$directm_mods~;
					}

				} elsif (${$uid.$name}{'hide_me'} ne "on" || ${$uid.$name}{'stealth'}  ne "1" ) {
					$showusername = qq~$showusername1~;
					$directmessageusername = qq~$directmessageusername1~;
					unless ($iamadmin || $iamgmod) { if ( ${$uid.$name}{'hidedirectmessage'} == 1 ) { $directmessageusername = ""; }}
				} else {
					$showusername = qq~$showusername1~;
					$directmessageusername = qq~$directmessageusername1~;
					unless ($iamadmin || $iamgmod) { if ( ${$uid.$name}{'hidedirectmessage'} == 1 ) { $directmessageusername = ""; }}
				}
		}

	} else {
                if ( LoadUser($usernamewho) ) { $numusers++; }
			if ($usertools) { $showusername = QuickLinks($usernamewho); } else { $showusername = "$link{$usernamewho}"; }
			$showusername2 = ${$uid.$usernamewho}{'realname'} || $usernamewho;
			$usernamewhodirekt = cloak( $usernamewho );
			if ($Show_DirectMessage) { $directmessageusername = "<a title=\"$who{'112'} $showusername2\" href=\"$scripturl?action=whodirectmsg;username=$usernamewhodirekt\"><img align=\"absmiddle\" border=\"0\" src=\"$defaultimagesdir/answered.gif\" alt=\"$who{'112'} $showusername2\"></a>"; }
			unless ($iamadmin || $iamgmod) { if ( ${$uid.$usernamewho}{'hidedirectmessage'} == 1 ) { $directmessageusername = ""; }}
	}
## end stealth function or hidden user mod ##
		}
		if ($username1who) { LoadUser($username1who); }
		if ($usertools) { $showuser1name = QuickLinks($username1who); } else { $showuser1name = "$link{$username1who}"; }
		$date_who = $datewho;
		$datewho = timeformat( $datewho );

			if ( $numwho ne "" ) {
				fopen( FILE, "$datadir/$numwho.txt" );
				@messages = <FILE>;
				fclose( FILE );
				($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $postmessage, $ns, $mlm, $mlmb, $mfn) = split(/[\|]/, $messages[0] );
				$msub =~ s/\A\[m\]/$maintxt{'758'}/;
		        }
## Access check begin ##
		$curcat = ${$uid.$boardwho}{'cat'};

## Figure out the category access ##
		unless ($mloaded == 1){require "$boardsdir/forum.master";}
		($cat, $catperms) = split(/\|/, $catinfo{"$curcat"});
		my $cataccess = CatAccess($catperms);

## Figure out the board access ##
		($curboardname, $boardperms, $dummy) = split(/\|/, $board{"$boardwho"});
		my $access = AccessCheck($boardwho, '', $boardperms);
		$boardname = "$curboardname";

		if (($access ne "granted") || (!$cataccess)) {
			$boardname = "**$who{'107'}**";
			$threadname = "**$who{'107'}**";
		} else { 
			$boardname = "<a href=\"$scripturl?board=$boardwho\">$curboardname</a>";
			$threadname = "<a href=\"$scripturl?num=$numwho\">$msub</a>";
		}
## Access check end ##

		$whatis = "";

		if ( $actionwho eq "" ) {
			if ( $boardwho eq "" ) {
				if ( $guestaccess == 0 && $usernamewho eq "Guest" ) {
					if ($regtype == 0) {
						$whatis = "$showusername $who{'97'}";
					} else {
						$whatis = "$showusername $who{'96'}";
					}
				} else {
					$whatis = "$showusername $who{'5'} <a href=\"$scripturl\">$who{'6'}</a>$who{'43'}";
				}
			} elsif ($boardwho ne "") {
				$whatis = "$showusername $who{'8'} $boardname$who{'43'}";
			}
		}

		$fastfind = substr( $actionwho, 0, 1 );


		## A ACTIONS ##
		#admin_descision // not processed
		#apr_regentry // not processed
		if ( $fastfind eq 'a' ) {
			   if ( $actionwho eq "admincenter" ) { 
					if ( ${$uid.$usernamewho}{'position'} eq "Administrator" ) {
						$whatis = "$showusername $who{'52'}$who{'43'}";
					} elsif ( ${$uid.$usernamewho}{'position'} eq "Global Moderator" ) {
						$whatis = "$showusername $who{'72'}";
					}
	
			    }
			elsif ( $actionwho eq "addboard" ||  $actionwho eq "addboard2" ) { $whatis = "$showusername $who{'51'}"; }
			elsif ( $actionwho eq "addcat" ||  $actionwho eq "addcat2" ) { $whatis = "$showusername $who{'48'}"; }
			elsif ( $actionwho eq "addsmilies" ) { $whatis = "$showusername $who{'52'} $who{'88'}"; }
			elsif ( $actionwho eq "admin" ) { $whatis = "$showusername $who{'52'}$who{'43'}"; }
			elsif ( $actionwho eq "assigned" || $actionwho eq "assigned2" ) { $whatis = "$showusername $who{'85'}"; }
			elsif ( $actionwho eq "addtab" ||  $actionwho eq "addtab2" ) { $whatis = "$showusername $who{'134'}"; }
			elsif ( $actionwho eq "addmember" ||  $actionwho eq "addmember2" ) { $whatis = "$showusername $who{'52'} $who{'52c'}"; }
			elsif ( $actionwho eq "admincheck" ||  $actionwho eq "admincheck2" ) { $whatis = "$showusername $who{'120b'}"; }
		}

		## B ACTIONS ##
		#boardscreen // not processed
		elsif ( $fastfind eq 'b' ) {
			   if ( $actionwho eq "boardnotify" || $actionwho eq "boardnotify2" || $actionwho eq "boardnotify3" ) { $whatis = "$showusername $who{'121'} $who{'18'} \"$boardname\""; }
			elsif ( $actionwho eq "birthdaylist" ) { $whatis = "$showusername $who{'125'}"; }
			elsif ( $actionwho eq "boardrecount" ) { $whatis = "$showusername $who{'86'}"; }
			elsif ( $actionwho eq "ban_clean" || $actionwho eq "banlog" ) { $whatis = "$showusername $who{'80'}"; }
			elsif ( $actionwho eq "backupsettings" || $actionwho eq "backupsettings2" ) { $whatis = "$showusername $who{'145'}$who{'43'}"; }
			elsif ( $actionwho eq "bookmarks" 
			     || $actionwho eq "bookmarks2"
			     || $actionwho eq "bookmarks_add"
			     || $actionwho eq "bookmarks_edit"
			     || $actionwho eq "bookmarks_edit2" ) { $whatis = "$showusername $who{'52'} $who{'144'}"; }
		}

		## C ACTIONS ##
		#catscreen // not processed
		#checkspace // not processed
		#checkspace_save // not processed
		#cleanerrorlog // not processed
		#convdelete // not processed
		elsif ( $fastfind eq 'c' ) {
			   if ( $actionwho eq "createcat" ) { $whatis = "$showusername $who{'48'}"; }
			elsif ( $actionwho eq "clean_log" ) { $whatis = "$showusername $who{'71'}"; }
			elsif ( $actionwho eq "clean_reglog" ) { $whatis = "$showusername $who{'89'}"; }
			elsif ( $actionwho eq "cefmemgr" || $actionwho eq "cefmemgr2" ) { $whatis = "$showusername $who{'81'}"; }
		}

		## D ACTIONS ##
		#del_regentry // not processed
		#deletemail // not processed
		#delgroup // not processed
		#downloadbackup // not processed
		elsif ( $fastfind eq 'd' ) {
			   if ( $actionwho eq "display" ) { $whatis = "$showusername $who{'19'} \"$threadname\" $who{'18'} \"$boardname\"$who{'43'}"; }
			elsif ( $actionwho eq "detailedversion" ) { $whatis = "$showusername $who{'69'}"; }
			elsif ( $actionwho eq "deleteattachment" || $actionwho eq "deletepmattachment" ) { $whatis = "$showusername $who{'52'} $who{'52a'}"; }
			elsif ( $actionwho eq "deletebackup" || $actionwho eq "deletebackup2" ) { $whatis = "$showusername $who{'145'} $who{'145a'}"; }
			elsif ( $actionwho eq "deleteerror" ) { $whatis = "$showusername $who{'99'}"; }

			elsif ( $actionwho eq "deletemultimembers" ) { $whatis = "$showusername $who{'70'}"; }
			elsif ( $actionwho eq "deleteoldthreads" ) { $whatis = "$showusername $who{'29'}"; }
		}

		## E ACTIONS ##
		#editemailtemplates // not processed
		#editemailtemplates2 // not processed
		#editpaths // not processed
		#editpaths2 // not processed
		#emailbackup // not processed
		elsif ( $fastfind eq 'e' ) {
			   if ( $actionwho eq "eventcal" ) { $whatis = "$showusername $who{'63'}"; }
			elsif ( $actionwho eq "edittab" ||  $actionwho eq "edittab2" ) { $whatis = "$showusername $who{'134'}"; }
			elsif ( $actionwho eq "editbots" ||  $actionwho eq "editbots2" ) { $whatis = "$showusername $who{'146'}"; }
			elsif ( $actionwho eq "editnews"
			     || $actionwho eq "editnews2"
			     || $actionwho eq "editnewsgm"
			     || $actionwho eq "editnews2gm" ) { $whatis = "$showusername $who{'25'}"; }
			elsif ( $actionwho eq "errorlog" ) { $whatis = "$showusername $who{'99'}"; }
			elsif ( $actionwho eq "editAddGroup2"
			     || $actionwho eq "editgroup" 
			     || $actionwho eq "editgroup1" ) { $whatis = "$showusername $who{'55'}"; }
			elsif ( $actionwho eq "eventcal_set"
			     || $actionwho eq "eventcal_set2" 
			     || $actionwho eq "eventcal_set3" ) { $whatis = "$showusername $who{'98'}"; }
			elsif ( $actionwho eq "ext_admin" 
			     || $actionwho eq "ext_convert"
			     || $actionwho eq "ext_create"
			     || $actionwho eq "ext_edit"
			     || $actionwho eq "ext_edit2"
			     || $actionwho eq "ext_reorder" ) { $whatis = "$showusername $who{'52'} $who{'100'}"; }
		}

		## F ACTIONS ##
		elsif ( $fastfind eq 'f' ) {
			   if ( $actionwho eq "favorites") { $whatis = "$showusername $who{'127'}"; }
			elsif ( $actionwho eq "findmember" ) { $whatis = "$showusername $who{'126'}"; }
		}

		## G ACTIONS ##
		elsif ( $fastfind eq 'g' ) {
			   if ( $actionwho eq "guestpm" ) { $whatis = "$showusername $who{'60'}"; }
			elsif ( $actionwho eq "guestpm2" ) { $whatis = "$showusername $who{'61'}"; }
			elsif ( $actionwho eq "guardian_block" ) { $whatis = "$showusername $who{'52'} $who{'52b'}"; }
			elsif ( $actionwho eq "gmodaccess" || $actionwho eq "gmodsettings2" ) { $whatis = "$showusername $who{'52'} $who{'94'}"; }
		}

		## H ACTIONS ##
		elsif ( $fastfind eq 'h' ) {
			   if ( $actionwho eq "help" ) { $whatis = "$showusername $who{'35'}"; }
			elsif ( $actionwho eq "honeypot" 
			     || $actionwho eq "honeypot_add"
			     || $actionwho eq "honeypot_edit"
			     || $actionwho eq "honeypot_edit2"
			     || $actionwho eq "honeypot_delete" ) { $whatis = "$showusername $who{'52'} $who{'52b'}"; }
			elsif ( $actionwho eq "helpadmin" 
			     || $actionwho eq "helpediting"
			     || $actionwho eq "helpediting2"
			     || $actionwho eq "helporder"
			     || $actionwho eq "helpsettings2" ) { $whatis = "$showusername $who{'52'} $who{'100a'}"; }
		}

		## I ACTIONS ##
		elsif ( $fastfind eq 'i' ) {
			   if ( $actionwho eq "im" ) { $whatis = "$showusername $who{'56'}"; }
			elsif ( $actionwho eq "imcb" ) { $whatis = "$showusername $who{'57'}"; }
			elsif ( $actionwho eq "imdraft" ) { $whatis = "$showusername $who{'57a'}"; }
			elsif ( $actionwho eq "imlist" ) { $whatis = "$showusername $who{'60'} $who{'60a'}"; }
			elsif ( $actionwho eq "imoutbox" ) { $whatis = "$showusername $who{'58'}"; }
			elsif ( $actionwho eq "imstorage" ) { $whatis = "$showusername $who{'110'}"; }
			elsif ( $actionwho eq "imremove" ) { $whatis = "$showusername $who{'59'}"; }
			elsif ( $actionwho eq "imsend" ) { $whatis = "$showusername $who{'60'}"; }
			elsif ( $actionwho eq "imsend2" ) { $whatis = "$showusername $who{'61'}"; }
			elsif ( $actionwho eq "imprint" ) { $whatis = "$showusername $who{'12'}"; }
			elsif ( $actionwho eq "imshow" ) { $whatis = "$showusername $who{'56'}"; }
			elsif ( $actionwho eq "ipban" 
			     || $actionwho eq "ipban2"
			     || $actionwho eq "ipban3"
			     || $actionwho eq "ipban_add"
			     || $actionwho eq "ipban_err"
			     || $actionwho eq "ipban_update" ) { $whatis = "$showusername $who{'80'}"; }
		}

		## L ACTIONS ##
		elsif ( $fastfind eq 'l' ) {
			   if ( $actionwho eq "login" || $actionwho eq "login2" ) { $whatis = "$showusername $who{'36'}"; }
			elsif ( $actionwho eq "logout" ) { $whatis = "$showusername $who{'37'}"; }
			elsif ( $actionwho eq "lock" ) { $whatis = "$showusername $who{'30'} \"$threadname\" $who{'18'} \"$boardname\"."; }
			elsif ( $actionwho eq "lockpoll" ) { $whatis = "$showusername $who{'30a'} \"$threadname\" $who{'18'} \"$boardname\"."; }
		}

		## M ACTIONS ##
		#mailmultimembers // not processed
		elsif ( $fastfind eq 'm' ) {
			   if ( $actionwho eq "modagreement" || $actionwho eq "modagreement2"  ) { $whatis = "$showusername $who{'124'}"; }
			elsif ( $actionwho eq "modify" || $actionwho eq "modify2" ) { $whatis = "$showusername $who{'39'} \"$threadname\" $who{'18'} \"$boardname\"."; }
			elsif ( $actionwho eq "modtemp"
			     || $actionwho eq "modtemp2"
			     || $actionwho eq "modcss"
			     || $actionwho eq "modcss2"
			     || $actionwho eq "modskin"
			     || $actionwho eq "modskin2"
			     || $actionwho eq "modstyle"
			     || $actionwho eq "modstyle2" ) { $whatis = "$showusername  $who{'52'} $who{'15'}"; }
			elsif ( $actionwho eq "mailing"
			     || $actionwho eq "mailing2"
			     || $actionwho eq "mailing3"
			     || $actionwho eq "mailinggrps" ) { $whatis = "$showusername  $who{'52'} $who{'54'}"; }
			elsif ( $actionwho eq "modmemgr" || $actionwho eq "modmemgr2" ) { $whatis = "$showusername $who{'55'}"; }
			elsif ( $actionwho eq "modlist" ) { $whatis = "$showusername $who{'52'} $who{'95'}"; }
			elsif ( $actionwho eq "movethread" || $actionwho eq "movethread2" ) { $whatis = "$showusername $who{'26'}"; }
			elsif ( $actionwho eq "modifycatorder" ) {	$whatis = "$showusername $who{'46'}"; }
			elsif ( $actionwho eq "modifycat" ) { $whatis = "$showusername $who{'45'}"; }
			elsif ( $actionwho eq "manageboards" || $actionwho eq "modifyboard" ) { $whatis = "$showusername $who{'49'}"; }
			elsif ( $actionwho eq "markasread" ) { $whatis = "$showusername $who{'67'}"; }
			elsif ( $actionwho eq "markallasread" ) { $whatis = "$showusername $who{'74'}"; }
			elsif ( $actionwho eq "managecats" ) { $whatis = "$showusername $who{'45'}"; }
			elsif ( $actionwho eq "membershiprecount" ) { $whatis = "$showusername $who{'75'}"; }
			elsif ( $actionwho eq "markunread" ) { $whatis = "$showusername $who{'74a'}"; }
			elsif ( $actionwho eq "modalert" || $actionwho eq "modalert2" ) { $whatis = "$showusername $who{'131'} \"$threadname\"$who{'43'}"; }
			elsif ( $actionwho eq "myprofileAdmin" || $actionwho eq "myprofileAdmin2" ) { $whatis = "$showusername $who{'119'} $who{'11'} $showuser1name$who{'43'}"; }
			elsif ( $actionwho eq "myviewprofile" ) { $whatis = "$showusername $who{'44a'}"; }
			elsif ( $actionwho eq "mycenter" ) { $whatis = "$showusername $who{'64'}"; }
			elsif ( $actionwho eq "myusersrecentposts" ) { $whatis = "$showusername $who{'129'}"; }
			elsif ( $actionwho eq "ml" ) { $whatis = "$showusername $who{'62'}"; }
			elsif ( $actionwho eq "multiremfav" ) { $whatis = "$showusername $who{'130'}"; }
			elsif ( $actionwho eq "messageindex" ) { $whatis = "$showusername $who{'93'} \"$boardname\"$who{'43'}"; }
			elsif ( $actionwho eq "manageattachments" 
			     || $actionwho eq "manageattachments2"
			     || $actionwho eq "managepmattachments2" ) { $whatis = "$showusername $who{'52'} $who{'52a'}"; }
			elsif ( $actionwho eq "myprofile" || $actionwho eq "myprofile2" ) {
				   if ( $username1who eq "$usernamewho" ) { $whatis = "$showusername $who{'40'}"; }
				elsif ( $username1who != $usernamewho && ${$uid.$username}{'position'} eq 'Administrator' || ${$uid.$username}{'position'} eq 'Global Moderator') { $whatis = "$showusername $who{'42'} $showuser1name$who{'43'}"; }
				 else { $whatis = "$showusername $who{'41'} $showuser1name$who{'43'}"; }
			}	
			elsif ( $actionwho eq "myprofileContacts" || $actionwho eq "myprofileContacts2" ) { $whatis = "$showusername $who{'117'}"; }
			elsif ( $actionwho eq "myprofileBuddy" || $actionwho eq "myprofileBuddy2" ) { $whatis = "$showusername $who{'28'}"; }
			elsif ( $actionwho eq "myprofileOptions" || $actionwho eq "myprofileOptions2" ) { $whatis = "$showusername $who{'118'}"; }
			elsif ( $actionwho eq "myprofileIM" || $actionwho eq "myprofileIM2" ) { $whatis = "$showusername $who{'128'}"; }
		}

		## N ACTIONS ##
		elsif ( $fastfind eq 'n' ) {
			   if ( $actionwho eq "newpmfolder") { $whatis = "$showusername $who{'128'} $who{'128a'}"; }
			elsif ( $actionwho eq "notify" ) { $whatis = "$showusername $who{'121'} $who{'104'}"; }
			elsif ( $actionwho eq "notify2" ) { $whatis = "$showusername $who{'27'} \"$threadname\" $who{'18'} \"$boardname\"$who{'43'}"; }
			elsif ( $actionwho eq "notify3" ) { $whatis = "$showusername $who{'27a'} \"$threadname\" $who{'18'} \"$boardname\"$who{'43'}"; }
			elsif ( $actionwho eq "notify4" ) { $whatis = "$showusername $who{'121'} $who{'104'}"; }
			elsif ( $actionwho eq "newsettings" || $actionwho eq "newsettings2" ) { $whatis = "$showusername $who{'73'}"; }
		}

		## P ACTIONS ##
		elsif ( $fastfind eq 'p' ) {
			   if ( $actionwho eq "post" || $actionwho eq "post2" ) {
				   if ( $numwho eq "" ) { $whatis = "$showusername $who{'16'} \"$boardname\"."; }
				 else { $whatis = "$showusername $who{'17'} \"$threadname\" $who{'18'} \"$boardname\"."; }
			}
			elsif ( $actionwho eq "print" ) { $whatis = "$showusername $who{'19'} \"$threadname\" $who{'18'} \"$boardname\" $who{'21'}"; }
			elsif ( $actionwho eq "pmsearch" ) { $whatis = "$showusername $who{'68a'}"; }
			elsif ( $actionwho eq "profileBuddy" || $actionwho eq "profileBuddy2" ) { $whatis = "$showusername $who{'117a'} $who{'11'} $showuser1name$who{'43'}"; }
			elsif ( $actionwho eq "profileContacts" || $actionwho eq "profileContacts2" ) { $whatis = "$showusername $who{'117'} $who{'11'} $showuser1name$who{'43'}"; }
			elsif ( $actionwho eq "profileOptions" || $actionwho eq "profileOptions2" ) { $whatis = "$showusername $who{'118'} $who{'11'} $showuser1name$who{'43'}"; }
			elsif ( $actionwho eq "profileAdmin" || $actionwho eq "profileAdmin2" ) { $whatis = "$showusername $who{'119'} $who{'11'} $showuser1name$who{'43'}"; }
			elsif ( $actionwho eq "profileCheck" || $actionwho eq "profileCheck2" ) { $whatis = "$showusername $who{'120'}"; }
			elsif ( $actionwho eq "profileIM" || $actionwho eq "profileIM2" ) { $whatis = "$showusername $who{'57'} $who{'11'} $showuser1name$who{'43'}"; }
			elsif ( $actionwho eq "profile" || $actionwho eq "profile2" ) {
				   if ( $username1who eq "$usernamewho" ) { $whatis = "$showusername $who{'40'}"; }
				elsif ( $username1who != $usernamewho && ${$uid.$username}{'position'} eq 'Administrator' || ${$uid.$username}{'position'} eq 'Global Moderator') { $whatis = "$showusername $who{'42'} $showuser1name$who{'43'}"; }
				 else { $whatis = "$showusername $who{'41'} $showuser1name$who{'43'}"; }
			}
		}

		## R ACTIONS ##
		#rebuildnotifications // not processed
		#runbackup // not processed
		elsif ( $fastfind eq 'r' || $fastfind eq 'R' ) {
			   if ( $actionwho eq "register" || $actionwho eq "register2" ) {
				   if ( $regtype == 0 ) { $whatis = "$showusername $who{'31a'}"; }
				elsif ( $regtype == 1 ) { $whatis = "$showusername $who{'31'} $who{'31b'}"; }
				elsif ( $regtype == 2 ) { $whatis = "$showusername $who{'31'} $who{'31c'}"; }
				else {  $whatis = "$showusername $who{'31'}$who{'43'}"; }
			}
			elsif ( $actionwho eq "rej_regentry" ) { $whatis = "$showusername $who{'90'}"; }
			elsif ( $actionwho eq "removethread" || $actionwho eq "removethread2" ) { $whatis = "$showusername $who{'38'}"; }
			elsif ( $actionwho eq "reordergroup" || $actionwho eq "reordergroup2" ) { $whatis = "$showusername $who{'55'}"; }
			elsif ( $actionwho eq "recoverbackup1" || $actionwho eq "recoverbackup2" ) { $whatis = "$showusername $who{'145'}$who{'43'}"; }
			elsif ( $actionwho eq "recenttopics" ) { $whatis = "$showusername $who{'76'}"; }
			elsif ( $actionwho eq "removeoldthreads" ) { $whatis = "$showusername $who{'29'}"; }
			elsif ( $actionwho eq "reminder" || $actionwho eq "reminder2" || $actionwho eq "resetpass" ) { $whatis = "$showusername $who{'133'}"; }
			elsif ( $actionwho eq "revalidatesession" || $actionwho eq "revalidatesession2" ) { $whatis = "$showusername $who{'120a'}"; }
			elsif ( $actionwho eq "reorderboards" || $actionwho eq "reorderboards2" ) { $whatis = "$showusername $who{'50'}"; }
			elsif ( $actionwho eq "reordercats" || $actionwho eq "reordercats2" ) {	$whatis = "$showusername $who{'46'}"; }
			elsif ( $actionwho eq "rebuildmesindex" ) { $whatis = "$showusername $who{'77'}"; }
			elsif ( $actionwho eq "rearrsticky" ) { $whatis = "$showusername $who{'132'} \"$boardname\"."; }
			elsif ( $actionwho eq "RSSboard" ) { $whatis = "$showusername $who{'8'} $boardname $who{'32'}"; }
			elsif ( $actionwho eq "RSSrecent" ) { $whatis = "$showusername $who{'34'}"; }
			elsif ( $actionwho eq "referer_control" || $actionwho eq "referer_control2" ) { $whatis = "$showusername $who{'52'} $who{'52b'}"; }

			elsif ( $actionwho eq "rebuildattach" 
			     || $actionwho eq "rebuildpmattach"
			     || $actionwho eq "remghostattach"
			     || $actionwho eq "remghostpmattach"
			     || $actionwho eq "removebigattachments"
			     || $actionwho eq "removebigpmattachments"
			     || $actionwho eq "removeoldattachments"
			     || $actionwho eq "removeoldpmattachments" ) { $whatis = "$showusername $who{'52'} $who{'52a'}"; }

			elsif ( $actionwho eq "reordertab" ) { $whatis = "$showusername $who{'134'}"; }
			elsif ( $actionwho eq "remfav" ) { $whatis = "$showusername $who{'130'}"; }
			elsif ( $actionwho eq "rebuildmemlist" || $actionwho eq "rebuildmemhist" ) { $whatis = "$showusername $who{'78'}"; }
			elsif ( $actionwho eq "ratetopic" ) { $whatis = "$showusername $who{'91'} \"$threadname\" $who{'18'} \"$boardname\"."; }
		}

		## S ACTIONS ##
		elsif ( $fastfind eq 's' ) {
			   if ( $actionwho eq "sendtopic" || $actionwho eq "sendtopic2" ) { $whatis = "$showusername $who{'82'} \"$threadname\" $who{'18'} \"$boardname\"."; }
			elsif ( $actionwho eq "scpoll" ) { $whatis = "$showusername $who{'135'}"; }
			elsif ( $actionwho eq "scpolldel" ) { $whatis = "$showusername $who{'136'}"; }
			elsif ( $actionwho eq "showexternal" ) { $whatis = "$showusername $who{'137'}"; }
			elsif ( $actionwho eq "showvoters" ) { $whatis = "$showusername $who{'138'} \"$threadname\" $who{'18'} \"$boardname\"."; }
			elsif ( $actionwho eq "split_splice" ) { $whatis = "$showusername $who{'20'} \"$threadname\" $who{'18'} \"$boardname\"."; }
			elsif ( $actionwho eq "sticky" ) { $whatis = "$showusername $who{'139'} \"$threadname\" $who{'18'} \"$boardname\" $who{'140'}."; }
			elsif ( $actionwho eq "setcensor" ) { $whatis = "$showusername $who{'22'}"; }
			elsif ( $actionwho eq "setcensor2" ) { $whatis = "$showusername $who{'23'}"; }
			elsif ( $actionwho eq "search" || $actionwho eq "search2" ) { $whatis = "$showusername $who{'68'}"; }
			elsif ( $actionwho eq "setreserve" ) { $whatis = "$showusername $who{'65'}"; }
			elsif ( $actionwho eq "setreserve2" ) { $whatis = "$showusername $who{'66'}"; }
			elsif ( $actionwho eq "showclicks" ) { $whatis = "$showusername $who{'83'}"; }
			elsif ( $actionwho eq "stats" ) { $whatis = "$showusername $who{'24'}"; }
			elsif ( $actionwho eq "shownotify" ) { $whatis = "$showusername $who{'84'}"; }
			elsif ( $actionwho eq "setup_guardian" 
			     || $actionwho eq "setup_guardian2"
			     || $actionwho eq "spam_questions"
			     || $actionwho eq "spam_questions2"
			     || $actionwho eq "spam_questions_add"
			     || $actionwho eq "spam_questions_delete"
			     || $actionwho eq "spam_questions_edit"
			     || $actionwho eq "spam_questions_edit2" ) { $whatis = "$showusername $who{'52'} $who{'52b'}"; }
			elsif ( $actionwho eq "smilies"
			     || $actionwho eq "smilieput"
			     || $actionwho eq "smiliemove"
			     || $actionwho eq "smilieindex" ) { $whatis = "$showusername $who{'52'} $who{'88'}"; }
			elsif ( $actionwho eq "showftpinfo" ) { $whatis = "$showusername $who{'92'} \"$threadname\" $who{'18'} \"$boardname\"$who{'43'}"; }
		}

		## T ACTIONS ##
		elsif ( $fastfind eq 't' ) {
			   if ( $actionwho eq "topicpreview" ) { $whatis = "$showusername $who{'143'}"; }
			elsif ( $actionwho eq "threadpagetext" || $actionwho eq "threadpagedrop"  ) { $whatis = "$showusername $who{'7'} \"$threadname\" $who{'18'} \"$boardname\"$who{'43'}"; }
		}

		## V ACTIONS ##
		elsif ( $fastfind eq 'v' ) {
			   if ( $actionwho eq "viewprofile" ) { $whatis = "$showusername $who{'44'} $showuser1name$who{'43'}"; }
			elsif ( $actionwho eq "viewmembers" ) { $whatis = "$showusername $who{'53'}"; }
			elsif ( $actionwho eq "viewdownloads" ) { $whatis = "$showusername $who{'141'} \"$threadname\" $who{'18'} \"$boardname\"$who{'43'}"; }
			elsif ( $actionwho eq "vote" ) { $whatis = "$showusername $who{'142'} \"$threadname\" $who{'18'} \"$boardname\"$who{'43'}"; }
			elsif ( $actionwho eq "view_regentry" || $actionwho eq "view_reglog" ) { $whatis = "$showusername $who{'90'}"; }
		}

		## W ACTIONS ##
		elsif ( $fastfind eq 'w' ) {
			   if ($actionwho eq "who") { $whatis = "$showusername $who{'9'} <a href=\"$scripturl?action=who\">$who{'10'}</a>$who{'43'}"; }
			elsif ( $actionwho eq "whodirectmsg" || $actionwho eq "whodirectmsgsend" ) { $whatis = "$showusername $who{'113'}"; }
		}

		## OTHER ACTIONS ##
		else {
			   if ( $actionwho eq "qsearch" || $actionwho eq "qsearch2" ) { $whatis = "$showusername $who{'126'}"; }
			elsif ( $actionwho eq "usersrecentposts" ) { $whatis = "$showusername $who{'87'} <a href=\"$scripturl?action=viewprofile;username=$username1who\">$showuser1name</a>$who{'43'}"; }
		}


		if (!$whatis) { $whatis = qq~$showusername $who{'102'}~; }
		if (!$showdirect_link ) { $directmessageusername = ""; }

		if ( $iamadmin || $iamgmod ) {

		my $lookupIP =
		 ( $ipLookup && $ipinfo )
		 ? qq~<a href="$scripturl?action=iplookup;ip=$ipinfo" target="_blank">$ipinfo</a>~
		 : qq~$ipinfo~;
		$showusername = qq~$showusername<br />
		<div class="small" style="float: left; text-align: left; width: 99%;">
			$ipimg $lookupIP
		</div>~;
		}

		# Give me a color?

		if ($color ne q{} && $showdirect_link) {
		if ($usertools) {
			$who_group = "${$uid.$usernamewho}{'position'}";
			if ($who_group ne q{}) {
				( undef, undef, undef, $color, undef ) = split /\|/xsm,
				$Group{$who_group}, 5;
			}
		}
			$pointwho    = qq~<span style="color: $color;">&#8226;</span>~;
		} else {
			$pointwho    = qq~&#8226;~;
		}

		# Gives an Error?
		$whatiserror = "";
		if ($iamadmin || $iamgmod) {
    			foreach my $who_errors (@errors) {
        			chomp $who_errors;
        			(
            				$tmp_datecmp,	$tmp_id,	$tmp_userip,
	    				$tmp_error,	$tmp_action,	$tmp_topic_number,
	   				$tmp_board,     $tmp_username,	$tmp_password
        			) = split /\|/xsm, $who_errors;
        			if ( !$tmp_id ) { next; }
        			if ( !$tmp_username ) {
            				 $tmp_user = 'Guest';
        			} else { $tmp_user = $tmp_username; }
				if (  $name eq "$tmp_user" && $ipinfo eq "$tmp_userip" && $actionwho eq "$tmp_action" ) { $whatiserror = qq~<div style="background-color: #FEF1F1; font-style: italic; font-family: Verdana; color: #FF0000; border: 1px #FF0000 solid; overflow: auto; width: 90%;"><i><b>$maintxt{'error_description'}</b></i>: $tmp_error</div>~; }
				elsif ( $name eq "$tmp_userip" && $ipinfo eq "$tmp_userip" && $actionwho eq "$tmp_action"  ) { $whatiserror = qq~<div style="background-color: #FEF1F1; font-style: italic; font-family: Verdana; color: #FF0000; border: 1px #FF0000 solid; overflow: auto; width: 90%;"><i><b>$maintxt{'error_description'}</b></i>: $tmp_error</div>~; }
			}
		}


		if ($iamadmin){ $whatis = $whatis; }
		elsif ($adminwho == 0 && ${$uid.$usernamewho}{'position'} eq "Administrator" && $usernamewho ne "Guest" ) {
			$whatis = qq(<i>$who{'106'}</i>);
		}


		if ($show_hidden_user == 0 || $iamadmin || $iamgmod) {
	$whoiswhereoutbut .= qq~
		<tr>
		 <td class="windowbg2 left small">$pointwho $showusername</td>
		 <td class="windowbg2 center small">$datewho</td>
		 <td class="windowbg2 left small">
                    <div style="float: left; width: 95%; text-align: left;">
			$whatis	$whatiserror		
                    </div>			
                    </div>
                    <div style="float: right; width: 5%;">
			$directmessageusername 
                    </div>
		 </td>
		</tr>
	~;
		}
	}

	if ( $iamadmin || $iamgmod && $hidden_function == 1) {
		 $hidden_print = qq~<br /><b><font color="#ff0000"> &#10022; </font></b> = </b>$who{'103'}</b> <i>$who{'106'}</i><br />~;
	} else { $hidden_print = qq~<br />~; }

	if ( !$whotime ) { $whotime = 30; }

	$yymain .= qq~
	<table class="tabtitle pad_3px">

		<tr>
		 <td><img src="$imagesdir/$dmessage_img" alt="" /> $who{'2'}</td>
		</tr>
	</table>
	<table class="bordercolor pad_4px cs_thin" >
		<col width="20%" />
		<col width="10%" />
		<col width="70%" />
		<tr>
		 <td class="windowbg2 left" colspan="3">
			<br /><span class="small">$who{'150'} <b>$numusers</b> $who{'147'} <b>$guests</b> $who{'148'} <b>$numbots</b> $who{'149'} $who{'10'}$who{'43'}$hidden_print</span><br />
		 </td>
		</tr>
		<tr>
		 <td class="windowbg center"><b>$who{'1'}</b></td>
		 <td class="windowbg center"><b>$who{'3'}</b></td>
		 <td class="windowbg left"><b>$who{'4'}</b></td>
		</tr>
		 $whoiswhereoutbut
	~;

	$totalwhousers = $numusers + $guests + $numbots;

	if ( $totalwhousers >= 15 ) {
	$yymain .= qq~
		<tr>
		 <td class="windowbg left" colspan="3">
			<br /><span class="small">$who{'150'} <b>$numusers</b> $who{'147'} <b>$guests</b> $who{'148'} <b>$numbots</b> $who{'149'} $who{'10'}$who{'43'}$hidden_print</span><br />
		 </td>
		</tr>
	~;
	} else {
	$yymain .= qq~
		<tr>
		 <td class="windowbg left" colspan="3">
			<span class="small">&nbsp;</span>
		 </td>
		</tr>
	~;
	}

	$yymain .= qq~
		<tr>
        	 <td class="catbg center" style="padding: 8px;" colspan="3">
			<script type='text/javascript'>
			<!--
			var homepage = '$scripturl?action=who'; // Action?
			var sekunden = $whotime; // Secounds?
 
			document.write('<span class="small">$who{'108'} <span id="counter_span">' + sekunden + '</span> $who{'109'}.</span>');

			function countdownWeiterleitung()
			{
				sekunden--;
				document.getElementById('counter_span').innerHTML = sekunden;
				if ( !sekunden ) {
					document.location.href = homepage;
				}
			}

			window.setInterval('countdownWeiterleitung()', 1000);
			//-->
			</script> 
                 </td>
		</tr>
	</table>
	~;

	template();
	exit;
}

sub GetBotlist {
    if ( -e "$vardir/bots.hosts" ) {
        fopen( BOTS, "$vardir/bots.hosts" )
          || fatal_error( 'cannot_open', "$vardir/bots.hosts", 1 );
        my @botlist = <BOTS>;
        fclose(BOTS);
        chomp @botlist;
        foreach (@botlist) {
            if ( $_ =~ /(.*?)\|(.*)/xsm ) {
                push @all_bots, $1;
                $bot_name{$1} = $2;
            }
        }
    }
    return;
}

sub Is_Bot {
    my ($bothost) = @_;
    foreach (@all_bots) { return $bot_name{$_} if $bothost =~ /$_/ism; }
    return;
}

1;
