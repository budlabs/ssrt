#!/bin/bash

stop() {

  if [[ $(getlaststate) = record-start ]]; then
    msg record-save
    # delay quit to make sure event can get
    # fullpath from statsfile, which gets
    # deleted when recording stops
    { sleep .2 ; msg quit ;} &
    event stop
  else
    play-toggle
  fi
  
}
