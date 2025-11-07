#!/bin/sh

source="${HOME}/.local/src/"
committer_email="oliver.sakkestad@upheads.no"

for i in $(seq 0 6); do
  day=$(date -d "$i days ago" +%Y-%m-%d)
  since="$day 00:00"
  until="$day 23:59"
  report="./git-report-$day.txt"

  find "${source}" -type d -name ".git" -exec dirname {} \+ | while read -r d; do
    if [ -d "${d}/.git" ]; then
      {
        printf "%s\n" "=== ${d} ==="

        git --no-pager --git-dir="${d}/.git" --work-tree="${d}" log --all \
        --since="${since}" \
        --until="${until}" \
        --author="${committer_email}" \
        --pretty=format:"%s"

        printf "\n"
      } > "${report}"
    fi
  done
done
