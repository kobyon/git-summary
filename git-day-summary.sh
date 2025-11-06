#!/bin/sh

source="${HOME}/.local/src/upheads/"
report="./git-report-$(date -d yesterday +%Y-%m-%d).txt"
committer_email="oliver.sakkestad@upheads.no"
since="today 00:00"
until="today 23:59"

for d in "${source}"/* ; do
  if [ -d "${d}/.git" ]; then
    echo "=== ${d} ===" >> "${report}"

    git --no-pager --git-dir="${d}/.git" --work-tree="${d}" log \
    --since="${since}" \
    --until="${until}" \
    --author="${committer_email}" \
    --pretty=format:"%s"

    echo >> "${report}"
  fi
done
