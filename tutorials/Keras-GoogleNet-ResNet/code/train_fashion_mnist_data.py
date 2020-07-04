#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
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
'''

import os # DB
import glob
from random import seed
from random import shuffle #DB
import cv2
import numpy as np
from keras.preprocessing.image import img_to_array
from keras.utils import to_categorical
from config import fashion_mnist_config as cfg #DB

##################################################################################
# create data from images

# make a list of all files currently in the TRAIN folder
imagesList = [img for img in glob.glob(cfg.TRAIN_DIR + "/*/*.png")]

seed(42)
shuffle(imagesList)
x_train, y_train = list(), list()
for img in imagesList:
	filename = os.path.basename(img)
	classname = filename.split("_")[0]

	# read image with OpenCV
	img_orig = cv2.imread(img)
	img_array = img_to_array(img_orig, data_format=None)
	x_train.append(img_array)
	y_train.append(cfg.labelNames_dict[classname])


# make a list of all files currently in the VALID folder
imagesList = [img for img in glob.glob(cfg.VALID_DIR + "/*/*.png")]
shuffle(imagesList)
x_valid, y_valid = list(), list()
for img in imagesList:
	filename = os.path.basename(img)
	classname = filename.split("_")[0]
	# read image with OpenCV
	img_orig = cv2.imread(img)
	img_array = img_to_array(img_orig, data_format=None)
	x_valid.append(img_array)
	y_valid.append(cfg.labelNames_dict[classname])


# make a list of all files currently in the VALID folder
imagesList = [img for img in glob.glob(cfg.TEST_DIR + "/*/*.png")]
shuffle(imagesList)
x_test, y_test = list(), list()
for img in imagesList:
	filename = os.path.basename(img)
	classname = filename.split("_")[0]
	# read image with OpenCV
	img_orig = cv2.imread(img)
	img_array = img_to_array(img_orig, data_format=None)
	x_test.append(img_array)
	y_test.append(cfg.labelNames_dict[classname])

## if we are using "channels first" ordering, then reshape the design
## matrix such that the matrix is:
## 	num_samples x depth x rows x columns
#if K.image_data_format() == "channels_first":
#	x_train = x_train.reshape((x_train.shape[0], 1, 28, 28))
#	x_test  = x_test.reshape((x_test.shape[0], 1, 28, 28))
## otherwise, we are using "channels last" ordering, so the design
## matrix shape should be: num_samples x rows x columns x depth
#else:
#	x_train = x_train.reshape((x_train.shape[0], 28, 28, 1))
#	x_test  = x_test.reshape((x_test.shape[0], 28, 28, 1))

# one-hot encode the training and testing labels
y_train = to_categorical(y_train, 10)
y_test  = to_categorical(y_test,  10)
y_valid = to_categorical(y_valid, 10)

# check settings #DB
assert True, ( len(x_train) > cfg.NUM_TRAIN_IMAGES)
assert True, ( len(x_test) >= (cfg.NUM_TRAIN_IMAGES+cfg.NUM_VAL_IMAGES))
assert True, ( cfg.NUM_TRAIN_IMAGES==cfg.NUM_VAL_IMAGES )

#################################################################################
# pre-process the data

x_test  = np.asarray(x_test)
x_train = np.asarray(x_train)
x_valid = np.asarray(x_valid)

'''
# apply mean subtraction to the data #DB
mean = np.mean(x_train, axis=0)
x_train = x_train - mean
x_test  = x_test  - mean
x_valid = x_valid - mean
print("MEAN VALUES: ", mean)

# scale data to the range of [0, 1]
x_train = x_train.astype("float32") / cfg.NORM_FACTOR
x_test  = x_test.astype("float32") / cfg.NORM_FACTOR
x_valid = x_valid.astype("float32") / cfg.NORM_FACTOR

# normalize as Xilinx DNNDK TF 3.0 likes to see #DB
x_train = x_train -0.5
x_train = x_train *2
x_test  = x_test  -0.5
x_test  = x_test  *2
x_valid = x_valid  -0.5
x_valid = x_valid  *2
'''

x_train = cfg.Normalize(x_train)
x_test  = cfg.Normalize(x_test)
x_valid = cfg.Normalize(x_valid)

np.savez_compressed('fmnist_dataset.npz', x_train=x_train, y_train=y_train, x_test=x_test, y_test=y_test, x_valid=x_valid, y_valid=y_valid)
