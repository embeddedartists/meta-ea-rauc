FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "  \
    file://bootscript_imx8_rauc.cmd \
    file://bootscript_imx9_rauc.cmd \
"

BOOTSCRIPT:mx8m-nxp-bsp = "${WORKDIR}/bootscript_imx8_rauc.cmd"
BOOTSCRIPT:mx93-nxp-bsp = "${WORKDIR}/bootscript_imx9_rauc.cmd"

