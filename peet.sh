#!/bin/bash

function get_user_info(){

echo -e "USER INFO"

echo -e "whoami  : $(whoami)"
echo -e "id      : $(id)"

groups=("docker" "lxd" "sudo" "admin" "wheel" "shadow" "root" "adm" "auth" "video" "disk" "staff")
my_id=$(id)

declare -a danger
declare -i flag
flag=0

# check for dangerous  groups.
for group in ${groups[@]}; do
 if [[ -n "$(grep -iE  ${group} <<< ${my_id} )" ]]; then
  danger+=("${group}")
  flag=1
  fi
done

if [[ $flag -eq 1 ]]; then
 echo -e "Check this groups: ${danger[@]}"
fi
}

function get_sys_info(){
 echo -e "\nSYSTEM INFO\n"
 echo -e "hostname      : $(hostname)\n"
 echo -e "timedatectl   :\n$(timedatectl)\n"
 echo -e "kernel vers   : $(uname -r)\n"
 echo -e "hardware name : $(uname -m)\n"

}

function get_etc_info(){
echo -e "/etc ENUM\n"

files=("/etc/passwd" "/etc/shadow" "/etc/hosts" "/etc/sudoers" "/etc/crontab")

for file in ${files[@]}; do

if [[ -e $file ]]; then
echo -ne "${file}: "
 if [[ -O $file ]]; then
  echo -ne "owner "
 fi
 if [[ -G $file ]];then
  echo -ne "group "
 fi
 if [[ -r $file ]]; then
  echo -ne "read "
 fi
 if [[ -w $file ]]; then
  echo -ne  "write "
 fi
  echo -ne "\n"
fi
done
}

function get_suid_sgid_info(){
echo -en '\n\nSUID & SGID Enumeration'

ignored_suid=("chfn" "gpasswd" "mount" "passwd" "ntfs-3g" "umount" "rsh-redone-rsh" "chsh" "su" "pkexec" "rsh-redone-rlogin" "fusermount3" "newgrp" "vmware-user-suid-wrapper" "sudo" "mount.cifs" "pppd" "mount.nfs" "Xorg.wrap" "polkit-agent-helper-1" "dbus-daemon-launch-helper" "ssh-keysign")
ignored_sgid=("fonts" "python2.7" "dist-packages" "site-packages" "plocate" "chage" "expiry" "wall" "dotlockfile" "crontab" "write" "ssh-agent" "unix_chkpwd" "Xorg.wrap" "utempter" "redis" "journal" "local" "mail" "journal" "postgresql" "redis" "chatscripts" "peers")

mapfile suid <<< $(find / -perm -u=s 2>/dev/null | awk -F "/" '{print $NF}' )
mapfile sgid <<< $(find / -perm -g=s 2>/dev/null | awk -F "/" '{print $NF}' )

declare -a danger_suid
declare -a danger_sgid

for bin in ${suid[@]}; do
   if [[ -z "$(grep -w ${bin} <<< ${ignored_suid[@]})" ]]; then
	danger_suid+=("${bin}")
   fi
done
for bin in ${sgid[@]}; do
   if [[ -z "$(grep -w ${bin} <<< ${ignored_sgid[@]} )" ]]; then
      danger_sgid+=("${bin}")
   fi
done

if [[ -n ${danger_suid} ]]; then
   echo -en "\nSUID:\n"
   for i in ${danger_suid[@]}; do
      echo "$i"
   done
else
   echo "No suspicious SUID..."
fi

if [[ -n ${danger_sgid} ]]; then
   echo -en "\nSGID:\n"
   for i in ${danger_sgid[@]}; do
      echo "$i"
   done
else
   echo "No suspcious SGID..."
fi
}

function get_cap_info(){
echo -en "\n\n Cap Enum\n\n"
getcap -r / 2>/dev/null

}

get_user_info
get_sys_info
get_etc_info
get_suid_sgid_info
get_cap_info
