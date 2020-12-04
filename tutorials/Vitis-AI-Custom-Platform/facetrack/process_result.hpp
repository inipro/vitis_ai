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
#include <iostream>
#include <opencv2/opencv.hpp>
#include <string>
#include "centroidtracker.h"

cv::Mat process_result(cv::Mat &m1, const vitis::ai::FaceDetectResult &result,
                       bool is_jpeg) {
  static auto centroidTracker = new CentroidTracker(20);
  auto objects = centroidTracker->update(result);

  cv::Mat image;
  cv::resize(m1, image, cv::Size{result.width, result.height});
  for (const auto &obj : objects) {
    cv::rectangle(image,
                  cv::Rect{cv::Point(obj.second[0] , obj.second[1]),
                           cv::Size{obj.second[2],
                                    obj.second[3]}},
                  0xff);
    cv::putText(image, std::string("ID ") + std::to_string(obj.first), cv::Point(obj.second[0], obj.second[1]-10), cv::FONT_HERSHEY_COMPLEX, 0.5, cv::Scalar(255, 0, 0), 1);
  }

  return image;
}
