#!/bin/bash

launch() {

  declare -i delay=${__o[delay]}
  local delevent="$_confdir/events/delay"
  local mute codec

  mkdir -p "${_infile%/*}"
  echo record-start > "$_infile"

  area "${__o[select]:+fixed}"

  # --mute -> audio_enable = false
  mute=${__o[mute]:+false}
  configmod audio_enabled "${mute:=true}"

  [[ -n ${__o[container]} ]] && {
    [[ ${__o[container]} = webm ]] && codec=vp8
    configmod container "${__o[container]}"
  }

  configmod video_codec "${__o[codec]:-${codec:-h264}}"

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
