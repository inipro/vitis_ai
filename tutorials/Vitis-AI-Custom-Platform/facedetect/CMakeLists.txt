cmake_minimum_required(VERSION 3.5)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(vitis_ai_library COMPONENTS classification REQUIRED)

find_library(MEDIACTL_LIBRARY NAMES mediactl)
find_library(V4L2SUBDEV_LIBRARY NAMES v4l2subdev)

add_executable(test_video_facedetect test_video_facedetect.cpp)

target_link_libraries(test_video_facedetect PRIVATE ${MEDIACTL_LIBRARY} ${V4L2SUBDEV_LIBRARY} ${OpenCV_LIBS} vitis_ai_library::facedetect vart::runner)

install(TARGETS test_video_facedetect DESTINATION bin)
