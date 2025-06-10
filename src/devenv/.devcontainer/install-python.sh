#!/bin/bash

# Install Python 3.13.4
wget -qO- https://www.python.org/ftp/python/3.13.4/Python-3.13.4.tgz | tar -xz -C /tmp
cd /tmp/Python-3.13.4
./configure --enable-optimizations
make -j $(nproc)
make install
rm -rf /tmp/Python-3.13.4
