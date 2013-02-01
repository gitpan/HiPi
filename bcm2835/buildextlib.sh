#!/bin/sh
cd ./buildlib
../src/configure --prefix=$1 CC=$2 CXX=$3 LD=$4
make
