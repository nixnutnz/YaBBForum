##################################################
#                                                #
#         WELCOME TO YABB 3.0 RELEASE         #
#                                                #
##################################################


**************************************************
PLEASE READ THE FOLLOWING IMPORTANT INFORMATION
**************************************************

    This version is the latest Stable release!


**************************************************
INSTALLATION NOTES
**************************************************

    Setup.pl is the way to install YaBB ....

    If you host with PerlHost.nz you can ignore step 1, simply upload your files and go have a rest, every hour our server sets up everything you need, changes owner and permissions, you don't even need to chmod the .pl files, it's all done for you!!!
    
    1)  Upload either as a zip & extract on the server (preferred method) or upload files as described in Quick-Guide/English/install/2.html
    change owner & group to apache:yourusername on EL & www-data:yourusername on Debian,
    you shouldn't need to chmod your files but if the .pl files aren't 755 then change as stated in the Quick-Guide.
    If you are unable to change owner, you must CHMOD directories; Variables, Members, Messages, Boards, Backups, Languages to 775 recursively & Paths.pm to 664.

    2)  Next, setup a fresh YaBBForum 3.0 forum by executing Setup.pl from your web browser.

    3)  If converting previous version, run Setup.pl again, and follow the instructions on the web page before proceeding,
    however this not recomended. The best way to upgrade is explained in the file UPGRADING.txt

    4)  The default administrator username is admin & password is "admin", change the password after reading the README post in your new forum.

    5)  Remove Setup files when installation is complete from in your Admin.
