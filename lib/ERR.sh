#!/bin/bash

set -E
trap '[ "$?" -ne 77 ] || exit 77' ERR

ERX() { >&2 echo "$*" && exit 77 ;}
ERM() { >&2 echo "$*" ;}
