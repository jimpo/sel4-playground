#!/bin/bash

set -e

usage() {
    echo "Usage: build_uboot.sh [-h] [-b BRANCH] [-e ENV_FILE] [-s BOOT_SCRIPT] -c CONFIG"
}

while getopts ":hb:e:s:c:" opt ; do
    case $opt in
        h )
            usage
            exit 0
            ;;
        b )
            branch=$OPTARG
            ;;
        c )
            # Examples: rpi_3_32b, odroid-xu3
            config=$OPTARG
            ;;
        e )
            env_file=$(realpath $OPTARG)
            ;;
        s )
            boot_script=$(realpath $OPTARG)
            ;;
        \? )
            echo "Invalid option -$OPTARG"
            usage
            exit 1
            ;;
        : )
            echo "Missing argument to -$OPTARG"
            usage
            exit 1
            ;;
    esac
done

if [ -z "$config" ] ; then
    echo "Missing config option"
    usage
    exit 1
fi

OUTPUT_DIR=$PWD/output

cd u-boot
if [ -n "$branch" ] ; then
    git checkout "$branch"
fi
export CROSS_COMPILE=arm-linux-gnueabi-
make ${config}_defconfig
make -j4

cp u-boot.bin $OUTPUT_DIR

env_size=$(sed -n 's/CONFIG_ENV_SIZE=\(.*\)/\1/p' .config)
if [ -n "$env_file" ] ; then
    echo "Generating uboot.env from $env_file"
    scripts/get_default_envs.sh | \
        cat - $env_file | \
        tools/mkenvimage -s $env_size -o $OUTPUT_DIR/uboot.env -
fi
if [ -n "$boot_script" ] ; then
    echo "Generating boot.scr.uimg from $boot_script"
    tools/mkimage -A arm -O linux -T script -C none -n boot.scr -d $boot_script $OUTPUT_DIR/boot.scr.uimg
fi
