#!/bin/bash

msg() { [[ -f $_infile ]] && echo "$*" >> "$_infile" ;}
