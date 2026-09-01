###############################################################################
# ModList.pm                                                                  #
# $Date: 01 Sep 2026 $                                                           #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Community Software for Webmasters                               #
# Version:        YaBBForum 3.2                                                 #
# Packaged:       01 Sep 2026                                             #
# Distributed by: https://yabbforum.nz                                    #
# =========================================================================== #
# Copyright (c) 2000-2026 YaBB (yabbforum.nz) - All Rights Reserved.     #
# Software by:  The YaBB Development Team                                     #
#               with assistance from the YaBB community.                      #
###############################################################################
# use strict;
use CGI::Carp qw(fatalsToBrowser);
our $VERSION = '3.2';

$modlistpmver = 'YaBBForum 3.2';
if ( $action eq 'detailedversion' ) { return 1; }

sub ListMods {
    my @installed_mods = ();

    # You need to list your mod in this file for full compliance.
    # Add it in the following way:
    #        $my_mod = "Name of Mod|Author|Description|Version|Date Released";
    #        push @installed_mods, $my_mod;
    # It is recommended that you do a "add before" on the end boardmod tag
    # This preserves the installation order.

    # Also note, you should pick a unique name instead of "$my_mod".
    # If your mod is called "SuperMod For Doing Cool Things"
    # You could use "$SuperMod_CoolThings"

### BOARDMOD ANCHOR ###

    $styleswitch = q~Style Switcher for YaBBForum 3.2|Thomas Mueller (ThM) Andi Kanzler &amp; Carsten|This mod allows a quick design change by using multiple template stylesheet in combination with a simple dropdown box. The last setting is save by a cookie. You can enable or disable these options and select to allow membergroups to use the Style Switcher in your admin center. This mod based on the AK108 YaBB 2.1 set template in url add-on. Thanks to him!|1.8|Jan 13, 2015~;
    push @installed_mods, $styleswitch;
    
    $like_mod = "Like_4_YaBB2612|Carsten, updated to 2.6.12 by Dandello|This mod adds a members 'Like' button to topics.|0.5|03/20/2016";
    push @installed_mods, $like_mod;
    
    ## Who is Where Mod ##
      $who_is_where = "Who is Where YaBB 2.6.1|<a href=\"http://www.xonder.com/cgi-bin/yabb26/YaBB.pl\" target=\"_blank\">XTC</a>|- shows what a user is doing on the board<br />- shows a link or button to the online overview in the yabb menu<br />- shows the ips of the users to the admins and global moderators in the online overview<br />- admin actions can be hidden for all other users (also g-mods)<br />- user can send 'Direct Messages' to other users in the online overview<br />- members can hide 'direct messages icon' in his/her Profile, so it will not display in online overview<br />- admin can denable above 'direct messages icon' profile setting<br /><br /><span class=\"small\"><b>Credits:</b> original mod (YaBB 1.xx) by 'DaddyCool, dOCda S!, Gobalopper, Delrick'</span>|beta 2|06/Dec/2014";
      push (@installed_mods, "$who_is_where");
      
### END BOARDMOD ANCHOR ###
    our ( $yymain, %mod_list, $imagesdir, $yytitle );
    my ( $action_area,  $mod_text_list, $full_description );
    $total_mods = @installed_mods;

    if ( !@installed_mods ) {
        $yymain .= qq~
<div class="bordercolor rightboxdiv">
    <div class="pad-more"><table class="border-space pad-cell">
        <tr>
            <td class="titlebg">
                $admin_img{'prefimg'} <b>$mod_list{'5'}</b>
            </td>
        </tr><tr>
            <td class="windowbg2">
                <div class="pad-more">
                    $mod_list{'8'} <a href="https://www.boardmod.org" target="_blank">$mod_list{'9'}</a>
                </div>
            </td>
        </tr>
    </table>
</div>
~;
        $yytitle     = $mod_list{'6'};
        $action_area = 'modlist';
        AdminTemplate();
    }

    foreach my $modification (@installed_mods) {
        chomp $modification;
        my ( $mod_anchor, $mod_author, $mod_desc, $mod_version, $mod_date ) =
          split /\|/xsm, $modification;

        my $mod_displayname = $mod_anchor;
        $mod_displayname =~ s/\_/ /gxsm;
        $mod_anchor      =~ s/ /\_/gsm;
        $mod_anchor      =~ s/[^\w]//gxsm;

        $mod_text_list .= qq~<tr>
            <td class="windowbg2">
                <a href="#$mod_anchor">$mod_displayname</a>
            </td>
            <td class="windowbg2">
                $mod_author
            </td>
            <td class="windowbg2">
                $mod_version
            </td>
        </tr>~;

        $full_description .= qq~
<div class="bordercolor rightboxdiv">
    <table class="border-space pad-cell" style="margin-bottom: .5em;">
        <tr>
            <td class="titlebg">
                <a id="$mod_anchor">$admin_img{'prefimg'}</a> <b>$mod_displayname</b> &nbsp; <span class="small">$mod_list{'4'}: $mod_version</span>
            </td>
        </tr><tr>
            <td class="catbg">
                <span class="small">$mod_list{'2'}: $mod_author</span>
            </td>
        </tr><tr>
            <td class="windowbg2">
                $mod_desc
            </td>
        </tr><tr>
            <td class="catbg right">
                <div class="pad-more small">$mod_list{'3'}: $mod_date</div>
            </td>
        </tr>
    </table>
</div>~;
    }

    $yymain .= qq~
<div class="bordercolor rightboxdiv">
    <table class="border-space pad-cell" style="margin-bottom: .5em;">
        <tr>
            <td class="titlebg" colspan="3">
                $admin_img{'prefimg'} <b>$mod_list{'5'} ($total_mods)</b>
            </td>
        </tr><tr>
            <td class="catbg">
                <span class="small">$mod_list{'1'}</span>
            </td>
            <td class="catbg">
                <span class="small">$mod_list{'2'}</span>
            </td>
            <td class="catbg">
                <span class="small">$mod_list{'4'}</span>
            </td>
        </tr>
        $mod_text_list
     </table>
</div>
$full_description
~;

    $yytitle     = $mod_list{'6'};
    $action_area = 'modlist';
    AdminTemplate();
    return $yymain;
}

1;
