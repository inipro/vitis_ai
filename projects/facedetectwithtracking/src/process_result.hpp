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
#include <vector>
#include "centroidtracker.h"

cv::Mat process_result(cv::Mat &m1, const vitis::ai::FaceDetectResult &result,
                       bool is_jpeg) {
  static auto centroidTracker = new CentroidTracker(20);

  cv::Mat image;
  cv::resize(m1, image, cv::Size(result.width, result.height));

  std::vector<std::vector<int>> boxes;
  for (const auto &r : result.rects) {
      int x1 = r.x * image.cols;
      int y1 = r.y * image.rows;
      int x2 = x1 + r.width * image.cols;
      int y2 = y1 + r.height * image.rows;
      boxes.push_back({x1, y1, x2, y2});
  }

  centroidTracker->update(boxes);

  
  for (const auto &bbox : centroidTracker->bboxes) {
      int id = bbox.first;
      int x = bbox.second[0];
      int y = bbox.second[1];
      int w = bbox.second[2] - bbox.second[0];
      int h = bbox.second[3] - bbox.second[1];

      cv::rectangle(image,
              cv::Rect(x, y, w, h),
              0xff);

      cv::putText(image, std::string("ID ") + std::to_string(id),
              cv::Point(x, y-10), cv::FONT_HERSHEY_COMPLEX, 0.5,
              cv::Scalar(255, 0, 0), 1);
  }

  return image;
}
