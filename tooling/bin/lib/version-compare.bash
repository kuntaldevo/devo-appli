#!/usr/bin/env bash
# B A S H ! ! !

# Pass in two Versions in dot notation

# If the versions are equal then return 0
# If the first one is older than the second return -1 ( ie Less Than )
# If the first one is newer than the second return 1 ( ie Greater Than )

version_compare () {

  vercomp $1 $2
  RET_VAL="$?"

  if [[ $RET_VAL == 0 ]]; then
    echo "0"
  fi
  if [[ $RET_VAL == 1 ]]; then
    echo "1"
  fi
  if [[ $RET_VAL == 2 ]]; then
    echo "-1"
  fi

}




vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}
