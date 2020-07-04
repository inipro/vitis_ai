cmake_minimum_required(VERSION 3.5)

project(miniVggNet)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(dnndk COMPONENTS n2cube REQUIRED)

add_executable(${PROJECT_NAME} 
			  ../../common/dputils.h
			  ../../common/dputils.cpp
			  src/top5_tf_main.cc)

add_executable(fps_${PROJECT_NAME} 
			  ../../common/dputils.h
			  ../../common/dputils.cpp
			  src/fps_tf_main.cc)

target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} dnndk::n2cube ${CMAKE_SOURCE_DIR}/model/nor_dpu_${PROJECT_NAME}_0.elf) 
target_link_libraries(fps_${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} dnndk::n2cube ${CMAKE_SOURCE_DIR}/model/nor_dpu_${PROJECT_NAME}_0.elf) 

install(TARGETS ${PROJECT_NAME} fps_${PROJECT_NAME} DESTINATION bin)
