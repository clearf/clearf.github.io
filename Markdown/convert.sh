#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

JEKYLL_ROOT="/Users/clearf/Documents/repos/system-logic-jekyll"
MD_SOURCE=/Users/clearf/Google\ Drive/System-Logic\ \(shared\)/Website/published/Markdown/

# Sync image files from google drive
cp -rf /Users/clearf/Google\ Drive/System-Logic\ \(shared\)/Website/published/Markdown/*_images ${JEKYLL_ROOT}/assets/images/

curdir="`pwd`"

cd ${MD_SOURCE}
for file in *.md; do
  # Does this file exist?
  if [ ! -f "$file" ]; then
    continue; 
  fi

  # Get header information
  header=$(head -n 1 "$file")
  # If there is no header, then continue
  if [ `echo "$header" | grep -v "\|"` ]; then 
    continue; 
  fi
  title=$( echo $header | awk -F '|' '{print $1}' | awk -F ':' '{print $1}')
  subtitle=$( echo $header | awk -F '|' '{print $1}' | awk -F ':' '{print $2}' | sed 's/^ *//')
  date=$( echo $header | awk -F '|' '{print $2}' | awk -F ' ' '{print $1}')
  time=$( echo $header | awk -F '|' '{print $2}' | awk -F ' ' '{print $2}')
  author=$( echo $header | awk -F '|' '{print $3}')
  tags=$( echo $header | awk -F '|' '{print $4}' | sed 's/, */,/g')

  # Modfy the filename for postiing
  newfile="$date-$file"

  postfile=${JEKYLL_ROOT}/_posts/commentary/$newfile 

  # If the post file is newer then we assume that edits have been made in place
  # and don't update, but print a warning. 
  if [ $postfile -nt $file ]; then  # || [! -f $postfile ]; then 
    echo "Not updating `basename "$postfile"`. Newer than source file."
    continue;
  fi

sed -e 1d \
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
---' "$file" > "$postfile"

  if [ ! -z "$subtitle" ]; then 
    sed -i '' -e '3i \
    subtitle: '"\"$subtitle\"" "$postfile"
  fi

  if [ ! -z "$time" ]; then 
    sed -i '' -e '3i \
    date: '"\"$date $time\"" "$postfile"
  fi

  echo "Posting $newfile"
done

IFS=$SAVEIFS
cd "$curdir"
