###############################################################################
# RemoveOldThreads.pl                                                         #
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

$removeoldthreadsplver="1 Gold - Release";

sub RemoveOldThreads {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	$yytitle = "$txt{'120'} $FORM{'maxdays'}";
	fopen(FILE, "$vardir/cat.txt");
	@categories = <FILE>;
	fclose(FILE);
	fopen(FILE, ">$vardir/oldestmes.txt");
	print FILE "$FORM{'maxdays'}";
	fclose(FILE);
	&header;
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
					print "$num = $result $txt{'122'}<br>";
				} else {
					print "$num = $result $txt{'122'} ($txt{'123'})<br>";
					unlink("$datadir/$num.txt");
					unlink("$datadir/$num.mail");
					unlink("$datadir/$num.data");
				}
			}
			fclose(FILE);
			&BoardCountTotals($curboard);
		}
	}
	&footer;
	exit;
}
1;