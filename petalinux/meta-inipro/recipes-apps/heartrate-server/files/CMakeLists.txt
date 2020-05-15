#Specify the minimum version of CMake (3.5 is currently recommended by Qt)
cmake_minimum_required(VERSION 3.5)

# Specify project title
project(heartbeat-server)


# Take care of Qt dependencies
find_package(Qt5 COMPONENTS Core Bluetooth REQUIRED)

# add required source, header, ui and resource files
add_executable(${PROJECT_NAME} main.cpp )

# link required libs
target_link_libraries(${PROJECT_NAME} Qt5::Core Qt5::Bluetooth)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)
