#!/bin/bash

main() {

  declare -i _ssrpid _dunstid=1338
  declare -r _confdir=${__o[config-dir]:-~/.ssr}
  declare -r _conffile=${_confdir}/ssrt.conf
  declare -r _ssrcnf="$_confdir"/settings.conf
  declare -r _ssrsts="$_confdir"/stats

  _ssrpid=$(pidof simplescreenrecorder)

  [[ -f "$_conffile" ]] || { createconf "$_confdir" ;}
  parseconf "$_conffile"

  [[ -z $_savedir ]] && _savedir=~ \
    && ifcmd xdg-user-dir          \
    && _savedir=$(xdg-user-dir VIDEOS)

  if ((__o[pause])); then
    play-toggle
  elif ((_ssrpid)); then
    stop
  else
    launch
  fi

}

___source=$(readlink -f "${BASH_SOURCE[0]}")      #bashbud
___dir=${___source%/*}                            #bashbud
source "$___dir/init.sh"                          #bashbud
main "$@"                                         #bashbud
