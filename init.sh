#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
ssrt - version: 2020.06.21.22
updated: 2020-06-21 by budRich
EOB
}


# environment variables
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${SSR_CONFIG_DIR:=$HOME/.ssr}"
: "${SSRT_INPUT_FILE:=/tmp/ssrt/in}"


___printhelp(){
  
cat << 'EOB' >&2
ssrt - SHORT DESCRIPTION


SYNOPSIS
--------
ssrt [--pause|-p] [--delay|-d SECONDS] [--select|-s] [--config-dir|-c DIR] [--input-file|-i FILE]
ssrt --help|-h
ssrt --version|-v

OPTIONS
-------

--pause|-p  

--delay|-d SECONDS  

--select|-s  

--config-dir|-c DIR  

--input-file|-i FILE  

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





