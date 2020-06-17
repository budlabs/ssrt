#!/bin/bash

declare -i ssrpid clop clod dunstid=1338

declare -r infile=/tmp/ssrt/in
declare -r ssrcnf=~/.ssr/settings.conf
declare -r ssrsts=~/.ssr/stats
declare -r previewcommand=mpv

declare defaultname

defaultname=$(date +%y%m%d%-H:%M:%S)

declare savedir

[[ -z $savedir ]] && {
  savedir=~
  command -v xdg-user-dir >/dev/null \
    && savedir=$(xdg-user-dir VIDEOS)
}

menus=(i3menu dmenu rofi)

while getopts :pd: o; do
  case "$o" in
    p ) clop=1 ;;
    d ) clod=$OPTARG ;;
    * ) ERX incorrect option abort ;;
  esac
done ; shift $((OPTIND-1))
