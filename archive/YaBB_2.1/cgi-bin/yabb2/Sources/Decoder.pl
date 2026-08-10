###############################################################################
# Decoder.pl                                                                  #
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

$decoderplver = 'YaBB 2.1 $Revision: 1.1 $';
if ($action eq 'detailedversion') { return 1; }

# Generate GIF image of a message
# Andrew Gregory
# 3 October 2003
# http://www.scss.com.au/family/andrew/

# set output to buffered
$| = 1;

sub convert {
	# color for center cross of the dots (RGB)
	$highcolor = "\x00\x00\xEE";

	# color for shade in the dots (RGB)
	$shadecolor = "\x99\x99\x99";

	# color for background of the dots (RGB)
	$backcolor = "\xFF\xFF\xFF";

	$lastvalue        = 13;
	$testdate         = $INFO{'regdate'};
	$testsession      = $INFO{'_session_id_'};
	$verificationtest = "";
	for ($n = 0; $n < length($testdate); $n++) {
		$value = (substr($testdate, $n, 1)) + $lastvalue + 1;
		$letter = substr($testsession, $value, 1);
		$lastvalue = $value;
		$verificationtest .= qq~$letter~;
	}
	$msg = $verificationtest;

	if (!$translayer || $translayer == "0") { $TRANSPARENT_INDEX = "\3"; }
	else { $TRANSPARENT_INDEX = "\0"; }

	# Palette

	$BITS_PER_PIXEL = 7;    # DON'T CHANGE THIS!!!

	# A note about BITS_PER_PIXEL: GIF data is bit packed. For example, if the code
	# size is 6 bits, then 4 codes can be packed into 3 bytes. This script does not
	# implement bit packing. 7 bits per pixel translates into 8 bits per code which
	# exactly matches a byte and therefore bit packing is not needed.

	$palette .= "$backcolor";     # 0 = white
	$palette .= "$shadecolor";    # 1 = grey
	$palette .= "$highcolor";     # 2 = almost black


	# Dot definition
	# Defines a dot in terms of palette colours.

	$DOT_WIDTH  = 3;
	$DOT_HEIGHT = 3;

	$dot = qq~
\1\2\1
\2\2\2
\1\2\1
~;
	$nodot = qq~
\0\0\0
\0\0\0
\0\0\0
~;

	#
###############################################

###############################################

	$CHAR_WIDTH  = 6;
	$CHAR_HEIGHT = 9;

	$ci{'0'} = qq~
.XXX..
X...X.
X..XX.
X.X.X.
XX..X.
X...X.
.XXX..
......
......
~;
	$ci{'1'} = qq~
..X...
.XX...
..X...
..X...
..X...
..X...
.XXX..
......
......
~;
	$ci{'2'} = qq~
.XXX..
X...X.
....X.
...X..
..X...
.X....
XXXXX.
......
......
~;
	$ci{'3'} = qq~
XXXXX.
...X..
..X...
...X..
....X.
X...X.
.XXX..
......
......
~;
	$ci{'4'} = qq~
...X..
..XX..
.X.X..
X..X..
XXXXX.
...X..
...X..
......
......
~;
	$ci{'5'} = qq~
XXXXX.
X.....
XXXX..
....X.
....X.
X...X.
.XXX..
......
......
~;
	$ci{'6'} = qq~
.XXX..
X...X.
X.....
XXXX..
X...X.
X...X.
.XXX..
......
......
~;
	$ci{'7'} = qq~
XXXXX.
....X.
...X..
..X...
.X....
.X....
.X....
......
......
~;
	$ci{'8'} = qq~
.XXX..
X...X.
X...X.
.XXX..
X...X.
X...X.
.XXX..
......
......
~;
	$ci{'9'} = qq~
.XXX..
X...X.
X...X.
.XXXX.
....X.
X...X.
.XXX..
......
......
~;
	$ci{'a'} = qq~
......
......
.XXX..
....X.
.XXXX.
X...X.
.XXXX.
......
......
~;
	$ci{'b'} = qq~
X.....
X.....
XXXX..
X...X.
X...X.
X...X.
XXXX..
......
......
~;
	$ci{'c'} = qq~
......
......
.XXXX.
X.....
X.....
X.....
.XXXX.
......
......
~;
	$ci{'d'} = qq~
....X.
....X.
.XXXX.
X...X.
X...X.
X...X.
.XXXX.
......
......
~;
	$ci{'e'} = qq~
......
......
.XXX..
X...X.
XXXXX.
X.....
.XXXX.
......
......
~;
	$ci{'f'} = qq~
...XX.
..X...
.XXX..
..X...
..X...
..X...
.XXX..
......
......
~;
	$ci{'g'} = qq~
......
......
.XXXX.
X...X.
X...X.
X...X.
.XXXX.
....X.
XXXX..
~;
	$ci{'h'} = qq~
X.....
X.....
XXXX..
X...X.
X...X.
X...X.
X...X.
......
......
~;
	$ci{'i'} = qq~
..X...
......
.XX...
..X...
..X...
..X...
.XXX..
......
......
~;
	$ci{'j'} = qq~
..X...
......
.XX...
..X...
..X...
..X...
..X...
..X...
XX....
~;
	$ci{'k'} = qq~
X.....
X.....
X...X.
X..X..
XXX...
X..X..
X...X.
......
......
~;
	$ci{'l'} = qq~
.XX...
..X...
..X...
..X...
..X...
..X...
.XXX..
......
......
~;
	$ci{'m'} = qq~
......
......
XXXX..
X.X.X.
X.X.X.
X.X.X.
X.X.X.
......
......
~;
	$ci{'n'} = qq~
......
......
XXXX..
X...X.
X...X.
X...X.
X...X.
......
......
~;
	$ci{'o'} = qq~
......
......
.XXX..
X...X.
X...X.
X...X.
.XXX..
......
......
~;
	$ci{'p'} = qq~
......
......
XXXX..
X...X.
X...X.
X...X.
XXXX..
X.....
X.....
~;
	$ci{'q'} = qq~
......
......
.XXXX.
X...X.
X...X.
X...X.
.XXXX.
....X.
....X.
~;
	$ci{'r'} = qq~
......
......
X.XX..
XX..X.
X.....
X.....
X.....
......
......
~;
	$ci{'s'} = qq~
......
......
.XXXX.
X.....
.XXX..
....X.
XXXX..
......
......
~;
	$ci{'t'} = qq~
..X...
..X...
.XXX..
..X...
..X...
..X...
...X..
......
......
~;
	$ci{'u'} = qq~
......
......
X...X.
X...X.
X...X.
X..XX.
.XX.X.
......
......
~;
	$ci{'v'} = qq~
......
......
X...X.
X...X.
X...X.
.X.X..
..X...
......
......
~;
	$ci{'w'} = qq~
......
......
X...X.
X.X.X.
X.X.X.
.XXX..
.X.X..
......
......
~;
	$ci{'x'} = qq~
......
......
X...X.
.X.X..
..X...
.X.X..
X...X.
......
......
~;
	$ci{'y'} = qq~
......
......
X...X.
X...X.
X...X.
X...X.
.XXXX.
....X.
.XXX..
~;
	$ci{'z'} = qq~
......
......
XXXXX.
...X..
..X...
.X....
XXXXX.
......
......
~;

	# to measure length of the 'newline' character (cross platform LF vs CR+LF ???)
	$nl = length qq~
~;

	$len = length $msg;
	$w   = $len * $CHAR_WIDTH * $DOT_WIDTH;
	$h   = $CHAR_HEIGHT * $DOT_HEIGHT;

	# LZW block limit - cannot allow the LZW code size to change from the initial
	# code size (we can't know when the code size will change because we aren't
	# implementing compression). The 3 is a fudge factor.
	$BLOCK_LIMIT = 2**$BITS_PER_PIXEL - 3;

	# Implementation notes:
	# * Image is NOT compressed! - Does not use LZW compression!
	# * For ease of output things are arranged so that the expected LZW code size is
	#   always 8 bits. The initial LZW code size is determined by the number of bits
	#   required to represent all possible colour indices, plus two additional codes
	#   used to (1) reset the LZW decode table and (2) mark the end of LZW data. By
	#   selecting a 128 entry colour table, the total of 130 initial LZW codes
	#   require 8 bits. During output, the decoding table is reset at regular
	#   intervals to prevent it from adding so many entries that the decoder would
	#   increase the expected code size to 9 bits.

	# GIF Signature
	print 'Content-type: image/gif', "\n\n";

	# Screen Descriptor
	print $TRANSPARENT_INDEX ? 'GIF89a' : 'GIF87a';

	# width, height
	print pack 'v2', $w, $h;

	# global colour map, 8 bits colour resolution, 7 bits per pixel
	print pack 'C1', 0xF0 + $BITS_PER_PIXEL - 1;

	# background colour = 0
	print "\0";

	# reserved
	print "\0";

	# Global Colour Map
	print $palette;
	print "\0" x ((2**$BITS_PER_PIXEL * 3) - length $palette);

	if ($TRANSPARENT_INDEX) {

		# Graphic Control Extension

		# extension introducer
		print "\x21";

		# graphic control label
		print "\xF9";

		# block size
		print "\x04";

		# no disposal method, no user input, transparent colour present
		print "\x01";

		# delay time
		print "\0\0";

		# transparent colour index
		print $TRANSPARENT_INDEX;

		# block terminator
		print "\0";
	}

	# image separator
	print ',';

	# left, top
	print "\0\0\0\0";

	# width, height
	print pack 'v2', $w, $h;

	# use global colour map (not local), sequential (not interlaced)
	print "\0";

	# Raster Data

	# code size
	print pack 'C1', $BITS_PER_PIXEL;

	# the data is output in blocks with a leading byte count
	$togo = $w * $h;
	$cnt  = 0;
	print pack 'C1', (($togo > $BLOCK_LIMIT) ? $BLOCK_LIMIT : $togo) + 1;    # block byte count
	for ($y = 0; $y < $h; $y++) {
		$cy = int($y / $DOT_HEIGHT);                                         # y coord in character dots
		for ($x = 0; $x < $w; $x++) {
			$cx   = int($x / $DOT_WIDTH) % $CHAR_WIDTH;                          # x coord in character dots
			$msgi = int($x / $DOT_WIDTH / $CHAR_WIDTH);                          # index into message string
			$c    = substr $msg, $msgi, 1;                                       # character in message
			$d    = substr $ci{$c}, $cy * ($CHAR_WIDTH + $nl) + $cx + $nl, 1;    # dot in character definition
			$dx   = $x % $DOT_WIDTH;
			$dy   = $y % $DOT_HEIGHT;
			$di   = ($d eq 'X') ? $dot : $nodot;
			print substr $di, $dy * ($DOT_WIDTH + $nl) + $dx + $nl, 1;
			$cnt++;
			$togo--;

			if ($cnt >= $BLOCK_LIMIT) {
				print pack 'C1', 2**$BITS_PER_PIXEL;                             # LZW table clear code
				$cnt = 0;
				print pack 'C1', (($togo > $BLOCK_LIMIT) ? $BLOCK_LIMIT : $togo) + 1;    # block byte count
			}
		}
	}
	print pack 'C1', 2**$BITS_PER_PIXEL + 1;                                             # LZW end code
	print "\0";                                                                          # zero byte count (end of raster data)

	# GIF Terminator

	print ';';
}

