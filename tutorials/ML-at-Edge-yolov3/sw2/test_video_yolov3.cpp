/*
 * Copyright 2019 Xilinx Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <stdio.h>
#include <string.h>

extern "C" {
#include <mediactl/mediactl.h>
#include <mediactl/v4l2subdev.h>
}

#include <glog/logging.h>
#include <iostream>
#include <memory>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <vitis/ai/demo.hpp>
#include <vitis/ai/yolov3.hpp>
#include <vitis/ai/nnpp/yolov3.hpp>
#include "./process_result.hpp"
using namespace std;
int main(int argc, char *argv[]) {

	int ret;
	char media_formats[100];
	struct media_device *media;
	media = media_device_new("/dev/media0");
	if (!media) {
		fprintf(stderr, "failed to create media device from /dev/media0");
		return -1;
	}

	ret = media_device_enumerate(media);
	if (ret < 0) {
		fprintf(stderr, "failed to enumerate /dev/media0");
		media_device_unref(media);
		return -1;
	}

	memset(media_formats, 0, sizeof(media_formats));
	sprintf(media_formats, "\"ov5640 3-003c\":0 [fmt:UYVY/640x480@1/30 field:none]");
	ret = v4l2_subdev_parse_setup_formats(media, media_formats);
	if (ret < 0) {
		fprintf(stderr, "Unable to setup formats: %s(%d)\n", media_formats, ret);
		media_device_unref(media);
		return -1;
	}

    memset(media_formats, 0, sizeof(media_formats));
    sprintf(media_formats, "\"b0000000.mipi_csi2_rx_subsystem\":0 [fmt:UYVY/640x480 field:none]");
    ret = v4l2_subdev_parse_setup_formats(media, media_formats);
    if (ret < 0) {
        fprintf(stderr, "Unable to setup formats: %s(%d)\n", media_formats, ret);
        media_device_unref(media);
        return -1;
    }

    media_device_unref(media);

	string model = argv[1];
	return vitis::ai::main_for_video_demo(
			argc, argv,
			[model] {
			return vitis::ai::YOLOv3::create(model);
			},
			process_result, 2);
}
