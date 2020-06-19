#!/bin/bash

getlaststate() {
  [[ -f $_infile ]] \
    || ERX could not send command, no infile

  tail -n 1 "$_infile"
}
