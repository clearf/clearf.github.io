#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

JEKYLL_ROOT="/Users/clearf/Documents/repos/system-logic-jekyll"

# Sync files from google drive
cp ~/Google\ Drive/System-Logic\ \(shared\)/Website/published/Markdown/*.md ${JEKYLL_ROOT}/Markdown
cp -r ~/Google\ Drive/System-Logic\ \(shared\)/Website/published/Markdown/*_images ${JEKYLL_ROOT}/assets/images/

for file in *.md; do
  if [ ! -f "$file" ]; then
    continue; 
  fi
  header=$(head -n 1 "$file")

  # If there is no header, then continue
  if [ `echo "$header" | grep -v "\|"` ]; then 
    continue; 
  fi

  title=$( echo $header | awk -F '|' '{print $1}' | awk -F ':' '{print $1}')
  subtitle=$( echo $header | awk -F '|' '{print $1}' | awk -F ':' '{print $2}' | sed 's/^ *//')
  date=$( echo $header | awk -F '|' '{print $2}' | awk -F ' ' '{print $1}')
  author=$( echo $header | awk -F '|' '{print $3}')
  tags=$( echo $header | awk -F '|' '{print $4}' | sed 's/, */,/g')

  newfile="$date-$file"

  mv "$file" "$newfile"
  file="$newfile"

sed -i '' -e 1d \
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

  if [ ! -z "$subtitle" ]; then 
    sed -i '' -e '3i \
    subtitle: '"\"$subtitle\"" "$newfile"
  fi

  postfile=${JEKYLL_ROOT}/_posts/commentary/$newfile 
  if [ $newfile -nt $postfile ]; then  # || [! -f $postfile ]; then 
    echo "Posting $newfile"
    cp $newfile $postfile
  fi
done

IFS=$SAVEIFS
