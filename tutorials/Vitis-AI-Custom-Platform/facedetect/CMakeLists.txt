cmake_minimum_required(VERSION 3.5)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(vitis_ai_library COMPONENTS classification REQUIRED)
find_package(PkgConfig REQUIRED)

find_library(MEDIACTL_LIBRARY NAMES mediactl)
find_library(V4L2SUBDEV_LIBRARY NAMES v4l2subdev)

pkg_check_modules(LIBDRM_PKG REQUIRED IMPORTED_TARGET libdrm)

add_executable(test_performance_facedetect test_performance_facedetect.cpp)
add_executable(test_video_facedetect test_video_facedetect.cpp)

target_compile_definitions(test_video_facedetect PRIVATE USE_DRM)
target_link_libraries(test_performance_facedetect PRIVATE ${OpenCV_LIBS} vitis_ai_library::facedetect vart::runner vart::util)
target_link_libraries(test_video_facedetect PRIVATE ${MEDIACTL_LIBRARY} ${V4L2SUBDEV_LIBRARY} ${OpenCV_LIBS} PkgConfig::LIBDRM_PKG vitis_ai_library::facedetect vart::runner)

install(TARGETS test_performance_facedetect test_video_facedetect DESTINATION bin)