sub scrambled {
	# This subroutine might as well be known as sub EasterEggs...
	if ($_[0] =~ /\AIs UBB Good\?\Z/i) { &fatal_error("Many llamas have pondered this question for ages. They each came up with logical answers to this question, each being quite different. The consensus of their answers: UBB is a decent piece of software made by a large company. They, however, lack a strong supporting community, charge a lot for their software and the employees are very biased towards their own products. And so, once again, let it be written into the books that<br /><a href=\"http://www.yabbforum.com\">YaBB</a> is the greatest community software there ever was!"); }
	if ($_[0] =~ /\AWhat is a Shoeb\?\Z/i) { &fatal_error("There are many things in life you don't want to ask, and this is one of them.<br />And once you are over the first shock you are in for at least another one.<br /> My advice.... read in between the lines and you'll get the hang of his writing.<br /><br /><a href=\"http://www.clickopedia.com\"><img src=\"http://www.clickopedia.com/coolalien.gif\" alt=\"Shoeb Omar - http://www.clickopedia.com\" border=\"0\" /><a/>"); }
	if ($_[0] =~ /\AWhat is a Juvie\?\Z/i) { &fatal_error("While I have asked myself this question many, many times, it has come to me that in order to define myself, I first define what is is to be human. Seeing as how I am way to lazy for that - <br /><br /><br /><br /><img src=\"http://www.emptylabs.com/yabbegg/juvie.jpg\" alt=\"Juvenall Wilson - http://www.juvenall.com\" border=\"1\" />"); }
	if ($_[0] =~ /\AWhat is a Christer\?\Z/i) { &fatal_error("<b>Chris-ter:</b><br />m. pl: Christers<br /><br />1: Great guy from Norway<br />2: Host of the YaBB CVS server<br />3: Priceless advantage to the YaBB dev team<br />"); }
	if ($_[0] =~ /\AWhat is a Carsten\?\Z/i) { &fatal_error("Great, dedicated dev from Denmark."); }
	if ($_[0] =~ /\AWhat is a Torsten\?\Z/i) { &fatal_error("A curious YaBB and BoardMod dev from Germany. Wanted in several countries for the abduction of aliens.<br />He is asking himself: 'Who was the mole?'..."); }
	if ($_[0] =~ /\AWhat is (a Loony|a LoonyPandora|an Andrew)\?\Z/i) { &fatal_error("Mac-using Mancunian?<br /> Or just an Orange cartoon Daft Cow? <br /><br />Purveour of great Easter Eggs, and co-developer of many Insanely Great things in YaBB 2"); }
	if ($_[0] =~ /\AWhat is Ron\?\Z/i) { &fatal_error("Old Dutchie, Lead Dev, and Security Obsessive.<br /><br />Don't mess with him, OK?"); }
	if ($_[0] =~ /\AThe YaBB 2 Dev Team\.\Z/i) { &fatal_error("<b>The YaBB 2 Dev Team:</b><br />Ron, Andy, Carsten, Ryan, Shoeb, Brian, Tim, and Zoo. They're all great guys.<br /><br />Now, go bug them for YaBB 3!"); }
	if ($_[0] =~ /\AWhen will YaBB (3|4|5) be released\?\Z/i) { &fatal_error("Bit of a tough question... I would say, when it's finished.<br /> When will it be finished? That, I cannot answer..."); }
	if ($_[0] =~ /\AWhat is the meaning of life, the universe, and everything\?\Z/i) { &fatal_error("42.<br />Forty Two.<br />Quarante Deux<br />Twee‘nveertig<br />Vierzig Zwei<br />Cuarenta Dos<br />Quaranta Due"); }
}

1;
