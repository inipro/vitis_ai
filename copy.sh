cp -f petalinux/ultra96/images/linux/boot.scr src/image/boot.scr
cp -f petalinux/ultra96/images/linux/bl31.elf src/boot/bl31.elf
cp -f petalinux/ultra96/images/linux/u-boot.elf src/boot/u-boot.elf
cp -f petalinux/ultra96/images/linux/pmufw.elf src/boot/pmufw.elf
cp -f petalinux/ultra96/images/linux/zynqmp_fsbl.elf src/boot/fsbl.elf
cp -r petalinux/ultra96/images/linux/system.dtb src/image/system.dtb
