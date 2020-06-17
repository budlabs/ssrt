#!/bin/bash

preview() {
  local f=$1

  eval "$previewcommand '$f'" > /dev/null 2>&1

  menu -p "Save file? " Yes No Maybe New
}
