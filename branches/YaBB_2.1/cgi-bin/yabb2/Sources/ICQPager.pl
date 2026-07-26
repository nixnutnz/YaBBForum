###############################################################################
# ICQPager.pl                                                                 #
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

$icqpagerplver = 'YaBB 2.1 $Revision: 1.1 $';
if ($action eq 'detailedversion') { return 1; }

LoadLanguage("ICQ");
if ($language) { require "$langdir/$language/ICQ.lng"; }
else { require "$langdir/$lang/ICQ.lng"; }

sub IcqPager {
	if ($realname eq '') { $settofield = "from"; }
	else { $settofield = "body"; }
	$uin = $INFO{'UIN'};
	$yymain .= qq~
<form action="http://web.icq.com/whitepages/page_me/1,,,00.html" name="form" method="post">
<table border="0" width="600" align="center" cellspacing="1" cellpadding="0" class="bordercolor">
  <tr>
    <td width="100%" class="windowbg">
    <table width="100%" border="0" cellspacing="0" cellpadding="3">
      <tr>
        <td class="titlebg" colspan="2">
        <b>$icqtxt{'1'} $icqtxt{'2'}</b></td>
      </tr><tr>
        <td class="windowbg" align="left" valign="top">
        <b>$icqtxt{'3'}:</b>
        </td>
        <td class="windowbg" align="left" valign="middle">
        <img src="http://web.icq.com/whitepages/online?icq=$uin&#38;img=5" alt="$uin" border="0" />$uin
        </td>
      </tr><tr>
      <td colspan="2" height="2" class="bordercolor"></td>
      </tr><tr>
        <td class="windowbg" align="left" valign="top">
        <b>$icqtxt{'4'}:</b>
        </td>
        <td class="windowbg" align="left" valign="middle">
        <input type="text" value="$realname" name="from" size="20" maxlength="40" />
        </td>
      </tr><tr>
        <td class="windowbg" align="left" valign="top">
        <b>$icqtxt{'5'}:</b>
        </td>
        <td class="windowbg" align="left" valign="middle">
        <input type="text" value="$realemail" name="fromemail" size="20" maxlength="40" />
        </td>
      </tr><tr>
      <td colspan="2" height="2" class="bordercolor"></td>
      </tr><tr>
        <td  class="windowbg2" align="left" valign="top">
        <b>$icqtxt{'6'}:</b>
        </td>
        <td class="windowbg2" align="left" valign="middle">
        <textarea name="body" rows="10" cols="50"></textarea>
        </td>
      </tr><tr>
      <td colspan="2" height="2" class="bordercolor"></td>
      </tr><tr>
        <td class="titlebg" align="center" valign="middle" colspan="2">
        <input type="hidden" name="subject" value="$mbname" />
	<input type="hidden" name="to" value="$INFO{'UIN'}" />
        <span  class="small">$icqtxt{'7'}</span><br />
        <input type="submit" name="Send" value="$icqtxt{'8'}" accesskey="s" />
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</form>
<script type="text/javascript" language="JavaScript"> <!--
	document.form.$settofield.focus();
//--> </script>
~;
	$yytitle = "$icqtxt{'1'} $icqtxt{'2'}";
	&template;
	exit;

}

1;
