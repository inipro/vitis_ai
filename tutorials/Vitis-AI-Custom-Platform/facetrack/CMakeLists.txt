cmake_minimum_required(VERSION 3.5)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(vitis_ai_library COMPONENTS classification REQUIRED)
find_package(PkgConfig REQUIRED)

find_library(MEDIACTL_LIBRARY NAMES mediactl)
find_library(V4L2SUBDEV_LIBRARY NAMES v4l2subdev)

pkg_check_modules(LIBDRM_PKG REQUIRED IMPORTED_TARGET libdrm)

add_executable(facetrack facetrack.cpp centroidtracker.cpp)

target_compile_definitions(facetrack PRIVATE USE_DRM)
target_link_libraries(facetrack PRIVATE ${MEDIACTL_LIBRARY} ${V4L2SUBDEV_LIBRARY} ${OpenCV_LIBS} PkgConfig::LIBDRM_PKG vitis_ai_library::facedetect vart::runner)

install(TARGETS facetrack DESTINATION bin)
