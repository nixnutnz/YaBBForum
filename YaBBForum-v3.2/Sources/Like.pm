#-------------------------------------------------------------------#
# Mods.Like.pm                                                      #
#-------------------------------------------------------------------#
# Like 4 YaBB2612                                                   #
# Version 0.5                                                       #
# by Carsten Dalgaard                                               #
#-------------------------------------------------------------------#
# Copyright: 2013 'Carsten Dalgaard' - All Rights Reserved          #
# e-mail: post@carsten-dalgaard.dk                                  #
#-------------------------------------------------------------------#
# Any redistribution of this script without the expressed written   #
# consent of 'Carsten Dalgaard' is strictly prohibited. Copying any #
# of the code contained within this script and claiming it as       #
# your own is also prohibited.                                      #
#-------------------------------------------------------------------#
# By using this script you agree to indemnify 'Carsten Dalgaard'    #
# from any liability that might arise from its use.                 #
#-------------------------------------------------------------------#
# You may not remove any of these header notices.                   #
#-------------------------------------------------------------------#
$likepmver = 'YaBBForum 3.2';
if ( $action eq 'detailedversion' ) { return 1; }

LoadLanguage('Mods/Like');

sub LikeList {
    $to_scrl = $INFO{'toscrl'};
    $to_tp   = $INFO{'tobd'};
    if ( $INFO{'toboard'} ) {
        $return_to = qq~board=$INFO{'toboard'};scrlto=$to_scrl~;
    }
    else { $return_to = qq~num=$to_tp;scrlto=$to_scrl~; }
    fopen( TOPIC, "$datadir/$to_tp.txt" )
      || fatal_error( 'cannot_open', "$datadir/$to_tp.txt", 1 );
    @thread = <TOPIC>;
    fclose(TOPIC);
    ( $tpname, undef ) = split /[|]/xsm, $thread[0];
    ToChars($tpname);
    MessageTotals( 'load', $to_tp );
    @likes   = split /,/xsm, ${$to_tp}{'like'};
    $likes   = @likes;
    $txtlike = NumberFormat($likes);
    $altlike = $txtlike;
    $altlike .=
      $likes > 1 ? qq~ $like_txt{'likemembers'}~ : qq~ $like_txt{'likemember'}~;
    $altlike .=
      $likes > 1 ? qq~ $like_txt{'liketopic'}~ : qq~ $like_txt{'liketopics'}~;
    $likeopt = q{};

    foreach (@likes) {
        LoadUser($_);
        $likename{ ${ $uid . $_ }{'realname'} } = "${$uid.$_}{'realname'}|$_";
    }
    for my $tmpmembername (
        sort { lc $likename{$a} cmp lc $likename{$b} }
        keys %likename
      )
    {
        ( $membername, $memberid ) = split /[|]/xsm, $likename{$tmpmembername};
        if ( $iamguest ) {
            $mlmb = qq~$format_unbold{$memberid}~;
        }
        else {
            if   ($do_scramble_id) { $user = cloak($memberid); }
            else                   { $user = $memberid; }
            $mlmb =
qq~<a href="$scripturl?action=viewprofile;username=$user" target="_blank">$format_unbold{$memberid}</a>~;
        }
        
$likeopt .= $likeopt ? qq~, $mlmb~ : qq~$mlmb~;

}
    $yymain = qq~
    <div class="bordercolor" style="width:350px">
    <table class="cs_thin pad_3px">
        <tr>
            <td class="titlebg">
                <span class="small">$altlike:<br />$tpname</span>
            </td>
        </tr><tr>
            <td class="windowbg">
                <div class="windowbg2 likediv">
                $likeopt
                </div>
            </td>
        </tr><tr>
            <td class="windowbg center">
                <input type="button" class="button" onclick="close_return(); window.close()" value="$like_txt{'closewin'}" />
            </td>
        </tr>
    </table>
    </div>

    <script type="text/javascript">
    var scripturl = '$scripturl';
    var returnto = '$return_to';
    function close_return() {
        opener.location.href=scripturl + '?' + returnto;
    }
    </script>
    ~;
    $yytitle = $altlike;
    LikeListtemplate();
    return;
}

sub LikeListtemplate {
    print_output_header();

    $output =
qq~<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$yytitle</title>
    <meta http-equiv="Content-Type" content="text/html; charset=$yymycharset" />
    <link rel="stylesheet" href="$yyhtml_root/Templates/Forum/$usestyle.css" type="text/css" />
</head>
<body class="windowbg" style="margin: 0px; padding: 0px;">
    $yymain
</body>
</html>~;

    print_HTML_output_and_finish();
    return;
}

sub LikeInc {
    if ($iamguest) { fatal_error('no_access'); }
    $liketopic = $INFO{'thread'};
    MessageTotals( 'inclike', $liketopic );
    $yySetLocation = qq~$scripturl?num=$liketopic~;
    redirectexit();
    return;
}

sub LikeDec {
    if ($iamguest) { fatal_error('no_access'); }
    $liketopic = $INFO{'thread'};
    MessageTotals( 'declike', $liketopic );
    $yySetLocation = qq~$scripturl?num=$liketopic~;
    redirectexit();
    return;
}

1;
