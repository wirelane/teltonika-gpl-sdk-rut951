define Device/teltonika_rut14x_common
	$(Device/tlt-mt7628-hw-common)
	HARDWARE/WAN/Port := 1 $(HW_ETH_WAN_PORT)
	HARDWARE/WAN/Speed :=$(HW_ETH_SPEED_100)
	HARDWARE/WAN/Standard := $(HW_ETH_WAN_STANDARD)
	HARDWARE/LAN/Port := 1 $(HW_ETH_LAN_PORT)
	HARDWARE/LAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/LAN/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Wireless/WIFI_users  := $(HW_WIFI_50_USERS)
	HARDWARE/Wireless/Wireless_mode := $(HW_WIFI_4)
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_3PIN)
	HARDWARE/Power/Power_consumption := Idle:< 1 W / Max:< 2 W
	HARDWARE/Physical_Interfaces/IO :=
	HARDWARE/Physical_Interfaces/Power := 1 x 3-pin power connector
	HARDWARE/Physical_Interfaces/Status_leds := 1 x WAN type LED, 1 x LAN type LED, 1 x Power LED
	HARDWARE/Physical_Interfaces/Antennas := 1 x RP-SMA for Wi-Fi
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_AL)
	HARDWARE/Physical_Specification/Dimensions := 113.10 x 25 x 68.6 mm
	HARDWARE/Physical_Specification/Mounting_options := Integrated DIN rail bracket
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE/RED, UKCA, CB, RCM, FCC, IC, EAC, UCRF, WEEE
endef

define Device/template_rut14x
	$(Device/teltonika_rut14x)

	DEVICE_SWITCH_CONF := switch0 1:lan 0:wan:2 6@eth0

	DEVICE_WLAN_BSSID_LIMIT := wlan0 4

	DEVICE_NET_CONF :=       \
		vlans          16,   \
		max_mtu        1500, \
		readonly_vlans 2,    \
		vlan0          true

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1

	DEVICE_DOT1X_SERVER_CAPABILITIES := false false vlan

	DEVICE_FEATURES := wifi nat_offloading ethernet port_link xfrm-offload

	DEVICE_INITIAL_FIRMWARE_SUPPORT :=
endef

define Device/TEMPLATE_teltonika_rut140
	$(Device/teltonika_rut14x_common)
	$(Device/template_rut14x)
	DEVICE_MODEL := RUT140

	HARDWARE/Physical_Specification/Weight := 142.3 g
endef

define Device/TEMPLATE_teltonika_rut142
	$(Device/teltonika_rut14x_common)
	$(Device/template_rut14x)
	DEVICE_MODEL := RUT142
	DEVICE_FEATURES += rs232
	DEVICE_SERIAL_CAPABILITIES := \
	"rs232"                                                           \
		"300 600 1200 2400 4800 9600 19200 38400 57600 115200"        \
		"5 6 7 8"                                                     \
		"rts/cts xon/xoff none"                                       \
		"1 2"                                                         \
		"even odd mark space none"                                    \
		"none"                                                        \
		"/usb1/1-1/1-1:1.0/",                                         \

	HARDWARE/Physical_Interfaces/RS232 := 1 $(HW_INTERFACE_RS232_DB9)
	HARDWARE/Physical_Specification/Weight := 149.2 g
endef
