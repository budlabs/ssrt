#!/bin/bash

getlaststate() {

  [[ -f $infile ]] \
    || ERX could not send command, no infile

  tail -n 1 "$infile"

}
