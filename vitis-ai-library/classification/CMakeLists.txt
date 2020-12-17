cmake_minimum_required(VERSION 3.5)

project(demo_classification)

find_package(OpenCV COMPONENTS opencv_core opencv_video opencv_videoio opencv_imgproc opencv_imgcodecs opencv_highgui REQUIRED)
find_package(vitis_ai_library COMPONENTS classification REQUIRED)
find_package(unilog REQUIRED)
find_package(xir REQUIRED)

add_executable(${PROJECT_NAME} src/demo_classification.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} vitis_ai_library::classification vart::dpu-runner)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
