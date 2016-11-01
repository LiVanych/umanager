    "Users Manager 0.1" is a very simple Bash script.

    It is based on "useradd", "userdel" and "newusers" utilities from
    "passwd" package (it is true for Debian-like Linux systems).

    To create a text file for adding users from a multiuser list, follow
    to syntax of /etc/passwd (explained in man newusers):

    username:password:userid:groupid:gecos:/home/username:/bin/sh

    You can find more information in man pages of programs listed above.

                               Examples
                                
                      Sample file for adding users:
                         
    username01:pasSwOrd:::New user:/home/user01:/bin/sh
    username02:PaSSworD:::New user:/home/user02:/bin/bash
    username03:paSsWoRd:::New user:/home/user03:/bin/ksh
    username04:PASSword:::New user:/home/user04:/bin/csh
    ...
    usernameXX:PaSswOrD::::/home/user07:/bin/zsh
    
                      Sample file for deleting users:
                         
    username01
    username02
    ...
    usernameXX
                                
                                TO-DO

    1) Backup HOME_DIR before deleting users;
    
    2) Abillity for choose what will be removed from system when deleting
       users: all user files, print jobs, cron jobs or/and at jobs;
       
    3) Remove any SELinux user mappings for the user being deleted;
    
    4) Apply changes in the CHROOT_DIR directory and use configuration
       files from the CHROOT_DIR directory.
