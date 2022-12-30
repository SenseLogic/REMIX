#!/bin/sh
set -x
dmd -m64 forge.d
rm *.o
