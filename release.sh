#!/bin/sh
set -x
dmd -O -m64 forge.d
rm *.o
