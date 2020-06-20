#!/bin/bash

getlaststate() {
  [[ -f $_infile ]] \
    || ERX could not get state, no input-file

  tail -n 1 "$_infile"
}
