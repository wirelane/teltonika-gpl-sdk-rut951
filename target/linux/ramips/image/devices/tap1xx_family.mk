define Device/TEMPLATE_teltonika_tap100
	$(Device/tlt-mt7628-hw-common)
	$(Device/teltonika_tap100)

	DEVICE_NET_CONF :=       \
		ula           false, \
		disable_vlan  true,  \
		ip6assign     false, \
		vlans         16,    \
		no_metric     true,  \
		max_mtu       1500

	DEVICE_WLAN_BSSID_LIMIT := wlan0 4

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.3 device eth0 ipv6 0 fallback 1 proto dhcp, \
		dhcp6 device br-lan proto dhcpv6

	DEVICE_FEATURES := wifi ethernet sw_rst_on_init

	DEVICE_INITIAL_FIRMWARE_SUPPORT :=

	HARDWARE/System_Characteristics/RAM := $(HW_RAM_SIZE_64M) $(HW_RAM_TYPE_DDR2)
	HARDWARE/Ethernet/Port :=1 $(HW_ETH_RJ45_PORT)
	HARDWARE/Ethernet/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/Ethernet/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Wireless/Wireless_mode := $(HW_WIFI_4), 2x2 MIMO
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_RJ45)
	HARDWARE/Power/Input_voltage_range := $(HW_POWER_VOLTAGE_POE_2)
	HARDWARE/Power/PoE_Standards := $(HW_POE_STD_80203AF)
	HARDWARE/Power/Power_consumption := < 2 W Max
	HARDWARE/Physical_Interfaces/Power :=
	HARDWARE/Physical_Interfaces/IO :=
	HARDWARE/Physical_Interfaces/Ethernet := 1 $(HW_ETH_RJ45_PORT), $(HW_ETH_SPEED_100)
	HARDWARE/Physical_Interfaces/Status_leds := 1 x Power LED, 1 x ETH status LED
	HARDWARE/Physical_Interfaces/Antennas := 2 x Internal for 2.4 GHz Wi-Fi
	HARDWARE/Physical_Interfaces/Antennas_specifications := 2 x 2400 - 2500 MHz, 50 Ω, VSWR <2.7, gain < 4.9 dBi, omnidirectional
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_UV_PLASTIC)
  	HARDWARE/Physical_Specification/Dimensions := 158 mm x 30 mm
  	HARDWARE/Physical_Specification/Weight := 190 g
  	HARDWARE/Physical_Specification/Mounting_options := AP Mounting Bracket (for ceiling mount)
	HARDWARE/Operating_Environment/Operating_Temperature := $(HW_OPERATING_TEMP)
  	HARDWARE/Operating_Environment/Operating_Humidity := $(HW_OPERATING_HUMIDITY)
  	HARDWARE/Operating_Environment/Ingress_Protection_Rating := $(HW_OPERATING_PROTECTION_IP30)
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory :=  CE, UKCA, CB, FCC, IC, WEEE
	HARDWARE/EMC_Emissions_&_Immunity/Standards := EN 55032:2015+A11:2020; \
	EN 55035:2017+A11:2020; EN 61000-3-3:2013+A1:2019+A2:2021;\
	$(HW_EI_STANDARDS_EN_IEC_61000-3-2)+A1:2021; $(HW_EI_STANDARDS_EN_301_489-1_V2.2.3); $(HW_EI_STANDARDS_EN_301_489-17_V3.2.4);
  	HARDWARE/EMC_Emissions_&_Immunity/ESD := $(HW_IMUNITY_EMISION_ESD)
  	HARDWARE/EMC_Emissions_&_Immunity/Radiated_Immunity := EN IEC 61000-4-3:2020
  	HARDWARE/EMC_Emissions_&_Immunity/EFT := $(HW_IMUNITY_EMISION_EFT)
  	HARDWARE/EMC_Emissions_&_Immunity/Surge_Immunity_(AC_Mains_Power_Port) := $(HW_IMUNITY_EMISION_SURGE)
  	HARDWARE/EMC_Emissions_&_Immunity/CS := $(HW_IMUNITY_EMISION_CS)
  	HARDWARE/EMC_Emissions_&_Immunity/DIP := EN IEC 61000-4-11:2020
  	HARDWARE/RF/Standards := $(HW_RF_EN_300_328_V2.2.2)
	HARDWARE/Safety/Standards := IEC 62368-1:2018; EN IEC 62368-1:2020+A11:2020; EN IEC 62311:2020;
endef
