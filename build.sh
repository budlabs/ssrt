#!/bin/bash

_source=$(readlink -f "${BASH_SOURCE[0]}")
_dir=${_source%/*}

redel='#@@DELETE[[:space:]]*$'
resrc='#@@SOURCE[[:space:]](.+)$'
output="${_dir}/${_dir##*/}.sh"

while IFS= read -r line ; do
  [[ $line =~ $redel ]] && continue
  if [[ $line =~ $resrc ]]; then
    arg=${BASH_REMATCH[1]}

    if [[ -z $arg ]]; then
      continue
    elif [[ -d $_dir/$arg ]]; then
      for f in "$_dir/$arg/"* ; do
        cat "$f"
      done | grep -v '^#!'
    elif [[ -f $_dir/$arg ]]; then
      cat "$_dir/$arg" | grep -v '^#!'
    fi
  else
    echo "$line"
  fi
done < "$_dir/main.sh" > "$output"
[[ -f "$output" ]] && chmod +x "$output"

