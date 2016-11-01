#!/bin/bash

setps3() {
    PS3="$1 [ press enter for choices ]: "
}

setmainprompt() {
    setps3 "Main menu"
}

setaddprompt() {
    setps3 "ADD USER menu"
}

setdelprompt() {
    setps3 "DEL USER menu"
}

pressenter() {
    read -p "Press enter to continue:" _tmp
}

err() {
    echo 1>&2 ${CMDNAME} error: $*
    return 1
}

msg() {
    echo ${CMDNAME} notice: $*
    return 0
}

badchoice() {
    err "Bad choice!";
    return 1
}

## ADD USER SECTION

do_add_one_user() {
    _name="$1"
    _pass="$2"

    if [ $(id -u) -eq 0 ]; then

	egrep "^$_name" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$_name exists!"
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $_pass)
		useradd -m -p $pass $_name
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi

}

do_manual_add() {
    read -p "Username:" _username
    read -sp "Passowrd:" _password
    echo
    do_add_one_user "${_username}" "${_password}"
}

do_txt_add() {
    read -p "Filename:" _filename
    [[ -z "${_filename}" ]] && return

	/usr/sbin/newusers ${_filename} && echo "Adding complete!" || echo "Error adding!"
	
}

## MENU ADD USER SECTION

do_adduser() {
    setaddprompt
    _arr_add=("Add manually [a]" "Add via TXT [f]" "return to main menu [r]" "exit program [x]")
    select add_action in "${_arr_add[@]}"
    do
        case "$REPLY" in
            a) do_manual_add ;;
            f) do_txt_add ;;
            r) return ;;
            x) exit 0 ;;
            *) badchoice ;;
        esac
        setaddprompt
    done
}


## DEL USER SECTION ##

do_del_one_user(){

	_name="$1"

   if [ $(id -u) -eq 0 ]; then

        egrep "^$_name" /etc/passwd >/dev/null

	if [ $? -eq 0 ]; then

 		/usr/sbin/userdel -r ${_name}
		egrep "^$_name" /etc/passwd >/dev/null

		if [ $? -eq 1 ]; then
			echo "User has been deleted: ${_name}"
		else
			echo "Failed to delete: ${_name}"
		fi
	else
		echo "User doesn't exist!"
		
	fi
	else "Only root may add a user to the system"
	exit 2
   fi
}

do_manual_del() {
	    read -p "Username:" _username
   	    echo
	    do_del_one_user "${_username}"
}


do_txt_del() {

	    read -p "Filename:" _filename
	    [[ -z "${_filename}" ]] && return

		for _username in `cat "${_filename}"` 
		do 
		   do_del_one_user "${_username}"

		done
		
}

## DEL USER SECTION MENU

do_deleteuser() {
        setdelprompt
    _arr_del=("Delete manually [d]" "Delete via TXT [f]" "return to main menu [r]" "exit program [x]")
    select del_action in "${_arr_del[@]}"
    do
        case "$REPLY" in
            d) do_manual_del ;;
            f) do_txt_del ;;
            r) return ;;
            x) exit 0 ;;
            *) badchoice ;;
        esac
        setaddprompt
    done
}

## README SECTION

do_help() {
echo 
echo "    \"Users Manager 0.1\" is a very simple Bash script."
echo "    It is based on \"useradd\", \"userdel\" and \"newusers\" utilities from"
echo "    \"passwd\" package (it is true for Debian-like Linux systems)."
echo "    To create text file for adding users from a multiuser list, follow"
echo "    to syntax of /etc/passwd (explained man newusers):"
echo 
echo "    username:password:userid:groupid:gecos:/home/username:/bin/sh"
echo 
echo "    You can get more information in man pages of programs listed above."
echo                                 
echo "                      Sample file for adding users:"
echo                          
echo "    username01:pasSwOrd:::New user:/home/user01:/bin/sh"
echo "    username02:PaSSworD:::New user:/home/user02:/bin/csh"
echo "    username03:paSsWoRd:::New user:/home/user03:/bin/ksh"
echo "    username06:pAsSWoRd:::New user:/home/user06:/bin/bash"
echo "    ..."
echo "    userXX:PaSswOrD::::/home/user07:/bin/zsh"
echo    
echo "                      Sample file for deleting users:"
echo                         
echo "    username01"
echo "    username02"
echo "    username03"
echo "    ..."
echo "    usernameXX "
echo
echo "                                TO-DO"
echo
echo "    1) Backup HOME_DIR deleting users;"
echo "    2) Ability for choose what will be removed from system when deleting users:"
echo "       all user files, print jobs, cron jobs or/and at jobs;"
echo "    3) Remove any SELinux user mappings for the user being deleting;"
echo "    4) Apply changes in the CHROOT_DIR directory and use configuration"
echo "       files from the CHROOT_DIR directory."  
echo
echo "    Li Vanych 2016, GNU GPL 3.0"
echo

}

## ROOT PRIVILEGES CHECK

uidcheck() {
    owner=${owner:-$(/usr/bin/id -u)}
    if [ "$owner" != "0" ]; then
        err 'You must be root'
        exit 1
    fi
}

## MAIN PROGRAM

CMDNAME=$(basename $0)
uidcheck

_arr_main=("Add user [a]" "Delete user [d]" "Help [h]" "Exit program [x]")
setmainprompt
select main_action in "${_arr_main[@]}"
do
    case "$REPLY" in
        a) do_adduser ;;
        d) do_deleteuser  ;;
	h) do_help ;;
        x) exit 0 ;;
        *) badchoice ;;
    esac
    setmainprompt
done
