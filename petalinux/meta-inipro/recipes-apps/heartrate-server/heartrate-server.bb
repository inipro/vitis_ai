LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "file://CMakeLists.txt \
		   file://main.cpp \
"

S = "${WORKDIR}"

DEPENDS = "qtconnectivity"

inherit cmake cmake_qt5

EXTRA_OECMAKE = ""
