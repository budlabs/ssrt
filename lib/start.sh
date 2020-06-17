#!/bin/bash

start() {

  ERM start

  msg record-pause

  { 

    ((clod)) && {
      if command -v dunstify >/dev/null ; then
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
