#!/bin/bash

area() {
  local re mode=$1
  local am # active monitor (1920/520x1080/290+0+0)
  local frm='%w/000x%h/000+%x+%y'

  if [[ $mode = fixed ]]; then
    am=$(slop --format "$frm")
  else
    mode=screen
    am=$(xrandr --listactivemonitors | awk '/[*]/ {print $3}')
  fi

  re='^([^/]+)/.+x([^/]+)/[^-+]+([-+][^-+]+)([-+][^-+]+)'

  [[ $am =~ $re ]] && {
    w=${BASH_REMATCH[1]}
    h=${BASH_REMATCH[2]}
    x=${BASH_REMATCH[3]}
    y=${BASH_REMATCH[4]}
  }

  t=$(mktemp)

  awk -F= '
    $1 == "video_area" {sub($2,m)}
    $1 == "video_h"    {sub($2,h)}
    $1 == "video_w"    {sub($2,w)}
    $1 == "video_x"    {sub($2,x)}
    $1 == "video_y"    {sub($2,y)}
    {print}
  ' w="$w" h="$h" x="$x" y="$y" m="$mode" "$_ssrcnf" > "$t"

  mv -f "$t" "$_ssrcnf"
}
