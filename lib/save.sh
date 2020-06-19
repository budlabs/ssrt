#!/bin/bash

save() {
  local f=$1
  declare -i validpath

  until ((validpath)); do

    path=$(menu -p "Save as: " -f "${_savedir/~/'~'}")
    path=${path/'~'/~}

    [[ -z $path ]] && {
      confirm=$(menu -p "Delete $f ? " No Yes)
      [[ $confirm = Yes ]] && return
    }

    [[ ${path} =~ ^/ ]] && validpath=1
  done

  [[ -d $path ]] && {
    path+=/$_defaultname
    [[ -n $_timeformat ]] && path+=$(date +"$_timeformat")
  }

  # remove file extension entered by user
  [[ $path =~ .+[^/]+([.].+)$ ]] && path=${path%.*}

  # append same extension as the recorded file
  path+=".${f##*.}"

  mkdir -p "${path%/*}"

  # if target file already exist create a unique
  # filename file1.file2...
  while [[ -f $path ]]; do
    path="${path%.*}$((++i)).${f##*.}"
  done

  mv "$f" "$path"."${f##*.}"
}
