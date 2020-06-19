#!/bin/bash

play-toggle() {
  local state m

  # if ssr is not running execute the script again
  # without -p option to toggle launch
  ((_ssrpid)) || exec "$0"
  state=$(getlaststate)

  [[ $state = record-start ]] \
    && m=record-pause || m=record-start

  msg "$m"

}
