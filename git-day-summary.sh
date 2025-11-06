#!/bin/sh

Source="${HOME}/.local/src/upheads"
Report="${HOME}/.local/src/git-report-$(date -d yesterday +%Y-%m-%d).txt"

for d in ${Source} ; do
  if [ -d "$d/.git" ]; then
    echo "=== $d ===" >> "${Report}"
    (cd "$d" && git log --since="yesterday 00:00" --until="yesterday 23:59" --committer="oliver.sakkestad@upheads.no" --pretty=format:"%s" >> "${Report}")
    echo >> "${Report}"
  fi
done
