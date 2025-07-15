#!/bin/bash

cd ~
mkdir source
cd source
if [ -d dstask ]; then
		cd dstask
		git pull
else
	git clone git@github.com:naggie/dstask.git
	cd dstask
fi

make
sudo make install
