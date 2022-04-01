#!/bin/bash

event() {
  local opf
  local trg="$_confdir/events/$1"

  opf=$(getoutputpath)

  [[ -x $trg ]] && (
    SSR_OUTPUTFILE="${opf:-}"          \
    PATH="$_confdir/events/lib:$PATH"  \
    exec "$trg"
  )
}
