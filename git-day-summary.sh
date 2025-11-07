#!/bin/sh

source="${HOME}/.local/src/"
report="./git-report-$(date -d yesterday +%Y-%m-%d).txt"
committer_email="oliver.sakkestad@upheads.no"
since="yesterday 00:00"
until="yesterday 23:59"

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
    } >> "${report}"
  fi
done
