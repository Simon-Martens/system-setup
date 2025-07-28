# This allows you to change a part of a filename to another part.
function rename_part() {
  # First parse optional flags
  local recursive=false
  while [[ "$1" == "-"* ]]; do
    case "$1" in
      -r|--recursive)
        recursive=true
        shift
        ;;
      *)
        echo "Unknown option: $1"
        echo "Usage: rename_part [-r|--recursive] <old> <new>"
        return 1
        ;;
    esac
  done

  # After flags, the first two positional args are the 'old' and 'new' substrings
  local old="$1"
  local new="$2"

  if [[ -z "$old" || -z "$new" ]]; then
    echo "Usage: rename_part [-r|--recursive] <old> <new>"
    return 1
  fi

  if [ "$recursive" = true ]; then
    # Recursively find all files containing 'old' in the filename
    # -print0 and read -r -d '' handle spaces and special chars in filenames
    find . -type f -name "*${old}*" -print0 |
    while IFS= read -r -d '' file; do
      local dir
      local base
      dir="$(dirname "$file")"
      base="$(basename "$file")"

      # Replace 'old' with 'new' in the filename
      local newfile="${base//$old/$new}"

      # Perform the rename
      mv -v -- "$file" "$dir/$newfile"
    done
  else
    # Non-recursive: only look in the current directory
    for file in *"$old"*; do
      [[ -e "$file" ]] || continue  # Skip if no match
      local newfile="${file//$old/$new}"
      mv -v -- "$file" "$newfile"
    done
  fi
}

