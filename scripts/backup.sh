#!/usr/bin/env bash
# Back up the home directory with restic. Passwords are handled by restic/SSH.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: backup.sh [--dry-run | --init] [options]

Back up $HOME to sftp:storage@nas:/backup/$(hostname -s).
The repository uses an absolute SFTP path (e.g. /backup/laptop).

  -n, --dry-run    Preview an existing repository; write no backup data
      --init       Create the repository, without running a backup
      --repo REPO  Override the destination (also useful for local tests)
      --source DIR Override the home directory to back up
  -v, --verbose    Also print each file as restic finishes processing it
      --no-color  Disable the banner's ANSI colors
  -h, --help      Show this help

SSH asks for the storage user's login password when needed. Restic asks
separately for its encryption password, or uses RESTIC_PASSWORD_FILE,
RESTIC_PASSWORD_COMMAND or RESTIC_PASSWORD if already configured.
EOF
}

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 2; }

mode=backup
# Honor nonstandard home locations; fall back to the Linux username convention.
source_dir=${HOME:-/home/${USER:?Set HOME or USER to locate the home directory}}
repository=
verbosity=1
use_color=true
while (($#)); do
  case "$1" in
    -n|--dry-run)
      [[ $mode != init ]] || fail '--init and --dry-run cannot be combined'
      mode=dry-run; shift ;;
    --init)
      [[ $mode != dry-run ]] || fail '--init and --dry-run cannot be combined'
      mode=init; shift ;;
    --repo|--source)
      (($# >= 2)) && [[ -n $2 && $2 != --* ]] || fail "$1 needs a value"
      if [[ $1 == --repo ]]; then repository=$2; else source_dir=$2; fi
      shift 2 ;;
    -v|--verbose) verbosity=2; shift ;;
    --no-color) use_color=false; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "Unknown argument: $1 (see --help)" ;;
  esac
done

for dependency in restic hostname realpath; do
  command -v "$dependency" >/dev/null || fail "Missing dependency: $dependency"
done
backup_host=$(hostname -s)
[[ $backup_host =~ ^[a-zA-Z0-9][a-zA-Z0-9_-]*$ ]] || fail 'Invalid short hostname'
repository=${repository:-sftp:storage@nas:/backup/$backup_host}
[[ -d $source_dir ]] || fail "Source directory does not exist: $source_dir"
source_dir=$(realpath -- "$source_dir")
[[ $source_dir != / ]] || fail 'This script backs up a home directory, not /'
script_path=$(realpath -- "${BASH_SOURCE[0]}")
exclude_file=${script_path%/*}/backup.excludes
[[ -r $exclude_file ]] || fail "Cannot read exclusions: $exclude_file"

# Restic expands this task-specific variable inside the committed exclude file.
export BACKUP_HOME=$source_dir

# Request status updates even when restic cannot recognize the terminal.
# In a plain terminal or pipe these become periodic lines instead of disappearing.
export RESTIC_PROGRESS_FPS=${RESTIC_PROGRESS_FPS:-5}

cyan= green= amber= red= dim= reset=
if [[ -t 1 && ${TERM:-dumb} != dumb && ! ${NO_COLOR+x} && $use_color == true ]]; then
  cyan=$'\e[1;36m'; green=$'\e[1;32m'; amber=$'\e[1;33m'
  red=$'\e[1;31m'; dim=$'\e[2m'; reset=$'\e[0m'
fi
printf '\n%s╭─ RESTIC / HOME BACKUP ─────────────────────────────%s\n' "$cyan" "$reset"
printf '%s│%s HOST     %s\n' "$cyan" "$reset" "$backup_host"
printf '%s│%s SOURCE   %s\n' "$cyan" "$reset" "$source_dir"
printf '%s│%s TARGET   %s\n' "$cyan" "$reset" "$repository"
printf '%s│%s MODE     %s%s%s\n' "$cyan" "$reset" "$amber" "${mode^^}" "$reset"
printf '%s│%s RULES    %s\n' "$cyan" "$reset" "$exclude_file"
printf '%s╰──────────────────────────────────────────────────%s\n' "$cyan" "$reset"

command_args=(restic --repo "$repository")
if [[ $repository == sftp:* ]]; then
  command -v ssh >/dev/null || fail 'Missing dependency: ssh'
  command_args+=(-o 'sftp.args=-oConnectTimeout=15 -oServerAliveInterval=30 -oServerAliveCountMax=3')
fi
if [[ $mode == init ]]; then
  command_args+=(init)
else
  command_args+=(backup --host "$backup_host" --verbose="$verbosity" --exclude-file "$exclude_file")
  if [[ $mode == dry-run ]]; then
    command_args+=(--dry-run --no-cache --no-lock)
    printf '%sPREVIEW · no uploads, no snapshot, no repository initialization%s\n' "$amber" "$reset"
  fi
  command_args+=(-- "$source_dir")
  printf '%sProgress: processed files/bytes and current paths; ETA when estimable.%s\n' "$dim" "$reset"
fi
printf '\n'

# Keep restic attached directly to the terminal: native progress and SSH's
# hidden password prompts work without a pipe, tee, or a second password store.
started=$SECONDS
if "${command_args[@]}"; then
  result=0
else
  result=$?
fi
elapsed=$((SECONDS - started))
printf '\n'
case $result in
  0)
    case $mode in
      dry-run) label='DRY RUN COMPLETE · no snapshot created' ;;
      init) label='REPOSITORY INITIALIZED · no backup run' ;;
      *) label='BACKUP COMPLETE' ;;
    esac
    printf '%s[ OK ] %s%s\n' "$green" "$label" "$reset" ;;
  3) printf '%s[ INCOMPLETE ] Some source data could not be read.%s\n' "$amber" "$reset" ;;
  10)
    printf '%s[ MISSING REPOSITORY ] Check --repo and the path visible inside the SFTP chroot.%s\n' "$red" "$reset"
    printf 'Use --init only when intentionally creating a new repository.\n' ;;
  130) printf '%s[ CANCELLED ] Backup interrupted.%s\n' "$amber" "$reset" ;;
  *) printf '%s[ FAILED ] restic exited with status %s.%s\n' "$red" "$result" "$reset" ;;
esac
printf '%s[ TIME ] %02d:%02d:%02d · exit %d%s\n\n' "$dim" "$((elapsed / 3600))" "$((elapsed / 60 % 60))" "$((elapsed % 60))" "$result" "$reset"
exit "$result"
