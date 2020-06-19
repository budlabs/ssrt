#!/bin/bash

getoutputpath() {

  # in config (_ssrcnf) get directory
  # file=/home/bud/ssrop.mkv
  # in stats file (_ssrsts) get filename
  # file_name  ssrop-2020-06-16_19.24.43.mkv
  
  awk '

    /^file=/ { gsub(/^file=|[^/]+$/,"")    ; dir=$0 }
    /^file_name/ { gsub(/^file_name\s+/,""); fil=$0 }

    END { print dir fil }

  ' "$_ssrcnf" "$_ssrsts"
}
