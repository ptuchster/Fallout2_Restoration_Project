#!/bin/bash

set -xeu -o pipefail

# release?
if [ -n "$TRAVIS_TAG" ]; then # tag found: releasing
  version="$TRAVIS_TAG"

  # data
  dat="$mods_dir/$mod_name.dat"
  mkdir -p "$mods_dir"
  chmod 0444 data/proto/*/*

  # I don't know how to pack recursively
  for f in $(find data -type f | sed 's|\/|\\|g' | sort); do # replace slashes with backslashes
    WINEARCH=win32 WINEDEBUG=-all wine "$bin_dir/dat.exe" a $dat "$f"
  done

  # sfall
  sfall_url="https://sourceforge.net/projects/sfall/files/sfall/sfall_$sfall_version.7z/download"
  wget -q "$sfall_url" -O sfall.7z
  7z e sfall.7z ddraw.dll
  cp extra/sfall/ddraw.ini .
  zip "${mod_name}_${version}.zip" ddraw.dll ddraw.ini "$mods_dir/" # our package
fi
