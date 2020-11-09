platform -name ultra96v1_mipi -desc "A reVISION platform targeting the ultra94v2 evaluation board, which includes 2GB of DDR4 for the Processing System, optimized to work with reVISION development environment. More information at http://zedboard.org/product/ultra96-v2-development-board" -hw ./ultra96v1_mipi.xsa -out ./output

domain -name xrt -proc psu_cortexa53 -os linux -image ./src_mipi/a53/xrt/image
domain config -boot ./src_mipi/boot
domain config -bif ./src_mipi/a53/xrt/linux.bif
domain -runtime opencl
domain -pmuqemu-args ./src_mipi/qemu/lnx/pmu_args.txt
domain -qemu-args ./src_mipi/qemu/lnx/qemu_args.txt
domain -qemu-data ./src_mipi/boot
#domain -sysroot ./src_mipi/aarch64-xilinx-linux

platform -generate
