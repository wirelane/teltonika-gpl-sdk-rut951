define Device/TEMPLATE_teltonika_rut301
	$(Device/tlt-mt7628-hw-common)
	$(Device/teltonika_rut301)

	DEVICE_SWITCH_CONF := switch0 0:lan:1 1:lan:2 \
		2:lan:3 3:lan:4 4:wan 6@eth0

	DEVICE_NET_CONF :=       \
		vlans          16,   \
		max_mtu        1500, \
		readonly_vlans 2,    \
		vlan0          true

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1

	DEVICE_USB_JACK_PATH := /usb1/1-1/

	DEVICE_USB_JACK_PATH_LOW_SPEED := /usb2/2-1/

	DEVICE_FEATURES := usb ethernet ios nat_offloading port_link xfrm-offload

	DEVICE_INITIAL_FIRMWARE_SUPPORT :=

	HARDWARE/Mobile/Module := 4G LTE Cat 6 up to 300 DL/ 50 UL Mbps; 3G up to 42 DL/ 5.76 UL Mbps
	HARDWARE/Mobile/3GPP_Release := Release 12
	HARDWARE/System_Characteristics/Flash_Storage := $(HW_FLASH_SIZE_16M) $(HW_FLASH_TYPE_NOR_SERIAL)
	HARDWARE/Wireless/Wireless_mode :=
	HARDWARE/Wireless/WIFI_users :=
	HARDWARE/WAN/Port := 1 $(HW_ETH_WAN_PORT)
  	HARDWARE/WAN/Speed := $(HW_ETH_SPEED_100)
  	HARDWARE/WAN/Standard := $(HW_ETH_WAN_STANDARD)
  	HARDWARE/LAN/Port := 4 $(HW_ETH_LAN_PORTS)
  	HARDWARE/LAN/Speed := $(HW_ETH_SPEED_100)
  	HARDWARE/LAN/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Power/PoE_Standards := $(HW_POWER_POE_INSTALL)
	HARDWARE/Power/Power_consumption := Idle:< 0.8 W, Max:< 3.8 W
	HARDWARE/Physical_Interfaces/Ethernet := 5 $(HW_ETH_RJ45_PORTS), $(HW_ETH_SPEED_100)
	HARDWARE/Physical_Interfaces/IO := $(HW_INTERFACE_IO_4PIN_IOS)
	HARDWARE/Physical_Interfaces/Status_leds := 1 x WAN type LED, 4 x LAN status LEDs, 1 x Power LED
	HARDWARE/Physical_Interfaces/USB := 1 $(HW_INTERFACE_USB)
	HARDWARE/USB/Data_rate := $(HW_USB_2_DATA_RATE)
	HARDWARE/USB/Applications := $(HW_USB_APPLICATIONS)
	HARDWARE/USB/External_devices := $(HW_USB_EXTERNAL_DEV)
	HARDWARE/USB/Storage_formats := $(HW_USB_STORAGE_FORMATS)
	HARDWARE/Input_Output/Input := 2 $(HW_INPUT_DI_30V)
	HARDWARE/Input_Output/Output := 2 $(HW_OUTPUT_DO_40V)
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_AL)
	HARDWARE/Physical_Specification/Dimensions := 100 x 30 x 85 mm
	HARDWARE/Physical_Specification/Weight := 233 g
	HARDWARE/Physical_Specification/Mounting_options := $(HW_PHYSICAL_MOUNTING)
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE, UKCA, RCM, FCC, IC, CB, EAC, UCRF, WEEE
	HARDWARE/Physical_Interfaces/Status_leds := 1 x WAN type LED, 4 x LAN status LEDs, 1 x Power LED
endef

define Device/TEMPLATE_teltonika_rut361
	$(Device/tlt-mt7628-hw-common)
	$(Device/teltonika_rut361)

	DEVICE_SWITCH_CONF := switch0 1:lan 0:wan:2 6@eth0

	DEVICE_WLAN_BSSID_LIMIT := wlan0 4

	DEVICE_CHECK_PATH := usb_check /sys/bus/usb/drivers/usb/1-1 reboot

	DEVICE_DOT1X_SERVER_CAPABILITIES := false false vlan

	DEVICE_NET_CONF :=       \
		vlans          16,   \
		max_mtu        1500, \
		readonly_vlans 2,    \
		vlan0          true

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1

	DEVICE_FEATURES := mobile wifi ethernet nat_offloading port_link xfrm-offload

	DEVICE_INITIAL_FIRMWARE_SUPPORT :=

	HARDWARE/System_Characteristics/Flash_Storage := $(HW_FLASH_SIZE_16M) $(HW_FLASH_TYPE_NOR_SERIAL)
	HARDWARE/Wireless/Wireless_mode := 802.11 b/g/n, 2x2 MIMO
	HARDWARE/Wireless/WIFI_users := $(HW_WIFI_50_USERS)
	HARDWARE/WAN/Port := 1 $(HW_ETH_WAN_PORT)
	HARDWARE/WAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/WAN/Standard := $(HW_ETH_WAN_STANDARD)
	HARDWARE/LAN/Port := 1 $(HW_ETH_LAN_PORT)
	HARDWARE/LAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/LAN/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Power/PoE_Standards := $(HW_POWER_POE_INSTALL)
	HARDWARE/Power/Power_consumption := Idle:< 2.4 W, Max:< 4.7 W
	HARDWARE/Physical_Interfaces/IO := $(HW_INTERFACE_IO_4PIN_IOS)
	HARDWARE/Physical_Interfaces/Status_leds := 2 x Mobile connection type, 3 x Mobile connection strength, 2 x Eth status, 1 x Power
	HARDWARE/Physical_Interfaces/SIM := 1 $(HW_INTERFACE_SIM_HOLDER)
	HARDWARE/Physical_Interfaces/Antennas := 2 x SMA for LTE, 2 x RP-SMA for Wi-Fi
	HARDWARE/Input_Output/Input := 2 $(HW_INPUT_DI_30V)
	HARDWARE/Input_Output/Output := 2 $(HW_OUTPUT_DO_30V)
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_AL)
	HARDWARE/Physical_Specification/Dimensions := 100 x 30 x 85 mm
	HARDWARE/Physical_Specification/Weight := 243 g
	HARDWARE/Physical_Specification/Mounting_options := $(HW_PHYSICAL_MOUNTING)
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE, UKCA, RCM, UCRF, EAC, WEEE, CB
endef
