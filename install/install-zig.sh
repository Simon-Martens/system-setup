#!/bin/bash
## Links
## Ubuntu|Debian|Linux

## https://ziglang.org/documentation/master/
## https://ziglang.org/learn/getting-started/
## https://zig.guide/build-system/build-modes/
## https://zig.guide/
## https://github.com/C-BJ/awesome-zig
## https://github.com/zigzap/zap
## https://github.com/karlseguin/http.zig

cd /tmp
V=0.14.0
VERSION=zig-linux-x86_64
wget https://ziglang.org/download/${V}/${VERSION}-${V}.tar.xz
tar xvf ${VERSION}-${V}.tar.xz
rm -f ${VERSION}-${V}.tar.xz

if [ -d /usr/local/zig ]; then
		sudo rm -rf /usr/local/zig
fi

sudo mv ${VERSION}-${V} /usr/local/zig

export PATH=$PATH:/usr/local/zig

zig help
zig version

cd -
