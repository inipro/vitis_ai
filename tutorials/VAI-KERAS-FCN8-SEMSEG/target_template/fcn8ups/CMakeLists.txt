cmake_minimum_required(VERSION 3.5)

project(fcn8ups)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(dnndk COMPONENTS n2cube REQUIRED)

add_executable(${PROJECT_NAME} 
			  src/fps_main.cc)

target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} dnndk::n2cube ${CMAKE_SOURCE_DIR}/model/dpu_${PROJECT_NAME}.elf) 

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
