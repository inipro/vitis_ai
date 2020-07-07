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


# daniele.bagni@xilinx.com
# date 14 March 2020

## clean up previous log files
#rm -f ./log/*.log

CNN=fcn8


# folders
WORK_DIR=./workspace
LOG_DIR=${WORK_DIR}/../log
RPT_DIR=${WORK_DIR}/../rpt
TARGET_DIR=${WORK_DIR}/../target_template
KERAS_MODEL_DIR=${WORK_DIR}/../keras_model
DATASET_DIR=${WORK_DIR}/dataset1

CHKPT_DIR=${WORK_DIR}/tf_chkpts
FREEZE_DIR=${WORK_DIR}/freeze
COMPILE_DIR=${WORK_DIR}/compile
QUANT_DIR=${WORK_DIR}/quantize_results

# checkpoints & graphs filenames
CHKPT_FILENAME=float_model.ckpt
INFER_GRAPH_FILENAME=infer_graph.pb
FROZEN_GRAPH_FILENAME=frozen_graph.pb
QUANTIZED_FILENAME=quantize_eval_model.pb

# logs & results files
FREEZE_LOG=${CNN}_freeze_graph.log
EVAL_FR_LOG=${CNN}_evaluate_frozen_graph.log
QUANT_LOG=${CNN}_quantize.log
EVAL_Q_LOG=${CNN}_evaluate_quantized_graph.log
COMP_LOG=${CNN}_compile.log
#ARCH=/workspace/ultra96v1_base.json
ARCH=/workspace/ultra96v2_base.json

# CNN parameters
INPUT_NODE="input_1"
OUTPUT_NODE="activation_1/truediv" # output node of floating point CNN
Q_OUTPUT_NODE="conv2d_transpose_3/conv2d_transpose" # output node of quantized CNN

2b_fcn8_predict() {
    cd code
    echo "##################################################################################"
    echo "Step2b: MAKING PREDICTIONS"
    echo "##################################################################################"
    echo " "
    python fcn8_make_predictions.py --upscale "False" 
    cd ..
}

##################################################################################
# Keras to TF chkpt files
3_fcn8_Keras2TF() {
    echo " "
    echo "#######################################################################################"
    echo "Step3: FCN8 KERAS to TENSORFLOW GRAPH CONVERSION"
    echo "#######################################################################################"
    echo " "
    # clean TF Check Point files
    #rm ${CHKPT_DIR}/${CNN}/*
    # from Keras to TF
    cd code
    python Keras2TF.py --model "fcn8"
    cd ..
}



##################################################################################
# freeze the inference graph
4a_fcn8_freeze() {
    echo " "
    echo "##############################################################################"
    echo "Step4a: FCN8 FREEZE TF GRAPHS"
    echo "##############################################################################"
    echo " "
    # freeze the TF graph
    freeze_graph \
	--input_graph       ${CHKPT_DIR}/${CNN}/${INFER_GRAPH_FILENAME} \
	--input_checkpoint  ${CHKPT_DIR}/${CNN}/${CHKPT_FILENAME} \
	--input_binary      true \
	--output_graph      ${FREEZE_DIR}/${CNN}/${FROZEN_GRAPH_FILENAME} \
	--output_node_names ${OUTPUT_NODE}

    echo " "
    echo "##############################################################################"
    echo "Step4a: FCN8 INSPECT FROZEN GRAPH"
    echo "##############################################################################"
    echo " "
    vai_q_tensorflow inspect --input_frozen_graph ${FREEZE_DIR}/${CNN}/${FROZEN_GRAPH_FILENAME}
}


##################################################################################
# evaluate the original graph
4b_eval_graph() {
    echo " "
    echo "##############################################################################"
    echo "Step4b: FCN8 EVALUATING THE ORIGINAL GRAPH"
    echo "##############################################################################"
    echo " "
    cd code
    python eval_graph.py \
	   --graph=../${FREEZE_DIR}/${CNN}/${FROZEN_GRAPH_FILENAME} \
	   --input_node=${INPUT_NODE} \
	   --output_node=${OUTPUT_NODE} \
	   --gpu=0
    cd ..
}


