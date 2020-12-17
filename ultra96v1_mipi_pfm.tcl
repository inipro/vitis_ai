platform -name ultra96v1_mipi -desc "A reVISION platform targeting the ultra94v1 evaluation board, which includes 2GB of DDR4 for the Processing System, optimized to work with reVISION development environment. More information at http://ultra96.org/product/ultra96" -hw ./ultra96v1_mipi.xsa -out ./output -no-boot-bsp

domain -name xrt -proc psu_cortexa53 -os linux -image ./src/image
domain config -boot ./src/boot
domain config -bif ./src/boot/linux.bif
domain -runtime opencl
domain -pmuqemu-args ./src/qemu/lnx/pmu_args.txt
domain -qemu-args ./src/qemu/lnx/qemu_args.txt
domain -qemu-data ./src/boot
#domain -sysroot ./src/aarch64-xilinx-linux

platform -generate
