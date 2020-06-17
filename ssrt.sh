#!/bin/bash

main() {
  
  ssrpid=$(pidof simplescreenrecorder)

  if ((clop)); then
    play-toggle
  elif ((ssrpid)); then
    stop
  else
    start
  fi

}



createconf() {
cat << 'EOB' > "$1"
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

# syntax:ssHash
EOB
}

set -E
trap '[ "$?" -ne 77 ] || exit 77' ERR

ERX() { >&2 echo "$*" && exit 77 ;}
ERM() { >&2 echo "$*" ;}

getlaststate() {

  [[ -f $infile ]] \
    || ERX could not send command, no infile

  tail -n 1 "$infile"

}

getoutputpath() {

  # in config find directory
  # file=/home/bud/ssrop.mkv

  # in stats file
  # file_name         ssrop-2020-06-16_19.24.43.mkv
  awk '

    /^file=/ { gsub(/^file=|[^/]+$/,"")    ; dir=$0 }
    /^file_name/ { gsub(/^file_name\s+/,""); fil=$0 }

    END { print dir fil }

  ' "$ssrcnf" "$ssrsts"
}

ifcmd() { command -v "$1" > /dev/null ;}

play-toggle() {
  local state m
  ERM play/pause

  ((ssrpid)) || ERX ssr is not running
  state=$(getlaststate)

  [[ $state = record-start ]] \
    && m=record-pause || m=record-start

  msg "$m"

}

menu() {

  local m o prompt OPTARG OPTIND
  
  for m in "${menus[@]}"; do
    ifcmd "$m" && break
    unset m
  done

  while getopts :p:f: o; do
    [[ $o = p ]] && prompt=$OPTARG
    [[ $o = f ]] && filter=$OPTARG
  done ; shift $((OPTIND-1))

  case "$m" in
    dmenu  ) "$m" -p "$prompt" ;;
    rofi   ) "$m" -dmenu -p "$prompt" -filter "$filter" ;;
    i3menu ) "$m" -p "$prompt" -f "$filter" ;;
    *      ) ERX cannot find menu command ;;
  esac < <(printf "%s${1:+\n}" "${@}")
}

msg() {
  mkdir -p "${infile%/*}"
  echo "$*" >> "$infile"
}

preview() {
  local f=$1

  eval "$previewcommand '$f'" > /dev/null 2>&1

  menu -p "Save file? " Yes No Maybe New
}

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

start() {

  ERM start

  msg record-pause

  { 

    ((clod)) && {
      if ifcmd dunstify ; then
        while ((clod--)); do
          dunstify -r "$dunstid" "recording starts in $((clod+1))"
          sleep 1
        done
        
        dunstify --close "$dunstid"
      else
        sleep "$clod"
      fi
    }
    
    

    < <(tail -f "$infile") \
    > /dev/null 2>&1       \
      simplescreenrecorder --start-hidden           \
                           --settingsfile="$ssrcnf" \
                           --statsfile="$ssrsts"
    rm -f "${infile:?}"
  } &
}

stop() {

  local state opf choice

  ERM stop

  state=$(getlaststate)

  if [[ $state = record-start ]]; then
    msg record-save

    opf=$(getoutputpath)

    [[ -f $opf ]] || ERX could not find output file "$opf"
    ifcmd "$previewcommand" || choice=Yes

    while [[ ${choice:=Maybe} = Maybe ]]; do
      choice=$(preview "$opf")
      : "${choice:=No}"
    done

    [[ $choice = Yes ]] && save "$opf"
    
    rm -f "$opf"
    [[ $choice = New ]] && exec "$0" 

    msg quit
  else
    play-toggle
  fi
}

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
declare -r ssrcnf="$_confdir"/settings.conf
declare -r ssrsts="$_confdir"/stats

[[ -f "$_conffile" ]] || {
  createconf "$_conffile"
}

[[ -z $savedir ]] && {
  savedir=~
  ifcmd xdg-user-dir && savedir=$(xdg-user-dir VIDEOS)
}

main "$@"
