cmake_minimum_required(VERSION 3.5)

project(seg_and_pose_detect)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(vitis_ai_library COMPONENTS multitask posedetect ssd REQUIRED)

add_executable(${PROJECT_NAME} seg_and_pose_detect.cpp)


target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} vitis_ai_library::multitask vitis_ai_library::posedetect vitis_ai_library::ssd vart::runner)


install(TARGETS ${PROJECT_NAME} DESTINATION bin)
