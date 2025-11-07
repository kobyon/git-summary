#!/bin/sh

source="${HOME}/.local/src/"
committer_email="oliver.sakkestad@upheads.no"

create_report() {
  find "${source}" -type d -name ".git" -exec dirname {} \+ | while read -r d; do
    if [ -d "${d}/.git" ]; then
      printf "%s\n" "=== ${d} ==="

      git --no-pager --git-dir="${d}/.git" --work-tree="${d}" log --all \
      --since="${1}" \
      --until="${2}" \
      --author="${committer_email}" \
      --pretty=format:"%s"

      printf "\n"
    fi
  done
}

for i in $(seq 0 6); do
  day=$(date -d "$i days ago" +%Y-%m-%d)
  since="$day 00:00"
  until="$day 23:59"
  report="./git-report-$day.txt"

  create_report "${since}" "${until}" > "${report}"
done
