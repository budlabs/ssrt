#!/usr/bin/env bash

___printversion(){
  
cat << 'EOB' >&2
ssrt - version: 2020.06.19.42
updated: 2020-06-19 by budRich
EOB
}


# environment variables
: "${XDG_CONFIG_HOME:=$HOME/.config}"


___printhelp(){
  
cat << 'EOB' >&2
ssrt - SHORT DESCRIPTION


SYNOPSIS
--------
ssrt [--pause|-p] [--delay|-d SECONDS] [--select|-s] [--config-dir|-c DIR]
ssrt --help|-h
ssrt --version|-v

OPTIONS
-------

--pause|-p  

--delay|-d SECONDS  

--select|-s  

--config-dir|-c DIR  

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
    --options "pd:sc:hv" \
    --longoptions "pause,delay:,select,config-dir:,help,version," \
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
    --help       | -h ) ___printhelp && exit ;;
    --version    | -v ) ___printversion && exit ;;
    -- ) shift ; break ;;
    *  ) break ;;
  esac
  shift
done

[[ ${__lastarg:="${!#:-}"} =~ ^--$|${0}$ ]] \
  && __lastarg="" 





