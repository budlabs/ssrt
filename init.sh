#!/bin/bash

declare -i ssrpid dunstid=1338

declare -i clop clod
while getopts :pd:c: o; do
  case "$o" in
    p ) clop=1 ;;
    d ) clod=$OPTARG ;;
    c ) cloc=$OPTARG ;;
    * ) ERX incorrect option abort ;;
  esac
done ; shift $((OPTIND-1))

declare -r _confdir=${cloc:-~/.ssr}
declare -r _conffile=${_confdir}/ssrt.conf
declare -r _ssrcnf="$_confdir"/settings.conf
declare -r _ssrsts="$_confdir"/stats

[[ -f "$_conffile" ]] || { createconf "$_conffile" ;}

[[ -z $savedir ]] && {
  savedir=~
  ifcmd xdg-user-dir && savedir=$(xdg-user-dir VIDEOS)
}
