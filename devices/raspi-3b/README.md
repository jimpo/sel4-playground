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

Mount the new FAT32 boot partition and set `RASPI_3B_SDCARD` to the mount path.

Copy the Raspberry Pi firmware files to the SD card.

```bash
for file in bootcode.bin start.elf bcm2710-rpi-3-b.dtb ; do
    curl -L -o $RASPI_3B_SDCARD/$file https://github.com/raspberrypi/firmware/raw/master/boot/$file
done

cp config.txt $RASPI_3B_SDCARD
```

Next, build U-Boot and the boot script and copy to the SD card.

```

docker run --name raspi-3b_uboot_builder sel4-playground-builder \
    ./build_uboot.sh -b sel4-cache-disable-patch -s devices/raspi-3b/boot.scr -c rpi_3_32b
docker cp raspi-3b_uboot_builder:/root/output/. $RASPI_3B_SDCARD
docker rm raspi-3b_uboot_builder
```
