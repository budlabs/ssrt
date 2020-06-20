#!/bin/bash

stop() {

  if [[ $(getlaststate) = record-start ]]; then
    msg record-save
    event stop
    msg quit
  else
    play-toggle
  fi
  
}
