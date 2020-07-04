#!/bin/bash

## © Copyright (C) 2016-2020 Xilinx, Inc
##
## Licensed under the Apache License, Version 2.0 (the "License"). You may
## not use this file except in compliance with the License. A copy of the
## License is located at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
## WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
## License for the specific language governing permissions and limitations
## under the License.

TARGET=$(pwd)/../target/fmnist
mkdir -p $TARGET/LeNet
mkdir -p $TARGET/miniVggNet
mkdir -p $TARGET/miniGoogleNet
mkdir -p $TARGET/miniResNet
sh ./build_fmnist_test.sh
cd fmnist/LeNet
cp run_fps_LeNet.sh check_runtime_top5_fashionmnist.py $TARGET/LeNet
mkdir build
cd build
cmake ..
make
cp LeNet fps_LeNet $TARGET/LeNet
cd ..
rm -fr build
cd ../miniVggNet
cp run_fps_miniVggNet.sh check_runtime_top5_fashionmnist.py $TARGET/miniVggNet
mkdir build
cd build
cmake ..
make
cp miniVggNet fps_miniVggNet $TARGET/miniVggNet
cd ..
rm -fr build
cd ../miniGoogleNet
cp run_fps_miniGoogleNet.sh check_runtime_top5_fashionmnist.py $TARGET/miniGoogleNet
mkdir build
cd build
cmake ..
make
cp miniGoogleNet fps_miniGoogleNet $TARGET/miniGoogleNet
cd ..
rm -fr build
cd ../miniResNet
cp run_fps_miniResNet.sh check_runtime_top5_fashionmnist.py $TARGET/miniResNet
mkdir build
cd build
cmake ..
make
cp miniResNet fps_miniResNet $TARGET/miniResNet
cd ..
rm -fr build
cd ../..
