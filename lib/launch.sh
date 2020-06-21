#!/bin/bash

launch() {

  declare -i del=${__o[delay]}
  local delevent="$_confdir/events/delay"
  mkdir -p "${_infile%/*}"
  echo record-start > "$_infile"

  area "${__o[select]:+fixed}"

  {

    ((del)) && {
      if [[ -x $delevent ]]; then
        PATH="${delevent%/*}/lib:$PATH" "$delevent" "$del"
      else
        sleep "$del"
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
