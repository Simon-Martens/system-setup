# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

open() {
  xdg-open "$@" >/dev/null 2>&1
}
