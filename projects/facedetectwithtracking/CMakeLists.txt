cmake_minimum_required(VERSION 3.5)

project(facedetectwithtracking)

find_package(OpenCV COMPONENTS opencv_core opencv_video opencv_videoio opencv_imgproc opencv_imgcodecs opencv_highgui REQUIRED)
find_package(vitis_ai_library COMPONENTS facedetect REQUIRED)
find_package(unilog REQUIRED)
find_package(xir REQUIRED)
find_package(PkgConfig REQUIRED)

pkg_check_modules(LIBDRM_PKG REQUIRED IMPORTED_TARGET libdrm)

add_executable(${PROJECT_NAME} 
    src/centroidtracker.h
    src/centroidtracker.cpp
    src/process_result.hpp
    src/test_video_facedetectwithtracking.cpp
)

target_compile_definitions(${PROJECT_NAME} PRIVATE USE_DRM)

target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} vitis_ai_library::facedetect vart::dpu-runner PkgConfig::LIBDRM_PKG)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
