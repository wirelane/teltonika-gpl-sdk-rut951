define Device/TEMPLATE_teltonika_tap200
	$(Device/tlt-mt7621-hw-common)
	$(Device/teltonika_tap200)

	DEVICE_NET_CONF :=       \
		ula           false, \
		disable_vlan  true,  \
		ip6assign     false, \
		vlans         16,    \
		no_metric     true,  \
		max_mtu       2030

	DEVICE_WLAN_BSSID_LIMIT := wlan0 16, wlan1 16

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.3 device eth1 ipv6 0 fallback 1 proto dhcp, \
		dhcp6 device br-lan proto dhcpv6

	DEVICE_CHECK_PATH := pcie_check /sys/class/pci_bus/0000:00 reboot

	DEVICE_FEATURES := wifi ethernet sw_rst_on_init dual_band_ssid single_port

	DEVICE_INITIAL_FIRMWARE_SUPPORT :=

	HARDWARE/System_Characteristics/Flash_Storage := $(HW_FLASH_SIZE_16M) $(HW_FLASH_TYPE_NOR_SERIAL), $(HW_FLASH_SIZE_128M) $(HW_FLASH_TYPE_NAND_SERIAL)
	HARDWARE/Ethernet/Port :=1 $(HW_ETH_RJ45_PORT)
	HARDWARE/Ethernet/Speed := $(HW_ETH_SPEED_1000)
	HARDWARE/Ethernet/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Wireless/WIFI_users := $(HW_WIFI_100_USERS)
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_RJ45)
	HARDWARE/Power/Input_voltage_range := $(HW_POWER_VOLTAGE_POE_2)
	HARDWARE/Power/PoE_Standards := $(HW_POE_STD_80203AF)
	HARDWARE/Power/Power_consumption := Idle < 4 W / Max < 5.5 W
	HARDWARE/Physical_Interfaces/Power :=
	HARDWARE/Physical_Interfaces/IO :=
	HARDWARE/Physical_Interfaces/Ethernet := 1 $(HW_ETH_RJ45_PORT), $(HW_ETH_SPEED_1000)
	HARDWARE/Physical_Interfaces/Status_leds := 1 x Power LED (can be turned off from web-UI)
	HARDWARE/Physical_Interfaces/Antennas := 2 x Internal for 2.4 GHz Wi-Fi, 2 x Internal for 5 GHz Wi-Fi
	HARDWARE/Physical_Interfaces/Antennas_specifications := 2 x 2400 - 2500 MHz, 50 Ω, VSWR <2.7, gain < 4.9 dBi, omnidirectional \
	2 x 5150 - 5850 MHz, 50 Ω, VSWR <2, gain < 5.02 dBi, omnidirectional
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_UV_PLASTIC)
	HARDWARE/Physical_Specification/Dimensions := 158 mm x 30 mm
	HARDWARE/Physical_Specification/Weight := 190 g
	HARDWARE/Physical_Specification/Mounting_options := AP Mounting Bracket (for ceiling mount)
	HARDWARE/Operating_Environment/Operating_Temperature := $(HW_OPERATING_TEMP)
	HARDWARE/Operating_Environment/Operating_Humidity := $(HW_OPERATING_HUMIDITY)
	HARDWARE/Operating_Environment/Ingress_Protection_Rating := $(HW_OPERATING_PROTECTION_IP30)
endef
