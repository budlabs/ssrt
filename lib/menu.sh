#!/bin/bash

menu() {

  local m o prompt OPTARG OPTIND
  
  for m in "${_menus[@]}"; do
    ifcmd "$m" && break
    unset m
  done

  while getopts :p:f: o; do
    [[ $o = p ]] && prompt=$OPTARG
    [[ $o = f ]] && filter=$OPTARG
  done ; shift $((OPTIND-1))

  if [[ -n $_custommenu ]]; then
    _custommenu=${_custommenu//%p/$prompt}
    _custommenu=${_custommenu//%f/$filter}
    m=CUSTOMMENU
  fi


  case "$m" in
    CUSTOMMENU  ) eval "$_custommenu" ;;
    dmenu  ) "$m" -p "$prompt" ;;
    rofi   ) "$m" -dmenu -p "$prompt" -filter "$filter" ;;
    i3menu ) "$m" -p "$prompt" -f "$filter" ;;
    *      ) ERX cannot find menu command ;;
  esac < <(printf "%s${1:+\n}" "${@}")
}
