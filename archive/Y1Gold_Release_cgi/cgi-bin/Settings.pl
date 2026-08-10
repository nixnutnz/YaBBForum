###############################################################################
# Settings.pl                                                                 #
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

########## Board Info ##########
# Note: these settings must be properly changed for YaBB to work

$maintenance = 0;                                                     # Set to 1 to enable Maintenance mode
$guestaccess = 1;                                                     # Set to 0 to disallow guests from doing anything but login or register

$yyForceIIS = 0;                                                      # Set to 1 if you encounter errors while running on an MS IIS server
$yyblankpageIIS = 0;                                                  # Set to 1 if you encounter blank pages after posting (usually on MS IIS servers)

$language = "english.lng";                                            # Change to language pack you want to use
$mbname = "My YaBB 1 Gold - Release";                                 # The name of your YaBB forum
$boardurl = "http://www.mysite.com/cgi-bin/YaBB";                     # URL of your board's folder (without trailing '/')

$Cookie_Length = 350;                                                 # Cookies will expire after XX minutes of person logging in (they will be logged out after)
$cookieusername = "YaBBusername";                                     # Name of the username cookie
$cookiepassword = "YaBBpassword";                                     # Name of the password cookie

$RegAgree = 1;                                                        # Set to 1 to display the registration agreement when registering
$emailpassword = 1;                                                   # 0 - instant registration. 1 - password emailed to new members
$emailnewpass = 0;                                                    # Set to 1 to email a new password to members if they change their email address
$emailwelcome = 1;                                                    # Set to 1 to email a welcome message to users even when you have mail password turned off

$mailprog = "/usr/sbin/sendmail";                                     # Location of your sendmail program
$smtp_server = "smtp.mysite.com";                                     # SMTP-Server
$webmaster_email = q^webmaster@mysite.com^;                           # Your e-mail address. (eg: $webmaster_email = q^admin@host.com^;)
$mailtype = 0;                                                        # 0 - sendmail, 1 - SMTP, 2 - Net::SMTP


########## Directories/Files ##########
# Note: directories other than $imagesdir do not have to be changed unless you move things

$boarddir = ".";                                                      # The absolute path to the board's folder (usually can be left as '.')
$boardsdir = "$boarddir/Boards";                                      # Directory with board data files
$datadir = "$boarddir/Messages";                                      # Directory with messages
$memberdir = "$boarddir/Members";                                     # Directory with member files
$sourcedir = "$boarddir/Sources";                                     # Directory with YaBB source files
$vardir = "$boarddir/Variables";                                      # Directory with variable files
$facesdir = "../../YaBBImages/avatars";                               # Absolute Path to your avatars folder
$facesurl = "http://www.mysite.com/YaBBImages/avatars";               # URL to your avatars folder
$imagesdir = "http://www.mysite.com/YaBBImages";                      # URL to your images directory
$ubbcjspath = "http://www.mysite.com/ubbc.js";                        # Web path to your 'ubbc.js' REQUIRED for post/modify to work properly!
$faderpath = "http://www.mysite.com/fader.js";                        # Web path to your 'fader.js'
$helpfile = "http://www.mysite.com/YaBBHelp/index.html";              # Location of your help file


########## Colors ##########
# Note: equivalent to colors in CSS tag of template.html, so set to same colors preferrably
# for browsers without CSS compatibility and for some items that don't use the CSS tag

$color{'titlebg'} = "#FFB903";                                        # Background color of the 'title-bar'
$color{'titletext'} = "#000000";                                      # Color of text in the 'title-bar' (above each 'window')
$color{'windowbg'} = "#272A2F";                                       # Background color for messages/forms etc.
$color{'windowbg2'} = "#444444";                                      # Background color for messages/forms etc.
$color{'windowbg3'} = "#FFB903";                                      # Color of horizontal rules in posts
$color{'catbg'} = "#40454C";                                          # Background color for category (at Board Index)
$color{'bordercolor'} = "#000000";                                    # Table Border color for some tables
$color{'fadertext'}  = "#FFFFFF";                                     # Color of text in the NewsFader ("The Latest News" color)
$color{'fadertext2'}  = "#FFFFFF";                                    # Color of text in the NewsFader (news color)

########## Layout ##########

