#!/bin/sh

source="${HOME}/.local/src/upheads"
report="${HOME}/.local/src/git-report-$(date -d yesterday +%Y-%m-%d).txt"

for d in ${source} ; do
  if [ -d "$d/.git" ]; then
    echo "=== $d ===" >> "${report}"
    (cd "$d" && git log --since="yesterday 00:00" --until="yesterday 23:59" --committer="oliver.sakkestad@upheads.no" --pretty=format:"%s" >> "${Report}")
    echo >> "${report}"
  fi
done
