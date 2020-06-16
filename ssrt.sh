#!/bin/bash

declare -i ssrpid clop clod dunstid=1338
declare -r infile=/tmp/ssrt/in
declare -r ssrcnf=~/.ssr/settings.conf
declare -r ssrsts=~/.ssr/stats
declare -r previewcommand=mpv

menus=(i3menu dmenu rofi)

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


menu() {

  local m o prompt OPTARG OPTIND
  
  for m in "${menus[@]}"; do
    command -v "$m" > /dev/null && break
    unset m
  done

  while getopts :p: o; do
    [[ $o = p ]] && prompt=$OPTARG
  done ; shift $((OPTIND-1))

  case "$m" in
    dmenu  ) "$m" -p "$prompt" ;;
    rofi   ) "$m" -dmenu -p "$prompt" ;;
    i3menu ) "$m" -p "$prompt" ;;
    *      ) ERX cannot find menu command ;;
  esac < <(printf "%s${1:+\n}" "${@}")
}

preview() {
  local f=$1

  eval "$previewcommand '$f'" > /dev/null 2>&1

  menu -p "Save file? " Yes No Maybe New
}

stop() {

  local state opf choice

  ERM stop

  state=$(getlaststate)

  if [[ $state = record-start ]]; then
    msg record-save

    opf=$(getoutputpath)

    [[ -f $opf ]] || ERX could not find output file "$opf"
    command -v "$previewcommand" >/dev/null || choice=Yes

    while [[ ${choice:=Maybe} = Maybe ]]; do
      choice=$(preview "$opf")
    done
    
    ERM o pf "$opf"
    ERM "ccc$choice"
    exit
    msg quit
  else
    play-toggle
  fi
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


save() {
  ERM save
}

play-toggle() {
  local state m
  ERM play/pause

  ((ssrpid)) || ERX ssr is not running
  state=$(getlaststate)

  [[ $state = record-start ]] \
    && m=record-pause || m=record-start

  msg "$m"

}

getlaststate() {

  [[ -f $infile ]] \
    || ERX could not send command, no infile

  tail -n 1 "$infile"

}

start() {

  ERM start

  msg record-pause

  { 

    ((clod)) && {
      if command -v dunstifysdf >/dev/null ; then
        while ((clod--)); do
          dunstify -r $dunstid "recording starts in $((clod+1))"
          sleep 1
        done
        
        dunstify --close $dunstid
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

msg() {
  mkdir -p "${infile%/*}"
  echo "$*" >> "$infile"
}

ERX() { >&2 echo "$*" && exit 1 ;}
ERM() { >&2 echo "$*" ;}

while getopts :pd: o; do
  case "$o" in
    p ) clop=1 ;;
    d ) clod=$OPTARG ;;
    * ) ERX incorrect option abort ;;
  esac
done ; shift $((OPTIND-1))

main "$@"
















# simplescreenrecorder --help
# Usage: simplescreenrecorder [OPTIONS]

# Options:
#   --help                Show this help message.
#   --version             Show version information.
#   --settingsfile=FILE   Load and save program settings to FILE. If omitted,
#                         ~/.ssr/settings.conf is used.
#   --logfile[=FILE]      Write log messages to FILE. If FILE is omitted,
#                         ~/.ssr/log-DATE_TIME.txt is used.
#   --statsfile[=FILE]    Write recording statistics to FILE. If FILE is omitted,
#                         /dev/shm/simplescreenrecorder-stats-PID is used. It will
#                         be updated continuously and deleted when the recording
#                         page is closed.
#   --no-systray          Don't show the system tray icon.
#   --start-hidden        Start the application in hidden form.
#   --start-recording     Start the recording immediately.
#   --activate-schedule   Activate the recording schedule immediately.
#   --syncdiagram         Show synchronization diagram (for debugging).
#   --benchmark           Run the internal benchmark.

# Commands accepted through stdin:
#   record-start          Start the recording.
#   record-pause          Pause the recording.
#   record-cancel         Cancel the recording and delete the output file.
#   record-save           Finish the recording and save the output file.
#   schedule-activate     Activate the recording schedule.
#   schedule-deactivate   Deactivate the recording schedule.
#   window-show           Show the application window.
#   window-hide           Hide the application window.
#   quit                  Quit the application.