$MenuType = 0;                                                        # 1 for text menu or anything else for images menu
$curposlinks = 0;                                                     # 1 for links in navigation on current page, or 0 for text without link
$profilebutton = 0;                                                   # 1 to show view profile button under post, or 0 for blank
$timeselected = 4;                                                    # Select your preferred output Format of Time and Date
$allow_hide_email = 0;                                                # Allow users to hide their email from public. Set 0 to disable
$showlatestmember = 1;                                                # Set to 1 to display "Welcome Newest Member" on the Board Index
$shownewsfader = 1;                                                   # 1 to allow or 0 to disallow NewsFader javascript on the Board Index
                                                                      # If 0, you'll have no news at all unless you put <yabb news> tag
                                                                      # back into template.html!!!
$Show_RecentBar = 1;                                                  # Set to 1 to display the Recent Posts bar on Board Index
$Show_MemberBar = 1;                                                  # Set to 1 to display the Members List table row on Board Index
$showmarkread = 1;                                                    # Set to 1 to display and enable the mark as read buttons
$showmodify = 1;                                                      # Set to 1 to display "Last modified: Realname - Date" under each message
$ShowBDescrip = 1;                                                    # Set to 1 to display board descriptions on the topic (message) index for each board
$showuserpic = 1;                                                     # Set to 1 to display each member's picture in the message view (by the ICQ.. etc.)
$showusertext = 1;                                                    # Set to 1 to display each member's personal text in the message view (by the ICQ.. etc.)
$showgenderimage = 1;                                                 # Set to 1 to display each member's gender in the message view (by the ICQ.. etc.)
$showyabbcbutt = 1;                                                   # Set to 1 to display the yabbc buttons on Posting and IM Send Pages

########## Feature Settings ##########

$enable_ubbc = 1;                                                     # Set to 1 if you want to enable UBBC (Uniform Bulletin Board Code)
$enable_news = 1;                                                     # Set to 1 to turn news on, or 0 to set news off
$allowpics = 1;                                                       # set to 1 to allow members to choose avatars in their profile
$enable_guestposting = 1;                                             # Set to 0 if do not allow 1 is allow.
$enable_notification = 1;                                             # Allow e-mail notification
$autolinkurls = 1;                                                    # Set to 1 to turn URLs into links, or 0 for no auto-linking.

$timeoffset = -1;                                                     # Time Offset (so if your server is EST, this would be set to -1 for CST)
$TopAmmount = 15;                                                     # No. of top posters to display on the top members list
$MembersPerPage = 30;                                                 # No. of members to display per page of Members List - All
$maxdisplay = 20;                                                     # Maximum of topics to display
$maxmessagedisplay = 15;                                              # Maximum of messages to display
$MaxMessLen = 5000;                                                   # Maximum Allowed Characters in a Posts
$MaxSigLen = 200;                                                     # Maximum Allowed Characters in Signatures
$ClickLogTime = 360;                                                  # Time in minutes to log every click to your forum (longer time means larger log file size)
$max_log_days_old = 21;                                               # If an entry in the user's log is older than ... days remove it
                                                                      # Set to 0 if you want it disabled
$fadertime = 5;                                                       # Length in seconds to display each item in the news fader
$timeout = 15;                                                        # Minimum time between 2 postings from the same IP


########## Membergroups ##########

$JrPostNum = 50;                                                      # Number of Posts required to show person as 'junior' membergroup
$FullPostNum = 100;                                                   # Number of Posts required to show person as 'full' membergroup
$SrPostNum = 250;                                                     # Number of Posts required to show person as 'senior' membergroup
$GodPostNum = 500;                                                    # Number of Posts required to show person as 'god' membergroup


########## MemberPic Settings ##########

$userpic_width = 65;                                                  # Set pixel size to which the selfselected userpics are resized, 0 disables this limit
$userpic_height = 65;                                                 # Set pixel size to which the selfselected userpics are resized, 0 disables this limit
$userpic_limits = qq~Please note that your image has to be <b>gif</b> or <b>jpg</b> and that it will be resized!~;
                                                                      # Text To Describe The Limits


########## File Locking ##########

$LOCK_EX = 2;                                                         # You can probably keep this as it is set now.
$LOCK_UN = 8;                                                         # You can probably keep this as it is set now.
$LOCK_SH = 1;                                                         # You can probably keep this as it is set now.

$use_flock = 1;                                                       # Set to 0 if your server doesn't support file locking,
                                                                      # 1 for Unix/Linux and WinNT, and 2 for Windows 95/98/ME

$usetempfile = 1;                                                     # Write to a temporary file when updating large files.
                                                                      # This can potentially save your board index files from
                                                                      # being corrupted if a process aborts unexpectedly.
                                                                      # 0 to disable, 1 to enable.
						
$faketruncation = 0;                                                  # Enable this option only if YaBB fails with the error:
                                                                      # "truncate() function not supported on this platform."
                                                                      # 0 to disable, 1 to enable.

1;
