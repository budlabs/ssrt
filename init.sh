#!/bin/bash

declare -i _ssrpid _dunstid=1338

declare -i _clop _clod
while getopts :pd:c: o; do
  case "$o" in
    p ) _clop=1 ;;
    d ) _clod=$OPTARG ;;
    c ) _cloc=$OPTARG ;;
    * ) ERX incorrect option abort ;;
  esac
done ; shift $((OPTIND-1))

declare -r _confdir=${_cloc:-~/.ssr}
declare -r _conffile=${_confdir}/ssrt.conf
declare -r _ssrcnf="$_confdir"/settings.conf
declare -r _ssrsts="$_confdir"/stats

_ssrpid=$(pidof simplescreenrecorder)

[[ -f "$_conffile" ]] || { createconf "$_conffile" ;}
parseconf "$_conffile"

[[ -z $_savedir ]] && _savedir=~ \
  && ifcmd xdg-user-dir          \
  && _savedir=$(xdg-user-dir VIDEOS)
