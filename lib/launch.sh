#!/bin/bash

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
