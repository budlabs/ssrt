#!/bin/bash

start() {

  ERM start

  msg record-pause

  { 

    ((_clod)) && {
      if ifcmd dunstify ; then
        while ((_clod--)); do
          dunstify -r "$_dunstid" "recording starts in $((_clod+1))"
          sleep 1
        done
        
        dunstify --close "$_dunstid"
      else
        sleep "$_clod"
      fi
    }
    
    

    < <(tail -f "$_infile") \
    > /dev/null 2>&1       \
      simplescreenrecorder --start-hidden            \
                           --settingsfile="$_ssrcnf" \
                           --statsfile="$_ssrsts"
    rm -f "${_infile:?}"
  } &
}
