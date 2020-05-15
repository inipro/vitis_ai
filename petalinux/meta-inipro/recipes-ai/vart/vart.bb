LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "file://${@bb.utils.contains('AI_VERSION', 'vivado', 'vivado/libvart-1.1.0-Linux.deb', 'libvart-1.1.0-Linux-build48.deb', d)}"

python do_unpack() {
    src_uri = (d.getVar('SRC_URI') or "").split()
    if len(src_uri) == 0:
        return
    try:
        fetcher = bb.fetch2.Fetch(src_uri, d)
        fetcher.unpack(d.getVar('S'))
    except bb.fetch2.BBFetchException as e:
        bb.fatal(str(e))
}

do_install() {
	mv ${S}/usr ${D}
	chown -R root:root ${D}${bindir}
	chown -R root:root ${D}${libdir}
	chown -R root:root ${D}${datadir}/vart
	chown -R root:root ${D}${datadir}/cmake/vart
}

FILES_${PN} += "/usr/lib/python3.5/site-packages/runner.so"
RDEPENDS_${PN} = "glog json-c openssl xir python3 xrt"
