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

# author daniele.bagni@xilinx.com
# date: 14 March 2020

#dos2unix conversion
for file in $(find $PWD -name "*.sh"); do
    sed -i 's/\r//g' ${file}
    echo  ${file}
done


##################################################################################
#organize data for Fashion-MNIST and CIFAR10
#source 0_generate_images.sh
##################################################################################

# training from scratch with CIFAR10
#source ./1_cifar10_train.sh

# convert Keras model into TF inference graph
source ./2_cifar10_Keras2TF.sh

# freeze the graphn to make predictions later
source ./3a_cifar10_freeze.sh

# make predictions with frozen graph
source ./3b_cifar10_evaluate_frozen_graph.sh

# quantize the CNN from 32-bit floating-point to 8-bit fixed-point
source ./4a_cifar10_quant.sh

# make predictions with quantized frozen graph
source ./4b_cifar10_evaluate_quantized_graph.sh

# compile ELF file for Ultra96 target board
source ./5_cifar10_vai_compile.sh

##################################################################################
# training from scratch with Fashion-MNIST
#source ./1_fmnist_train.sh

# convert Keras model into TF inference graph
source ./2_fmnist_Keras2TF.sh

# freeze the graphn to make predictions later
source ./3a_fmnist_freeze.sh

# make predictions with frozen graph
source ./3b_fmnist_evaluate_frozen_graph.sh

# quantize the CNN from 32-bit floating-point to 8-bit fixed-point
source ./4a_fmnist_quant.sh

# make predictions with quantized frozen graph
source ./4b_fmnist_evaluate_quantized_graph.sh

# compile ELF file for ultra96 target board
source ./5_fmnist_vai_compile.sh
