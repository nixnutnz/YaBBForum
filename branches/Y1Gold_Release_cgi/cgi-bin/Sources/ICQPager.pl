###############################################################################
# ICQPager.pl                                                                 #
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

$icqpagerplver="1 Gold - Release";

sub IcqPager
{
	$uin = $INFO{'UIN'};

	$yytitle = "$txt{'513'} $txt{'514'}";
	&header;

print <<"EOT";
<form action="http://wwp.mirabilis.com/scripts/WWPMsg.dll" method="post">
<table border=0  width="600" align="center" cellspacing=1 cellpadding="0" bgcolor="$color{'bordercolor'}" class="bordercolor">
  <tr>
    <td width="100%" bgcolor="$color{'windowbg'}" class="windowbg">
    <table width="100%" border="0" cellspacing="0" cellpadding="3">
      <tr>
        <td class="titlebg" bgcolor="$color{'titlebg'}" colspan="2">
        <font size=2 class="text1" color="$color{'titletext'}"><b>$yytitle</b></font></td>
      </tr><tr>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align=right valign=top>
        <font size=2><B>$txt{'324'}:</B></font>
        </td>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align=left valign=middle>
        <img src="http://wwp.icq.com/scripts/online.dll?icq=$uin&img=5" alt="$uin" border="0"> <font size="2">$uin</font>
        </td>
      </tr><tr>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align=right valign=top>
        <font size=2><B>$txt{'335'}:</B></font>
        </td>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align=left valign=middle>
        <input type="text" name="from" size="20" maxlength="40">
        </td>
      </tr><tr>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align="right" valign="top">
        <font size=2><B>$txt{'336'}:</B></font>
        </td>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align="left" valign="middle">
        <input type="text" name="fromemail" size="20" maxlength="40">
        </td>
      </tr><tr>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align=right valign=top>
        <font size=2><B>$txt{'72'}:</B></font>
        </td>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align=left valign=middle>
        <textarea name="body" rows="8" cols="45" wrap="Virtual"></textarea>
        </td>
      </tr><tr>
        <td bgcolor="$color{'windowbg'}" class="windowbg" align=center valign=middle colspan=2>
        <input type="hidden" name="subject" value="$mbname">
	<input type="hidden" name="to" value="$INFO{'UIN'}">
        <input type="submit" name="Send" value="$txt{'339'}">
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
</form>
EOT

	&footer;
	exit;

}

1;