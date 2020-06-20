#!/bin/bash

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
