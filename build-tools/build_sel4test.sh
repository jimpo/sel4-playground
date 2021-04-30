#!/bin/sh

set -e

if [ $# -ne 1 ] ; then
    echo "Usage: build_sel4test.sh PLATFORM"
    exit 1
fi

platform=$1

mkdir build
cd build
python3 -m venv --system-site-packages .venv
. .venv/bin/activate
../sel4test/init-build.sh -DPLATFORM=$platform -DAARCH32=1
ninja
cp -r images ../output
