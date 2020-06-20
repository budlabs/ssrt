#!/bin/bash

stop() {

  local state opf choice

  state=$(getlaststate)

  if [[ $state = record-start ]]; then
    msg record-save
    event stop

    opf=$(getoutputpath)

    [[ -f $opf ]] || ERX could not find output file "$opf"
    ifcmd "$_previewcommand" || choice=Yes

    while [[ ${choice:=Maybe} = Maybe ]]; do
      eval "$_previewcommand '$opf'" > /dev/null 2>&1
      choice=$(menu -p "Save file? " Yes No Maybe New)
      : "${choice:=No}"
    done

    [[ $choice = Yes ]] && save "$opf"
    
    rm -f "$opf"
    [[ $choice = New ]] && exec "$0" 

    msg quit
  else
    play-toggle
  fi
}
