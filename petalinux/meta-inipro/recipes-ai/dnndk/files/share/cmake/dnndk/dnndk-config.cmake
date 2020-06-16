include("${CMAKE_CURRENT_LIST_DIR}/n2cube-targets.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/hineon-targets.cmake")

get_target_property(TARGET_LOCATION dnndk::n2cube LOCATION)
message(STATUS "Found importable target dnndk::n2cube: ${TARGET_LOCATION}")
get_target_property(TARGET_LOCATION dnndk::hineon LOCATION)
message(STATUS "Found importable target dnndk::hineon: ${TARGET_LOCATION}")

get_filename_component(dnndk_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(dnndk_INCLUDE_DIRS "${dnndk_CMAKE_DIR}/../../../include")

