#!/bin/bash

configmod() {

  local t k v
  k=$1 v=$2

  t=$(mktemp)

  awk -F= '$1 == k {sub($2,v)};{print}' \
    k="$k" v="$v" "$_ssrcnf" > "$t"

  mv -f "$t" "$_ssrcnf"
}
