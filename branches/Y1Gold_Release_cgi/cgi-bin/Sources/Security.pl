###############################################################################
# Security.pl                                                                 #
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

$securityplver="1 Gold - Release";

sub is_admin {
	if($settings[7] ne 'Administrator') { &fatal_error($txt{'1'}); }
}

sub is_admin2 {
	if($settings[7] ne 'Administrator') { &fatal_error($txt{'134'}); }
}

sub banning {
	# IP BANNING
	$remote_ip = $ENV{'REMOTE_ADDR'};
	fopen(BAN, "$vardir/ban.txt" );
	@entries = <BAN>;
	fclose(BAN);
	foreach $ban_ip (@entries) {
   		chop($ban_ip);
   		$str_len = length($ban_ip);
   		$comp_ip = substr($remote_ip,0,$str_len);
   		if ($comp_ip eq $ban_ip) {
      			fopen(LOG, ">>$vardir/ban_log.txt" );
      			&lock(LOG);
      			print LOG "$remote_ip\n";
      			&unlock(LOG);
     			fclose(LOG);
     			$username = "Guest";
     			&fatal_error("$txt{'678'}$txt{'430'}!");
      			exit;
      		}
	}
	# EMAIL BANNING
	if ($username ne 'Guest') {
	$remote_ip = "$ENV{'REMOTE_ADDR'}";
	fopen(BAN, "$vardir/ban_email.txt" );
	@entries = <BAN>;
	fclose(BAN);
	foreach $ban_email (@entries) {
   		if (lc $ban_email eq lc $settings[2]) {
      			fopen(LOG, ">>$vardir/ban_log.txt" );
      			print LOG "$ban_email ($remote_ip)\n";
     			fclose(LOG);
     			$username = "Guest";
      			&fatal_error("$txt{'678'}$txt{'430'}!");
      			exit;
      		}
	}
	}
}

sub CheckIcon {
	$icon =~ s/[^A-Za-z]//g;
	unless($icon eq "xx" || $icon eq "thumbup" || $icon eq "thumbdown" || $icon eq "exclamation") {
		unless($icon eq "question" || $icon eq "lamp" || $icon eq "smiley" || $icon eq "angry") {
			unless($icon eq "cheesy" || $icon eq "laugh" || $icon eq "sad" || $icon eq "wink") {
				$icon = "xx";
			}
		}
	}
}

1;