#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
ssrt - version: 2020.06.20.16
updated: 2020-06-20 by budRich
EOB
}


# environment variables
: "${XDG_CONFIG_HOME:=$HOME/.config}"


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

___printhelp(){
  
cat << 'EOB' >&2
ssrt - SHORT DESCRIPTION


SYNOPSIS
--------
ssrt [--pause|-p] [--delay|-d SECONDS] [--select|-s] [--config-dir|-c DIR]
ssrt --help|-h
ssrt --version|-v

OPTIONS
-------

--pause|-p  

--delay|-d SECONDS  

--select|-s  

--config-dir|-c DIR  

--help|-h  
Show help and exit.


--version|-v  
Show version and exit.
EOB
}


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
    $1 == "video_area" {sub($2,mode)}
    $1 == "video_h"    {sub($2,h)}
    $1 == "video_w"    {sub($2,w)}
    $1 == "video_x"    {sub($2,x)}
    $1 == "video_y"    {sub($2,y)}
    {print}
  ' w="$w" h="$h" x="$x" y="$y" mode="$mode" "$_ssrcnf" > "$t"

  mv -f "$t" "$_ssrcnf"
}

createconf() {
local trgdir="$1"
declare -a aconfdirs

aconfdirs=(
"$trgdir/events"
)

mkdir -p "$1" "${aconfdirs[@]}"

cat << 'EOCONF' > "$trgdir/events/stop"

opf=$SSR_OUTPUTFILE
notify-send "i stopped $opf"


# [[ -f $opf ]] || ERX could not find output file "$opf"
# ifcmd "$_previewcommand" || choice=Yes

# while [[ ${choice:=Maybe} = Maybe ]]; do
#   eval "$_previewcommand '$opf'" > /dev/null 2>&1
#   choice=$(menu -p "Save file? " Yes No Maybe New)
#   : "${choice:=No}"
# done

# [[ $choice = Yes ]] && save "$opf"

# rm -f "$opf"
# [[ $choice = New ]] && exec "$0"
EOCONF

chmod +x "$trgdir/events/stop"
cat << 'EOCONF' > "$trgdir/events/resume"

echo i resumed
EOCONF

chmod +x "$trgdir/events/resume"
cat << 'EOCONF' > "$trgdir/events/start"

notify-send "im starting"
EOCONF

chmod +x "$trgdir/events/start"
cat << 'EOCONF' > "$trgdir/events/pause"

echo i paused
EOCONF

chmod +x "$trgdir/events/pause"
cat << 'EOCONF' > "$trgdir/ssrt.conf"
# when a ssr command (f.i. record-start) 
# is appended to infile while ssr is running
# it will get executed
infile = /tmp/ssrt/in

# 'command' that will be used to preview recording
# if command is not found, preview is skipped
# and save action is asumed.
previewcommand = mpv

# when saving a recording, if only a tartget
# directory is specified, use this default name.
defaultname = testdef

# if timeformat `date(1)` is specified and if only
# a tartget directory is specified,  append
# timestamp to saved file
timeformat = %y%m%d%-H:%M:%S

# default directory to save recording
# if not set either XDG_USER_VIDEOS or HOME will
# be used. Another location can be specied in menu
# when a file is about to be saved.
savedir =

# comma separated list of menu commands to try
# when a menu is needed
menus = i3menu,dmenu,rofi

# if set this command will get evaluated when a menu
# is needed. 
# %f will be replaced with filter string.
# %p will be replaced with prompt string.
# custommenu = rofi -dmenu -p '%p' -filter '%f'
custommenu =

# syntax:ssHash
EOCONF

}

set -E
trap '[ "$?" -ne 77 ] || exit 77' ERR

ERX() { >&2 echo "$*" && exit 77 ;}
ERM() { >&2 echo "$*" ;}

event() {
  local opf
  local trg="$_confdir/events/$1"

  opf=$(getoutputpath)

  [[ -x $trg ]] && (
    SSR_OUTPUTFILE="${opf:-}"          \
    PATH="$_confdir/events/lib:$PATH"  \
    exec "$trg"
  )
}

getlaststate() {
  [[ -f $_infile ]] \
    || ERX could not send command, no infile

  tail -n 1 "$_infile"
}

getoutputpath() {

  # in config (_ssrcnf) get directory
  # file=/home/bud/ssrop.mkv
  # in stats file (_ssrsts) get filename
  # file_name  ssrop-2020-06-16_19.24.43.mkv
  
  [[ -f $_ssrsts ]] && awk '

    /^file=/ { gsub(/^file=|[^/]+$/,"")    ; dir=$0 }
    /^file_name/ { gsub(/^file_name\s+/,""); fil=$0 }

    END { print dir fil }

  ' "$_ssrcnf" "$_ssrsts"
}

ifcmd() { command -v "$1" > /dev/null ;}

launch() {

  declare -i del=${__o[delay]}
  echo record-start > "$_infile"

  area "${__o[select]:+fixed}"

  {
    ((del)) && {
      if ifcmd dunstify ; then
        while ((del--)); do
          dunstify -r "$_dunstid" "recording starts in $((del+1))"
          sleep 1
        done
        
        dunstify --close "$_dunstid"
      else
        notify-send --expire-time "$del" \
          "recording delayed $del seconds."
        sleep "${del}"
      fi
    }

    event start

    < <(tail -f "$_infile") \
    > /dev/null 2>&1        \
      simplescreenrecorder --start-hidden            \
                           --settingsfile="$_ssrcnf" \
                           --statsfile="$_ssrsts"
    rm -f "${_infile:?}"
  } &
}

msg() {
  mkdir -p "${_infile%/*}"
  echo "$*" >> "$_infile"
}

parseconf() {

  local re sp gr
  sp='[[:space:]]' gr='[[:graph:]]'
  re="^${sp}*(${gr}+)${sp}*=${sp}*(.+)\$"

  # default config values:
  declare -g  _infile=/tmp/ssrt/in
  declare -g  _previewcommand=mpv
  declare -g  _defaultname=testdef
  declare -g  _timeformat='%y%m%d%-H:%M:%S'
  declare -g  _savedir=
  declare -g  _custommenu=
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
        custommenu     ) _custommenu=$val        ;;
        menus) mapfile -td, _menus <<< "$val" ;;
        *              ) continue             ;;
      esac
    }
  done < "$1"
}

play-toggle() {
  local state

  # if ssr is not running execute the script again
  # without -p option to toggle launch
  ((_ssrpid)) || exec "$0"
  state=$(getlaststate)

  if [[ $state = record-start ]]; then
    msg record-pause
    event pause
  else
    msg record-start
    event resume
  fi

}

stop() {

  local state opf choice

  state=$(getlaststate)

  if [[ $state = record-start ]]; then
    msg record-save
    event stop
    msg quit
  else
    play-toggle
  fi
}

declare -A __o
options="$(
  getopt --name "[ERROR]:ssrt" \
    --options "pd:sc:hv" \
    --longoptions "pause,delay:,select,config-dir:,help,version," \
    -- "$@" || exit 77
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --pause      | -p ) __o[pause]=1 ;; 
    --delay      | -d ) __o[delay]="${2:-}" ; shift ;;
    --select     | -s ) __o[select]=1 ;; 
    --config-dir | -c ) __o[config-dir]="${2:-}" ; shift ;;
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 


main "${@:-}"


