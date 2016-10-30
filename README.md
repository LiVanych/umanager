    "Users Manager 0.1" is a very simple Bash-script.

    It based on "useradd", "userdel" and "newusers" utilities from
    "passwd" package (it truth for Debian-like Linux systems).

    Creating text file for adding users from multiuser list, follow
    to syntax of /etc/passwd file, as it says in man of "newusers":

    username:password:userid:groupid:gecos:/home/username:/bin/sh

    More help you can get from manual pages of programs listed above.

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
                                
                                TO DO

    1) Backup HOME_DIR before deleting of users;
    
    2) Choice what will be remove from system after users are deleted:
       all users files, print jobs, cron jobs or/and at jobs;
       
    3) Remove any SELinux user mapping for the deleting user's login;
    
    4) Apply changes in the CHROOT_DIR directory and use the configuration
       files from the CHROOT_DIR directory.
