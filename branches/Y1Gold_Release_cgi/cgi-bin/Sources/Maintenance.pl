###############################################################################
# Maintenance.pl                                                              #
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

$maintenanceplver="1 Gold - Release";

sub InMaintenance 
{
    $yytitle = "$txt{'155'}";
    &header;
    print <<"EOT";

<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
 <tr>
  <td class="titlebg" bgcolor="$color{'titlebg'}">
   <font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'156'}</b></font>
  </td>
 </tr><tr>
  <td class="windowbg" bgcolor="$color{'windowbg'}">
   <font size=2>
    <br>
    $txt{'157'}
    <br>&nbsp;
   </font>
  </td>
 </tr>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}" class="bordercolor">
 <tr>
  <td bgcolor="$color{'titlebg'}"><font size=2 color="$color{'titletext'}"><b> $txt{'114'}</b></font></td>
 </tr><tr>
  <td bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi\&action=login2" method="POST">
   <table border=0>
    <tr>
      <td><font size=2><b>$txt{'35'}:</b></font></td>
      <td><font size=2><input type=text name="username" size=15></font></td>
      <td><font size=2><b>$txt{'36'}:</b></font></td>
      <td><font size=2><input type=password name="passwrd" size=10></font> &nbsp;</td>
      <td><font size=2><b>$txt{'497'}:</b></font></td>
      <td><font size=2><input type=text name="cookielength" size=4 maxlength="4" value="$Cookie_Length"> &nbsp;</font></td>
      <td><font size=2><b>$txt{'508'}:</B></font></td>
      <td><font size=2><input type=checkbox name="cookieneverexp"></font></td>
      <td align=center colspan=2><input type=submit value="$txt{'34'}"></td>
    </tr>
   </table></form></font>
  </td>
 </tr>
</table>
EOT

    &footer;
    exit;
}

1;