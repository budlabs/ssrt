#!/bin/bash

main() {

  declare -ri _ssrpid _dunstid=1338
  declare -r  _confdir=${__o[config-dir]:-$SSR_CONFIG_DIR}
  declare -r  _ssrcnf="$_confdir"/settings.conf
  declare -r  _ssrsts="$_confdir"/stats
  declare -r  _infile=${__[input-file]:-$SSRT_INPUTFILE}

  _ssrpid=$(pidof simplescreenrecorder)

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
