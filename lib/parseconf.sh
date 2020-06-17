#!/bin/bash

parseconf() {

  local re sp gr
  sp='[[:space:]]'
  gr='[[:graph:]]'
  re="^${sp}*(${gr}+)${sp}*=${sp}*(.+)\$"

  # default config values:
  declare -g  _infile=/tmp/ssrt/in
  declare -g  _previewcommand=mpv
  declare -g  _defaultname=testdef
  declare -g  _timeformat='%y%m%d%-H:%M:%S'
  declare -g  _savedir=
  declare -ga _menus=(i3menu dmenu rofi)

  while IFS= read -r line ;do
    [[ $line =~ $re ]] && {
      key=${BASH_REMATCH[1]}
      val=${BASH_REMATCH[2]}

      case "$key" in
        infile         ) _infile=$val         ;;
        previewcommand ) _previewcommand=$val ;;
        defaultname    ) _defaultname=$val    ;;
        timeformat     ) _timeformat=$val     ;;
        savedir        ) _savedir=$val        ;;
        menus) mapfile -td, _menus <<< "$val" ;;
        *              ) continue             ;;
      esac
    }
  done < "$1"
}
