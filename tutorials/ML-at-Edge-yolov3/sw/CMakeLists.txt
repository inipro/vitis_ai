cmake_minimum_required(VERSION 3.5)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(vitis_ai_library COMPONENTS classification REQUIRED)

add_executable(test_performance_yolov3 test_performance_yolov3.cpp)
add_executable(test_video_yolov3 test_video_yolov3.cpp)

target_link_libraries(test_performance_yolov3 PRIVATE ${OpenCV_LIBS} vitis_ai_library::yolov3 vart::runner vart::util)
target_link_libraries(test_video_yolov3 PRIVATE ${OpenCV_LIBS} vitis_ai_library::yolov3 vart::runner)

install(TARGETS test_performance_yolov3 test_video_yolov3 DESTINATION bin)
