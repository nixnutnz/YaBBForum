###############################################################################
# RemoveOldThreads.pl                                                         #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Community Software for Webmasters                               #
# Version:        YaBB 1 Gold - SP 1.1                                        #
# Released:       December 2001; Updated March 22, 2002                       #
# Distributed by: http://www.yabbforum.com                                    #
# =========================================================================== #
# Copyright (c) 2000-2002 Xnull (www.xnull.com) - All Rights Reserved.        #
# Software by: The YaBB Development Team                                      #
#              with assistance from the YaBB community.                       #
###############################################################################

$removeoldthreadsplver = "1 Gold - SP 1.1";

sub RemoveOldThreads {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	$yytitle = "$txt{'120'} $FORM{'maxdays'}";
	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);
	fopen(FILE, ">$vardir/oldestmes.txt");
	print FILE "$FORM{'maxdays'}";
	fclose(FILE);
	foreach $curcat (@categories) {
		chomp $curcat;
		fopen(FILE, "$boardsdir/$curcat.cat");
		$curcatname = <FILE>;
		$curcataccess = <FILE>;
		chomp $curcatname;
		chomp $curcataccess;
		@catinfo = <FILE>;
		fclose(FILE);
		$date2 = $date;
		foreach $curboard (@catinfo) {
			chomp $curboard;
			fopen(FILE, "$boardsdir/$curboard.txt");
			@messages = <FILE>;
			fclose(FILE);
			fopen(FILE, ">$boardsdir/$curboard.txt", 1);
			for ($a = 0; $a < @messages; $a++) {
				($num, $dummy, $dummy, $dummy, $date1) = split(/\|/, $messages[$a]);
				&calcdifference;
				if($result <= $FORM{'maxdays'}) {
					# If the message is not too old
					print FILE $messages[$a];
					$yymain .= "$num = $result $txt{'122'}<br>";
				} else {
					$yymain .= "$num = $result $txt{'122'} ($txt{'123'})<br>";
					unlink("$datadir/$num.txt");
					unlink("$datadir/$num.mail");
					unlink("$datadir/$num.data");
					&Sticky_remove($num);
				}
			}
			fclose(FILE);
			&BoardCountTotals($curboard);
		}
	}
	&template;
	exit;
}

1;