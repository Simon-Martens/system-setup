mkdir -p ~/.local/share/fonts

find . -type f \( \
  -iname '*.ttf' -o \
  -iname '*.otf' -o \
  -iname '*.ttc' -o \
  -iname '*.otc' \
\) -exec mv -t ~/.local/share/fonts/ -- {} +

fc-cache -f -v
