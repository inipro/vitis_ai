cmake_minimum_required(VERSION 3.5)

project(tf_resnet50)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(dnndk COMPONENTS n2cube REQUIRED)

add_executable(${PROJECT_NAME} 
			  ../common/dputils.h
			  ../common/dputils.cpp
			  src/main.cc)

          #target_include_directories(${PROJECT_NAME} PRIVATE ../common )

target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} dnndk::n2cube -L${CMAKE_SOURCE_DIR}/model dpumodelresnet_v1_50_tf)


install(TARGETS ${PROJECT_NAME} DESTINATION bin)
