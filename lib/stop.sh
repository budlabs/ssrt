#!/bin/bash

stop() {

  local state opf choice

  state=$(getlaststate)

  if [[ $state = record-start ]]; then
    msg record-save
    event stop
    msg quit
  else
    play-toggle
  fi
}
