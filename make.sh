#!/bin/sh
set -x
dmd -m64 remix.d
rm *.o
