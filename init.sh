#!/bin/bash

___printversion(){
  
cat << 'EOB' >&2
ssrt - version: 2020.06.22.20
updated: 2020-06-22 by budRich
EOB
}


# environment variables
: "${SSR_CONFIG_DIR:=$HOME/.ssr}"
: "${SSRT_INPUT_FILE:=/tmp/ssrt/in}"


___printhelp(){
  
cat << 'EOB' >&2
ssrt - simplescreenreocrder - now even simpler


SYNOPSIS
--------
ssrt [--pause|-p] [--delay|-d SECONDS] [--select|-s] [--config-dir|-c DIR] [--input-file|-i FILE]
ssrt --help|-h
ssrt --version|-v

OPTIONS
-------

--pause|-p  
Toggle play/pause of an ongoing recording or
start a new recording if there is none.


--delay|-d SECONDS  
Adds a delay in SECONDS (sleep) before starting a
new recording. Has no effect when stopping a
recording or toggling play/pause. This will also
trigger the delay event and pass SECONDS as the
first argument.


--select|-s  
Execute slop(1) before starting a recording for
selection of area to record. Without this option
the full active monitor will be recorded.


--config-dir|-c DIR  
Override the environment variable SSR_CONFIG_DIR.
Defaults to ~/.ssr . This will be the directory
where the statsfile, configfile and events
directory will be stored and created.


--input-file|-i FILE  
Override the environment variable
SSRT_INPUT_FILE. Defaults to /tmp/ssrt/in .
Commands can be appended to this file while the
recording is running.  
echo record-pause > /tmp/ssrt/in . See simplescreenrecorder man page or --help for list of available commands.

--help|-h  
Show help and exit.


--version|-v  
Show version and exit.

EOB
}


for ___f in "${___dir}/lib"/*; do
  source "$___f"
done

declare -A __o
options="$(
  getopt --name "[ERROR]:ssrt" \
    --options "pd:sc:i:hv" \
    --longoptions "pause,delay:,select,config-dir:,input-file:,help,version," \
    -- "$@" || exit 77
)"

eval set -- "$options"
unset options

while true; do
  case "$1" in
    --pause      | -p ) __o[pause]=1 ;; 
    --delay      | -d ) __o[delay]="${2:-}" ; shift ;;
    --select     | -s ) __o[select]=1 ;; 
    --config-dir | -c ) __o[config-dir]="${2:-}" ; shift ;;
    --input-file | -i ) __o[input-file]="${2:-}" ; shift ;;
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 





