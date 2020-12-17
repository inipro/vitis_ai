cmake_minimum_required(VERSION 3.5)

project(resnet50)

#set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV COMPONENTS opencv_core opencv_videoio opencv_imgproc opencv_imgcodecs opencv_highgui REQUIRED)
find_package(vart COMPONENTS runner REQUIRED)
find_package(unilog REQUIRED)
find_package(xir REQUIRED)

add_executable(${PROJECT_NAME} 
			  ../common/common.h
			  ../common/common.cpp
			  src/main.cc)

target_include_directories(${PROJECT_NAME} PRIVATE ../common)

target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} vart::runner)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
