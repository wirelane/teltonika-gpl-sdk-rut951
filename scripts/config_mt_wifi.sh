#!/usr/bin/env bash

if [[ ! -f .config && ! -L .config ]]; then
	echo ".config file not found"
	exit 1
elif grep -q '^CONFIG_TARGET_mediatek=y$' .config; then
	sed -i \
		-e 's/^\(CONFIG_PACKAGE_wifi-scripts\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_wireless-regdb\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_iw-66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt76-connac_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt76-core_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt7915e_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt7981-firmware_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt7986-firmware_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mac80211_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-cfg80211_66\)=y$/# \1 is not set/' \
		-e 's/^# \(CONFIG_PACKAGE_kmod-mt_wifi\) is not set$/\1=y/' \
		.config
elif grep -q '^CONFIG_TARGET_ramips=y$' .config; then
	sed -i \
		-e '/^# CONFIG_KERNEL_PAGE_POOL_STATS is not set$/ d' \
		-e '/^# CONFIG_PACKAGE_CFG80211_TESTMODE is not set$/ d' \
		-e '/^# CONFIG_PACKAGE_mt76-test_66 is not set$/ d' \
		-e '/^CONFIG_PACKAGE_MAC80211_DEBUGFS=y$/ d' \
		-e '/^CONFIG_PACKAGE_MAC80211_MESH=y$/ d' \
		-e '/^# CONFIG_PACKAGE_MAC80211_TRACING is not set$/ d' \
		-e 's/^\(CONFIG_DRIVER_11N_SUPPORT\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_DRIVER_11AC_SUPPORT\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_KERNEL_PAGE_POOL\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_iw-66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt76-connac_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt76-core_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt7615-common_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt7615-firmware_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mt7615e_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-mac80211_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_kmod-cfg80211_66\)=y$/# \1 is not set/' \
		-e 's/^\(CONFIG_PACKAGE_wireless-regdb\)=y$/# \1 is not set/' \
		-e 's/^# \(CONFIG_PACKAGE_kmod-mt7615d_dbdc\) is not set$/\1=y/' \
		.config
else
	echo "unsupported target"
	exit 1
fi

./scripts/config/conf --defconfig=.config Config.in
