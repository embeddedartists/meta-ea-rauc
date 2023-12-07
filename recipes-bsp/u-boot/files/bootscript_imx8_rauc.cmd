
test -n "${BOOT_ORDER}" || env set BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || env set BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || env set BOOT_B_LEFT 3

env set boot_part
env set boot_dev
env set rauc_slot

for BOOT_SLOT in "${BOOT_ORDER}"; do
	if test "x${boot_part}" != "x"; then
		# stop checking after selecting a slot

	elif test "x${BOOT_SLOT}" = "xA"; then
		if test ${BOOT_A_LEFT} -gt 0; then
			setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
			echo "Booting RAUC slot A"

			setenv boot_part 2
			setenv rauc_slot "A"
#			setenv boot_dev "mmc 1:2"
			setenv mmcroot "/dev/mmcblk2p3 rootwait rw"
			setenv mmcpart 1
		fi

	elif test "x${BOOT_SLOT}" = "xB"; then
		if test ${BOOT_B_LEFT} -gt 0; then
			setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
			echo "Booting RAUC slot B"

			setenv boot_part 3
			setenv rauc_slot "B"
#			setenv boot_dev "mmc 1:3"
			setenv mmcroot "/dev/mmcblk2p4 rootwait rw"
			setenv mmcpart 2
		fi
	fi
done

# Only use the bsp_bootcmd. Default is first to use distro_bootcmd
setenv bootcmd "run bsp_bootcmd"

if test -n "${boot_part}"; then
	saveenv
else
	echo "No valid RAUC slot found. Resetting attempts to 3"
	setenv BOOT_A_LEFT 3
	setenv BOOT_B_LEFT 3
	saveenv
	reset
fi


setenv args_from_script ''

if run loadfdt ; then
	fdt addr ${fdt_addr}
	setenv fdt_high 0xffffffff
else
	echo "!!!! Error loading ${fdt_file}";
	reset;
fi

fdt resize
if itest.s "x" != "x${cmd_custom}" ; then
	run cmd_custom
fi

if itest.s "x" != "x${extra_bootargs}" ; then
	setenv args_from_script "${args_from_script} ${extra_bootargs}"
fi

#
# Kernel command-line parameters
#   rauc.slot: condition for the rauc-mark-good service to start
#   panic: reboot the kernel in case of a kernel panic
#
setenv args_from_script "${args_from_script} rauc.slot=${rauc_slot} panic=30"

if run loadimage; then
	run mmcargs;
	booti ${loadaddr} - ${fdt_addr}
else
	echo "Failed to load the kernel";
	reset;
fi
