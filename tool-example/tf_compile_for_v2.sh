#!/bin/sh

#TARGET=ultra96v1_base
TARGET=ultra96v2_base
NET_NAME=resnet_v1_50_tf
DEPLOY_MODEL_PATH=vai_q_output

ARCH=/workspace/${TARGET}.json

vai_c_tensorflow --frozen_pb ${DEPLOY_MODEL_PATH}/deploy_model.pb \
                 --arch ${ARCH} \
		 --output_dir vai_c_output_${TARGET}/ \
		 --net_name ${NET_NAME} \
		 --options "{'save_kernel':''}"


