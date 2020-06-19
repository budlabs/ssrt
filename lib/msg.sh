#!/bin/bash

msg() {
  mkdir -p "${_infile%/*}"
  echo "$*" >> "$_infile"
}
