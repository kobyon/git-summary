#!/bin/sh

source="${HOME}/.local/src/upheads"
report="${HOME}/.local/src/git-report-$(date -d yesterday +%Y-%m-%d).txt"
committer_email="oliver.sakkestad@upheads.no"
since="yesterday 00:00"
until="yesterday 23:59"

for d in ${source} ; do
  if [ -d "$d/.git" ]; then
    echo "=== $d ===" >> "${report}"
    (cd "$d" && git log --since="${since}" --until="${until}" --committer="${committer_email}" --pretty=format:"%s" >> "${report}")
    echo >> "${report}"
  fi
done
