FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append := " \
	file://system_imx8.conf \
	file://system_imx9.conf \
	file://rauc-mark-good.service \
	file://fw_rw_bootpart.sh \
"

RDEPENDS:${PN} += "u-boot-fw-utils"
DEPENDS += "u-boot-ea"

do_install:prepend:mx8m-nxp-bsp() {
	cp ${WORKDIR}/system_imx8.conf ${WORKDIR}/system.conf
}

do_install:prepend:mx9-nxp-bsp() {
	cp ${WORKDIR}/system_imx9.conf ${WORKDIR}/system.conf
}

do_install:append() {
	install -Dm 0744 ${WORKDIR}/fw_rw_bootpart.sh  ${D}${sbindir}/fw_rw_bootpart.sh

	sed -i -e 's!@BASE_BINDIR@!${base_bindir}!g' ${D}${systemd_unitdir}/system/*.service
	sed -i -e 's!@SBINDIR@!${sbindir}!g' ${D}${systemd_unitdir}/system/*.service
}

