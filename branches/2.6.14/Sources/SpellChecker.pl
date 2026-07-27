#!/usr/bin/perl --

###############################################################################
# SpellChecker.pl                                                             #
# $Date: 26.7.26 $                                                           #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Community Software for Webmasters                               #
# Version:        YaBB 2.6.14                                                 #
# Packaged:       July 26, 2026                                             #
# Distributed by: http://yabbforum.nz                                    #
# =========================================================================== #
# Copyright (c) 2000-2016 YaBB (yabbforum.nz) - All Rights Reserved.     #
# Software by:  The YaBB Development Team                                     #
#               with assistance from the YaBB community.                      #
###############################################################################
use CGI::Carp qw(fatalsToBrowser);
our $VERSION = '2.6.14';

$spellcheckerplver = 'YaBB 2.6.14 $Revision: 2601 $';
if ( $action eq 'detailedversion' ) { return 1; }

use LWP::UserAgent;
use HTTP::Request::Common;

$ua = LWP::UserAgent->new( agent => 'GoogieSpell Client' );
$reqXML = q{};

read STDIN, $reqXML, $ENV{'CONTENT_LENGTH'};

$url = "http://orangoo.com/newnox?lang=$ENV{'QUERY_STRING'}";
$res =
  $ua->request(POST $url, Content_Type => 'text/xml', Content => $reqXML);

croak "$res->{_content}" if $res->{_content} =~ /LWP.+https.+Crypt::SSLeay/sm;

print "Content-Type: text/xml\n\n" or croak "$croak{'print'} content-type";
print $res->{_content} or croak "$croak{'print'} speller";

1;
