cmake_minimum_required(VERSION 3.5)

project(demo_classification)

set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX "-I")

find_package(OpenCV REQUIRED)
find_package(vitis_ai_library COMPONENTS classification REQUIRED)

add_executable(${PROJECT_NAME} demo_classification.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE ${OpenCV_LIBS} vitis_ai_library::classification vart::runner)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
