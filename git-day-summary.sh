#!/bin/sh

# Script is run wit a optional history parameter
# example: git-day-summary 10
# This will generate 10 days of history.

source="${HOME}/.local/src/"
report_folder="${HOME}/reports"
committer_emails="oliver.sakkestad@upheads.no 77970971+kobyon@users.noreply.github.com"
generate_history=${1:-4} # How many days of history?

git_log() {
  since="${1}"
  until="${2}"
  git_directory="${3}"
  
  printf '%s' "${committer_emails}" | awk '{ for( i=1; i<=NF; i++) print $i }' | while read -r email; do
    git --no-pager --git-dir="${git_directory}/.git" --work-tree="${git_directory}" log --all \
    --since="${since}" \
    --until="${until}" \
    --author="${email}" \
    --pretty=format:"%ad %s" --date=format:'%H:%M'
  done
}

create_report() {
  since="${1}"
  until="${2}"

  find "${source}" -type d -name ".git" -exec dirname {} \+ | while read -r d; do
    _git_log=$(git_log "${since}" "${until}" "${d}") # Store the value of git_log in a variable so we can run checks
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
  since="${day} 00:00"
  until="${day} 23:59"
  report="${report_folder}/git-report-${day}.txt"

  create_report "${since}" "${until}" > "${report}"
done
