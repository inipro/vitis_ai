#!/bin/bash

: '
/**

* © Copyright (C) 2016-2020 Xilinx, Inc
*
* Licensed under the Apache License, Version 2.0 (the "License"). You may
* not use this file except in compliance with the License. A copy of the
* License is located at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations
* under the License.
*/
'

TARGET=$(pwd)/../target
mkdir $TARGET

#unpack test images
tar -xvf ./test.tar.gz

mv workspace $TARGET

: '
#run python3 script on fcn8
mkdir $TARGET/fcn8
cd fcn8
mkdir build
cd build
cmake ..
make
cd ..
cp -r build/fcn8 model/config model/run_fcn8_on_dpu.py $TARGET/fcn8
rm -fr build
$CC -fPIC -shared model/dpu_*.elf -o $TARGET/fcn8/libdpumodelfcn8.so
cd ..
mkdir $TARGET/fcn8ups
cd fcn8ups
mkdir build
cd build
cmake ..
make
cd ..
cp -r build/fcn8ups model/config model/run_fcn8ups_on_dpu.py $TARGET/fcn8ups
rm -fr build
$CC -fPIC -shared model/dpu_*.elf -o $TARGET/fcn8ups/libdpumodelfcn8ups.so
cd ..
'
mkdir $TARGET/unet-v1
cd unet/v1
mkdir build
cd build
cmake ..
make
cd ..
cp -r build/unet1 model/config model/run_unet1_on_dpu.py $TARGET/unet-v1
rm -fr build
$CC -fPIC -shared model/dpu_*.elf -o $TARGET/unet-v1/libdpumodelunet1.so
cd ../..
mkdir $TARGET/unet-v2
cd unet/v2
mkdir build
cd build
cmake ..
make
cd ..
cp -r build/unet2 model/config model/run_unet2_on_dpu.py $TARGET/unet-v2
rm -fr build
$CC -fPIC -shared model/dpu_*.elf -o $TARGET/unet-v2/libdpumodelunet2.so
cd ../..
mkdir $TARGET/unet-v3
cd unet/v3
mkdir build
cd build
cmake ..
make
cd ..
cp -r build/unet3 model/config model/run_unet3_on_dpu.py $TARGET/unet-v3
rm -fr build
$CC -fPIC -shared model/dpu_*.elf -o $TARGET/unet-v3/libdpumodelunet3.so
cd ../..
