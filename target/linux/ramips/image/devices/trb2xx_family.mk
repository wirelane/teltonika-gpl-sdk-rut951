define Device/teltonika_trb2m_common
	$(Device/tlt-mt7628-hw-common)
	HARDWARE/Wireless/Wireless_mode :=
	HARDWARE/Wireless/WIFI_users :=
	HARDWARE/Ethernet/Port :=1 $(HW_ETH_ETH_PORT)
	HARDWARE/Ethernet/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/Ethernet/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_16PIN)
	HARDWARE/Power/Input_voltage_range := $(HW_POWER_VOLTAGE_16PIN)
	HARDWARE/Power/PoE_Standards :=
	HARDWARE/Physical_Interfaces/Ethernet := 1 $(HW_ETH_RJ45_PORT), $(HW_ETH_SPEED_100)
	HARDWARE/Physical_Interfaces/Power := $(HW_INTERFACE_POWER_16PIN)
	HARDWARE/Physical_Interfaces/IO := $(HW_INTERFACE_IO_16PIN)
	HARDWARE/Physical_Interfaces/Status_leds := 3 x connection status LEDs, 3 x connection strength LEDs, 1 x power LED, 1 x Eth port status LED
	HARDWARE/Physical_Interfaces/SIM := 2 $(HW_INTERFACE_SIM_TRAY)
	HARDWARE/Physical_Interfaces/Antennas := 1 x SMA connector for LTE, 1 x SMA connector for GNSS
	HARDWARE/Physical_Interfaces/RS232 := $(HW_INTERFACE_RS232_4PIN)
	HARDWARE/Physical_Interfaces/RS485 := $(HW_INTERFACE_RS485_4PIN)
	HARDWARE/Input_Output/Input := 3 $(HW_INPUT_DI_30V)
	HARDWARE/Input_Output/Output := 3 $(HW_OUTPUT_DO_30V)
	HARDWARE/Serial/RS232 := Terminal block connector:TX, RX, RTS, CTS
	HARDWARE/Serial/RS485 := Terminal block connector:D+, D-, R+, R- (2 or 4 wire interface)
	HARDWARE/Serial/Serial_functions := Console, Serial over IP, Modem, MODBUS gateway, NTRIP Client
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_AL)
	HARDWARE/Physical_Specification/Dimensions := 83 x 25 x 74.2 mm
	HARDWARE/Physical_Specification/Weight := 165 g
	HARDWARE/Physical_Specification/Mounting_options := $(HW_PHYSICAL_MOUNTING)
endef

define Device/template_trb2m
	$(Device/teltonika_trb2m)

	DEVICE_CHECK_PATH := usb_check /sys/bus/usb/drivers/usb/1-1/1-1.4 reboot

	DEVICE_NET_CONF :=       \
		vlans          16,   \
		max_mtu        1500, \
		vlan0          true

	DEVICE_INTERFACE_CONF := \
		lan device eth0 default_ip 192.168.1.1

	DEVICE_FEATURES := dual_sim mobile gps ethernet ios rs232 rs485 \
		sw_rst_on_init xfrm-offload nat_offloading

	DEVICE_DOT1X_SERVER_CAPABILITIES := false false single_port

	DEVICE_SERIAL_CAPABILITIES := \
		"rs232"                                                           \
			"300 600 1200 2400 4800 9600 19200 38400 57600 115200"        \
			"7 8"                                                         \
			"rts/cts xon/xoff none"                                       \
			"1 2"                                                         \
			"even odd mark space none"                                    \
			"none"                                                        \
			"/usb1/1-1/1-1.3/",                                           \
		"rs485"                                                           \
			"300 600 1200 2400 4800 9600 19200 38400 57600 115200 230400" \
			"5 6 7 8"                                                     \
			"xon/xoff none"                                               \
			"1 2"                                                         \
			"even odd mark space none"                                    \
			"half full"                                                   \
			"/tty/ttyS1"

	DEVICE_INITIAL_FIRMWARE_SUPPORT :=
endef

define Device/TEMPLATE_teltonika_trb246
	$(Device/teltonika_trb2m_common)
	$(Device/template_trb2m)
	DEVICE_MODEL := TRB246
	HARDWARE/Power/Power_consumption := Idle:< 1.5 W, Max:< 3.5 W
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE, UKCA, RCM, CB, EAC, UCRF, WEEE
endef

define Device/TEMPLATE_teltonika_trb247
	$(Device/teltonika_trb2m_common)
	$(Device/template_trb2m)
	DEVICE_MODEL := TRB247

	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.10.2
endef

define Device/TEMPLATE_teltonika_trb256
	$(Device/teltonika_trb2m_common)
	$(Device/template_trb2m)
	DEVICE_MODEL := TRB256
	HARDWARE/Power/Power_consumption := Idle:< 2 W, Max:< 35 W
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE, UKCA, EAC, CB
	HARDWARE/EMC_Emissions_&_Immunity/Standards := $(HW_EI_STANDARDS_EN_55032) + A1:2020; $(HW_EI_STANDARDS_EN_55035); EN IEC 61000-3-2:2019 + A1:2021; \
	EN 61000-3-3:2013 + A1:2019 + A2:2021; $(HW_EI_STANDARDS_EN_301_489-1_V2.2.3); EN 301 489-19 V2.2.1; $(HW_EI_STANDARDS_EN_301_489-52_V1.2.1);
	HARDWARE/EMC_Emissions_&_Immunity/ESD := $(HW_IMUNITY_EMISION_ESD)
	HARDWARE/EMC_Emissions_&_Immunity/Radiated_Immunity := EN IEC 61000-4-3:2020
	HARDWARE/EMC_Emissions_&_Immunity/EFT := $(HW_IMUNITY_EMISION_EFT)
	HARDWARE/EMC_Emissions_&_Immunity/Surge_Immunity_(AC_Mains_Power_Port) := $(HW_IMUNITY_EMISION_SURGE)
	HARDWARE/EMC_Emissions_&_Immunity/CS := $(HW_IMUNITY_EMISION_CS)
	HARDWARE/EMC_Emissions_&_Immunity/DIP := $(HW_IMUNITY_EMISION_DIP)
	HARDWARE/RF/Standards := $(HW_RF_EN_301_908-1_V15.2.1); $(HW_RF_EN_301_908-13_V13.2.1); EN 303 413 V1.2.1;
	HARDWARE/Safety/Standards := CE:$(HW_SAFETY_EN_IEC_62368-1), $(HW_SAFETY_EN_IEC_62311); RCM:$(HW_SAFETY_AS/NZS_62368); CB:$(HW_SAFETY_IEC_62368-1);
endef
