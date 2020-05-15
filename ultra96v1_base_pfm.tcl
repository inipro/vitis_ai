platform -name ultra96v1_base -desc "A reVISION platform targeting the ultra94v2 evaluation board, which includes 2GB of DDR4 for the Processing System, optimized to work with reVISION development environment. More information at http://zedboard.org/product/ultra96-v2-development-board" -hw ./ultra96v1_base.xsa -out ./output

domain -name xrt -proc psu_cortexa53 -os linux -image ./src/a53/xrt/image
domain config -boot ./src/boot
domain config -bif ./src/a53/xrt/linux.bif
domain -runtime opencl
domain -pmuqemu-args ./src/qemu/lnx/pmu_args.txt
domain -qemu-args ./src/qemu/lnx/qemu_args.txt
domain -qemu-data ./src/boot
#domain -sysroot ./src/aarch64-xilinx-linux

platform -generate
