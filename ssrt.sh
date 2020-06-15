#!/bin/bash

declare -i ssrpid clop clod dunstid=1338
declare -r infile=/tmp/ssrt/in

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

stop() {
  ERM stop
  msg quit
}

preview() {
  ERM preview
}

save() {
  ERM save
}

play-toggle() {
  local state m
  ERM play/pause

  ((ssrpid)) || ERX ssr is not running
  [[ -f $infile ]] || ERX could not send command, no infile

  state=$(tail -n 1 "$infile")

  [[ $state = record-start ]] \
    && m=record-pause || m=record-start

  msg "$m"

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
      simplescreenrecorder --start-hidden
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
