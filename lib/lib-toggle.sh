#!/bin/bash

play-toggle() {
  local state m
  ERM play/pause

  ((_ssrpid)) || ERX ssr is not running
  state=$(getlaststate)

  [[ $state = record-start ]] \
    && m=record-pause || m=record-start

  msg "$m"

}
