FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:mx8m-nxp-bsp = " file://fstab_imx8"
SRC_URI:append:mx9-nxp-bsp = " file://fstab_imx9"

do_install:append:mx8m-nxp-bsp(){
	install -m 0644 ${WORKDIR}/fstab_imx8 ${D}${sysconfdir}/fstab
}

do_install:append:mx9-nxp-bsp(){
	install -m 0644 ${WORKDIR}/fstab_imx9 ${D}${sysconfdir}/fstab
}
