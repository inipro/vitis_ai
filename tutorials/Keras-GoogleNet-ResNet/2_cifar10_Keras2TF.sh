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



echo " "
echo "############################################################################################"
echo "KERAS to TENSORFLOW GRAPH CONVERSION for LeNet on CIFAR10"
echo "############################################################################################"
# convert Keras model into TF inference graph
mkdir -p tf_chkpts/cifar10/LeNet
python code/Keras2TF.py  --dataset cifar10 -n LeNet 2>&1 | tee rpt/cifar10/2_keras2TF_graph_conversion_LeNet.log

echo " "
echo "#################################################################################################"
echo "KERAS to TENSORFLOW GRAPH CONVERSION for miniVggNet  on CIFAR10"
echo "#################################################################################################"
mkdir -p tf_chkpts/cifar10/miniVggNet
python code/Keras2TF.py  --dataset cifar10 -n miniVggNet 2>&1 | tee rpt/cifar10/2_keras2TF_graph_conversion_miniVggNet.log


echo " "
echo "#################################################################################################"
echo "KERAS to TENSORFLOW GRAPH CONVERSION for miniGoogleNet  on CIFAR10"
echo "#################################################################################################"
mkdir -p tf_chkpts/cifar10/miniGoogleNet
python code/Keras2TF.py --dataset cifar10 -n miniGoogleNet 2>&1 | tee rpt/cifar10/2_keras2TF_graph_conversion_miniGoogleNet.log


echo " "
echo "#################################################################################################"
echo "KERAS to TENSORFLOW GRAPH CONVERSION for miniResNet  on CIFAR10"
echo "#################################################################################################"
mkdir -p tf_chkpts/cifar10/miniResNet
python code/Keras2TF.py --dataset cifar10 -n miniResNet 2>&1 | tee rpt/cifar10/2_keras2TF_graph_conversion_miniResNet.log
