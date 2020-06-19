#!/bin/bash

stop() {

  local state opf choice

  ERM stop

  state=$(getlaststate)

  if [[ $state = record-start ]]; then
    msg record-save

    opf=$(getoutputpath)

    [[ -f $opf ]] || ERX could not find output file "$opf"
    ifcmd "$_previewcommand" || choice=Yes

    while [[ ${choice:=Maybe} = Maybe ]]; do
      choice=$(preview "$opf")
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
