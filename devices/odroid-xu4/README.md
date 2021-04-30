## Configuring SD card

This guide assumes your SD card block device is `/dev/mmcblk0`. If not, modify commands accordingly.

First we format the disk

```bash
$ sudo fdisk /dev/mmcblk0

Command (m for help): o
...

Command (m for help): n
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-31207423, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-31207423, default 31207423): +256M

Command (m for help): t
Selected partition 1
Hex code (type L to list all codes): c

Command (m for help): w

The partition table has been altered.

$ sudo mkfs.vfat -n boot /dev/mmcblk0p1
```

Mount the new FAT32 boot partition and set `ODROID_XU4_SDCARD` to the mount path.

Next, build U-Boot and the boot script. Even though HardKernel provides its own recommended version of U-Boot in a forked repository, we have found that their version has an ethernet issue and the mainline U-Boot works just fine.

```bash
docker run --name odroid-xu4_uboot_builder sel4-playground-builder \
    ./build_uboot.sh -b master -s devices/odroid-xu4/boot.scr -c odroid-xu3
docker cp odroid-xu4_uboot_builder:/root/output/. $ODROID_XU4_SDCARD
docker rm odroid-xu4_uboot_builder
```

When the Odroid-XU4 boots from the SD card, it reads U-Boot from the partition table's bootstrap area. HardKernel provides a tool to help us write this properly called `sd_fusing.sh` in their fork of the U-Boot repo.

If you haven't already, configure the `hardkernel` git remote and fetch the `odroidxu4-v2017.05` branch.

```bash
git remote add hardkernel https://github.com/hardkernel/u-boot.git
git fetch hardkernel odroidxu4-v2017.05
```

Check out the `odroidxu4-v2017.05` branch and use the `sd_fuse` tool to write *our* updated version of U-Boot.

```bash
cd u-boot
git checkout odroidxu4-v2017.05
cd sd_fuse
mv $ODROID_XU4_SDCARD/u-boot.bin .
./sd_fusing.sh /dev/mmcblk0
```

## References

[https://wiki.odroid.com/odroid-xu4/software/building_u-boot_mainline](https://wiki.odroid.com/odroid-xu4/software/building_u-boot_mainline)
