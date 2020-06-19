#!/bin/bash

main() {

  if ((_clop)); then
    play-toggle
  elif ((_ssrpid)); then
    stop
  else
    start
  fi

}

_source=$(readlink -f "${BASH_SOURCE[0]}") #@@DELETE
_dir=${_source%/*}                         #@@DELETE

for f in "$_dir/lib/"* ; do source "$f" ; done #@@SOURCE lib
unset f                                        #@@DELETE
source "$_dir/init.sh"                         #@@SOURCE init.sh

main "$@"