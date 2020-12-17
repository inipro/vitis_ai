cmake_minimum_required(VERSION 3.5)

project(test_facedetect)

find_package(OpenCV COMPONENTS opencv_core opencv_video opencv_videoio opencv_imgproc opencv_imgcodecs opencv_highgui REQUIRED)
find_package(vitis_ai_library COMPONENTS facedetect REQUIRED)
find_package(unilog REQUIRED)
find_package(xir REQUIRED)
find_package(PkgConfig REQUIRED)

pkg_check_modules(LIBDRM_PKG REQUIRED IMPORTED_TARGET libdrm)

add_executable(test_jpeg_facedetect src/test_jpeg_facedetect.cpp src/process_result.hpp)
add_executable(test_accuracy_facedetect src/test_accuracy_facedetect.cpp)
add_executable(test_performance_facedetect src/test_performance_facedetect.cpp src/process_result.hpp)
add_executable(test_video_facedetect src/test_video_facedetect.cpp src/process_result.hpp)

target_compile_definitions(test_video_facedetect PRIVATE USE_DRM)

target_link_libraries(test_jpeg_facedetect PRIVATE ${OpenCV_LIBS} vitis_ai_library::facedetect vart::dpu-runner)
target_link_libraries(test_accuracy_facedetect PRIVATE ${OpenCV_LIBS} vitis_ai_library::facedetect vart::dpu-runner)
target_link_libraries(test_performance_facedetect PRIVATE ${OpenCV_LIBS} vitis_ai_library::facedetect vart::dpu-runner)
target_link_libraries(test_video_facedetect PRIVATE ${OpenCV_LIBS} vitis_ai_library::facedetect vart::dpu-runner PkgConfig::LIBDRM_PKG)

install(TARGETS test_jpeg_facedetect test_accuracy_facedetect test_performance_facedetect test_video_facedetect DESTINATION bin)
