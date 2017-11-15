#!/bin/bash


# development repo (current)

source="$(pwd)"

# the live repository you push to

build="$1"

# ============= BUILD =================

cd "$build"

perl "$source/oikumena.pl" >build.json \
  && cp -Rf "$source/oikumena/public" "$build/." \
  && echo "OK"

# =========== GIT PUSH ================

#git add .

#git commit -m "$(date)"

#git push origin master