##################################################################################
5a_fcn8_quantize() {
    echo " "
    echo "##########################################################################"
    echo "Step5a: FCN8 QUANTIZATION"
    echo "##########################################################################"
    echo " "
    # log the decent_q version being used
    echo " "
    vai_q_tensorflow --version
    echo " "
    #quantize
    cd code
    vai_q_tensorflow quantize \
	 --input_frozen_graph  ../${FREEZE_DIR}/${CNN}/${FROZEN_GRAPH_FILENAME} \
	 --input_nodes         ${INPUT_NODE} \
	 --input_shapes        ?,224,224,3 \
	 --output_nodes        ${Q_OUTPUT_NODE} \
	 --output_dir          ../${QUANT_DIR}/${CNN}/ \
	 --method              1 \
	 --input_fn            graph_input_fn.calib_input \
	 --calib_iter          10 \
	 --gpu 0

    cd ..
}

##################################################################################
# make predictions with quantized graph

5b_eval_quantized_graph() {
    echo " "
    echo "##############################################################################"
    echo "Step5b: FCN8 EVALUATE QUANTIZED GRAPH"
    echo "##############################################################################"
    echo " "
    cd code
    python eval_quantized_graph.py \
	   --graph=../${QUANT_DIR}/${CNN}/${QUANTIZED_FILENAME} \
	   --input_node=${INPUT_NODE} \
	   --output_node=${Q_OUTPUT_NODE} \
	   --gpu=0
    cd ..
}


##################################################################################
# Compile ELF file for Ultra96 board with Vitis AI Compiler
6_compile_vai() {
  echo " "
  echo "##########################################################################"
  echo "COMPILE FCN8 ELF FILE WITH Vitis AI for Ultra96"
  echo "##########################################################################"
  echo " "
  vai_c_tensorflow \
	 --frozen_pb ${QUANT_DIR}/${CNN}/deploy_model.pb \
	 --arch ${ARCH} \
	 --output_dir ${COMPILE_DIR}/${CNN} \
	 --options    "{'mode':'normal'}" \
	 --net_name ${CNN}
 }

##################################################################################
##################################################################################

main() {

    # clean up previous results
    rm -rf ${RPT_DIR}; mkdir ${RPT_DIR}
    rm -rf ${CHKPT_DIR}; mkdir ${CHKPT_DIR}
    rm -rf ${FREEZE_DIR}; mkdir ${FREEZE_DIR}
    rm -rf ${QUANT_DIR}; mkdir ${QUANT_DIR}
    rm -rf ${COMPILE_DIR}; mkdir ${COMPILE_DIR}

    mkdir ${LOG_DIR}/${CNN} ${CHKPT_DIR}/${CNN} ${FREEZE_DIR}/${CNN} ${QUANT_DIR}/${CNN} ${COMPILE_DIR}/${CNN}

    # make predictions
    2b_fcn8_predict 2>&1 | tee ${LOG_DIR}/${CNN}/fcn8_predict.log

    # from Keras to TF
    3_fcn8_Keras2TF  2>&1 | tee ${LOG_DIR}/${CNN}/fcn8_keras2tf.log

    # freeze the graph and inspect it
    4a_fcn8_freeze   2>&1 | tee ${LOG_DIR}/${CNN}/${FREEZE_LOG}

    # evaluate the frozen graph performance
    4b_eval_graph 2>&1 | tee ${LOG_DIR}/${CNN}/${EVAL_FR_LOG}

    # quantize 
    5a_fcn8_quantize 2>&1 | tee ${LOG_DIR}/${CNN}/${QUANT_LOG}

    # evaluate post-quantization model
    5b_eval_quantized_graph 2>&1 | tee ${LOG_DIR}/${CNN}/${EVAL_Q_LOG}

    # compile with dnnc to generate elf file for Ultra96
    6_compile_vai 2>&1 | tee ${LOG_DIR}/${CNN}/${COMP_LOG}
    # move elf and so files to target board directory
    mv  ${COMPILE_DIR}/${CNN}/dpu*.elf    ${TARGET_DIR}/${CNN}/model/


    echo "#####################################"
    echo "MAIN FCN8 FLOW COMPLETED"
    echo "#####################################"

}

main
