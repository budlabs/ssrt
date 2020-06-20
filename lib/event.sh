#!/bin/bash

event() {
  local opf
  local trg="$_confdir/events/$1"

  opf=$(getoutputpath)
  echo "$opf"
  [[ -x $trg ]] && {
    "$trg" &
    # SSR_OUTPUTFILE=$opf "$trg" &
  }

}
