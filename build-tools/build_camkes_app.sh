#!/bin/sh

set -e

if [ $# -ne 2 ] ; then
    echo "Usage: build_camkes_app.sh PLATFORM CAMKES_APP"
    exit 1
fi

platform=$1
app=$2

mkdir build
cd build
../camkes-project/init-build.sh -DPLATFORM=$platform -DAARCH32=1 -DCAMKES_APP=$app -DSIMULATION=1
ninja
cp -r images simulate ../output
