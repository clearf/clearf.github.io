#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for file in *.md
do
  header=$(head -n 1 "$file")
  title=$( echo $header | awk -F '|' '{print $1}' | awk -F ':' '{print $1}')
  subtitle=$( echo $header | awk -F '|' '{print $1}' | awk -F ':' '{print $2}' | sed 's/^ *//')
  date=$( echo $header | awk -F '|' '{print $2}' | awk -F ' ' '{print $1}')
  author=$( echo $header | awk -F '|' '{print $3}')
  tags=$( echo $header | awk -F '|' '{print $4}' | sed 's/, */,/g')

  newfile="$date-$file"
  echo $date-"$file"
  mv "$file" "$newfile"
  file="$newfile"

sed -i '.bak' -e 1d \
-e '2i\
---' \
-e '2i \
title: '"\"$title\"" \
-e '2i \
layout: post' \
-e '2i \
author: '"\"$author\" " \
-e '2i \
tags: '"[$tags] " \
-e '2i \
permalink: ' \
-e '2i \
---' "$file"

  if [ -z "$subtitle" ]; then 
    sed -i '.bak2' -e '2i \
    subtitle: '"\"$subtitle\"" "$file"
  fi

done
IFS=$SAVEIFS
