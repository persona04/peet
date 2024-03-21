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

get_user_info
get_sys_info
get_etc_info
