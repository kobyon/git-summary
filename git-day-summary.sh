#!/bin/sh

source="${HOME}/.local/src/"
committer_emails="oliver.sakkestad@upheads.no 77970971+kobyon@users.noreply.github.com"

create_report() {
  # Variable reference
  # 1 - since
  # 2 - until

  find "${source}" -type d -name ".git" -exec dirname {} \+ | while read -r d; do
  printf "=== %s ===\n" "${d#"${source}"}"

    printf '%s' "${committer_emails}" | awk '{ for( i=1; i<=NF; i++) print $i }' | while read -r email; do
      git --no-pager --git-dir="${d}/.git" --work-tree="${d}" log --all \
      --since="${1}" \
      --until="${2}" \
      --author="${email}" \
      --pretty=format:"%s"
    done

    printf "\n"
  done
}

for i in $(seq 0 6); do
  day=$(date -d "${i} days ago" +%Y-%m-%d)
  since="${day} 07:00"
  until="${day} 18:00"
  report="./git-report-${day}.txt"

  create_report "${since}" "${until}" > "${report}"
done
