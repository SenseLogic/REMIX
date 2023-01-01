#!/bin/sh
set -x
dmd -debug -g -gf -gs -m64 remix.d
rm *.o
