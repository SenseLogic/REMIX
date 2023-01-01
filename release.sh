#!/bin/sh
set -x
dmd -O -m64 remix.d
rm *.o
