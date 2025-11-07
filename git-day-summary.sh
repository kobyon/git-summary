#!/bin/sh

# Script is run wit a optional history parameter
# example: git-day-summary 10
# This will generate 10 days of history.

source="${HOME}/.local/src/"
report_folder="${HOME}/reports"
committer_emails="oliver.sakkestad@upheads.no 77970971+kobyon@users.noreply.github.com"
generate_history=${1:-3} # How many days of history?

git_log() {
  # Variable reference
  # 1 - since
  # 2 - until
  # 3 - git directory
  printf '%s' "${committer_emails}" | awk '{ for( i=1; i<=NF; i++) print $i }' | while read -r email; do
    git --no-pager --git-dir="${3}/.git" --work-tree="${3}" log --all \
    --since="${1}" \
    --until="${2}" \
    --author="${email}" \
    --pretty=format:"%ad %s" --date=format:'%H:%M'
  done
}

create_report() {
  # Variable reference
  # 1 - since
  # 2 - until
  find "${source}" -type d -name ".git" -exec dirname {} \+ | while read -r d; do
    _git_log=$(git_log "${1}" "${2}" "${d}") # Store the value of git_log in a variable so we can run checks
    if [ -n "${_git_log}" ]; then
      project=$(printf "%s" "${d#"${source}"}" | awk -F'/' '{print $2}')
      printf "=== %s ===\n" "${project}" # Print a project header
      printf "%s\n" "${_git_log}"
    fi
  done
}

[ -d "${report_folder}" ] || mkdir -p "${report_folder}" # Make sure the project folder exist

# Main loop
# Looping trough all days you want to generate reports for
for i in $(seq 0 $((generate_history - 1))); do
  day=$(date -d "${i} days ago" +%Y-%m-%d)
  since="${day} 07:00"
  until="${day} 18:00"
  report="${report_folder}/git-report-${day}.txt"

  create_report "${since}" "${until}" > "${report}"
done
