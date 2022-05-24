#!/bin/bash

launch() {

  declare -i delay=${_o[delay]}
  local delevent="$_confdir/events/delay"
  local mute codec

  mkdir -p "${_infile%/*}"
  echo record-start > "$_infile"

  area "${_o[select]:+fixed}"

  # --mute -> audio_enable = false
  mute=${_o[mute]:+false}
  configmod audio_enabled "${mute:=true}"

  [[ -n ${_o[container]} ]] && {
    [[ ${_o[container]} = webm ]] && codec=vp8
    configmod container "${_o[container]}"
  }

  configmod video_codec "${_o[codec]:-${codec:-h264}}"

  {

    ((delay)) && {
      if [[ -x $delevent ]]; then
        PATH="${delevent%/*}/lib:$PATH" "$delevent" "$delay"
      else
        sleep "$delay"
      fi
    }

    event start

    < <(tail -f "$_infile") \
    > /dev/null 2>&1        \
      simplescreenrecorder --start-hidden            \
                           --settingsfile="$_ssrcnf" \
                           --statsfile="$_ssrsts"
    rm -f "${_infile:?}"
  } &
}
