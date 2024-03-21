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


get_user_info
