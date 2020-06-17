#!/bin/bash

msg() {
  mkdir -p "${infile%/*}"
  echo "$*" >> "$infile"
}
