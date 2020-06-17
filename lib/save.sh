#!/bin/bash

save() {
  local f=$1
  declare -i validpath

  until ((validpath)); do

    path=$(menu -p "Save as: " -f "${savedir/~/'~'}")
    path=${path/'~'/~}

    [[ -z $path ]] && {
      confirm=$(menu -p "Delete $f ? " No Yes)
      [[ $confirm = Yes ]] && return
    }

    [[ ${path} =~ ^/ ]] && validpath=1
  done

  [[ -d $path ]] && path+=/$defaultname

  [[ $path =~ .+[^/]+([.].+)$ ]] && path=${path%.*}
  mkdir -p "${path%/*}"

  mv "$f" "$path"."${f##*.}"
}
