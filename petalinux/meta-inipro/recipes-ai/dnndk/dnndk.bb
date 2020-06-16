LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

inherit python3native

SRC_URI = "file://*"

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
	install -d ${D}${bindir}
	install -d ${D}${includedir}/vai
	install -d ${D}${includedir}/dnndk
	install -d ${D}${libdir}
	install -d ${D}${datadir}/cmake/dnndk
	install -m 0655 ${S}/bin/* ${D}${bindir}
	install -m 0644 ${S}/include/vai/* ${D}${includedir}/vai
	install -m 0644 ${S}/include/dnndk/* ${D}${includedir}/dnndk
	install -m 0644 ${S}/lib/* ${D}${libdir}
	export TMPDIR="${S}"
    install -d ${D}/${PYTHON_SITEPACKAGES_DIR}
	${STAGING_BINDIR_NATIVE}/pip3 install --disable-pip-version-check -v \
		-t ${D}/${PYTHON_SITEPACKAGES_DIR} --no-cache-dir --no-deps \
			${S}/python/Edge_Vitis_AI-1.1-py2.py3-none-any.whl
	install -m 0644 ${S}/share/cmake/dnndk/* ${D}${datadir}/cmake/dnndk
}

DEPENDS = "python3 python3-pip-native python3-wheel-native"
RDEPENDS_${PN} = "xrt"
FILES_${PN} = "/usr"
FILES_${PN}-dev_remove = "${libdir}/lib*.so"
