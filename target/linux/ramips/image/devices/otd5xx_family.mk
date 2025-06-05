define Device/teltonika_otd5_common
	$(Device/tlt-mt7621-hw-common)
	HARDWARE/Wireless/Wireless_mode :=
	HARDWARE/Wireless/WIFI_users :=
	HARDWARE/Ethernet/Port := 2 $(HW_ETH_ETH_PORTS)
	HARDWARE/Ethernet/Speed := $(HW_ETH_SPEED_1000)
	HARDWARE/Ethernet/Standard := (can be configured as WAN), $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_RJ45)
	HARDWARE/Power/Input_voltage_range := $(HW_POWER_VOLTAGE_RJ45)
	HARDWARE/Power/PoE_Standards :=
	HARDWARE/Power/Power_consumption := Idle: < 2.5 W / Max: < 6 W / PoE Max < 21 W
	HARDWARE/Physical_Interfaces/Power := $(HW_INTERFACE_POWER_RJ45)
	HARDWARE/Physical_Interfaces/IO:=
	HARDWARE/Physical_Interfaces/Status_leds := 3 x Mobile connection type, 3 x Mobile connection strength, 4 x ETH status LEDs
	HARDWARE/Physical_Interfaces/SIM := 2 $(HW_INTERFACE_SIM_TRAY)
	HARDWARE/Physical_Interfaces/Antennas := 2 x Internal antennas
	HARDWARE/Physical_Interfaces/Antennas_specifications := 1 x 698 - 960 / 1710 - 2690MHz, 50 Ω, VSWR <3.5, gain <3 dBi, omnidirectional; \
	1 x 698 - 960 / 1710 - 2690MHz, 50 Ω, VSWR <3, gain <4.5 dBi, omnidirectional;
	HARDWARE/PoE_In/PoE_ports := 1 x PoE In
	HARDWARE/PoE_In/PoE_standards := 802.3af/at
	HARDWARE/PoE_Out/PoE_ports := 1 x PoE Out
	HARDWARE/PoE_Out/PoE_standards := 802.3af and 802.3at Alternative B
	HARDWARE/PoE_Out/PoE_Max_Power_per_Port_(at_PSE) := 24 W Max (power supply unit dependent)
	HARDWARE/Operating_Environment/Ingress_Protection_Rating := $(HW_OPERATING_PROTECTION_IP55)
	HARDWARE/Physical_Specification/Casing_material := Plastic (PC+ASA)
	HARDWARE/Physical_Specification/Dimensions := 110 x 49.30 x 235 mm
	HARDWARE/Physical_Specification/Weight := 855 g
	HARDWARE/Physical_Specification/Mounting_options := Mounting Bracket (for vertical flat surface or pole mounting)
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE, UKCA, EAC, UCRF, RCM
endef

define Device/template_otd5_common
	$(Device/teltonika_otd5)

	DEVICE_NET_CONF :=       \
		vlans          16,   \
		max_mtu        2030, \
		readonly_vlans 1,    \
		vlans          4094

	DEVICE_LAN_OPTION := "lan1 lan2"

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1

	DEVICE_POE_CONF := 2 1 _lan2 3 15400

	DEVICE_POE_CHIP := 0X77 0:_lan2, 0X2F 1:_lan2

	DEVICE_DOT1X_SERVER_CAPABILITIES := false false dsa_isolate
endef

define Device/TEMPLATE_teltonika_otd500
	$(Device/teltonika_otd5_common)
	$(Device/template_otd5_common)

	DEVICE_MODEL := OTD500
	DEVICE_INITIAL_FIRMWARE_SUPPORT :=
	DEVICE_FEATURES := ethernet mobile dual_sim at_sim dsa hw_nat \
		nat_offloading multi_tag port_link gigabit_port poe xfrm-offload \
		tpm networks_external reset_button

	HARDWARE/Mobile/Module := 5G Sub-6 GHz SA, NSA 2.4, 3.4Gbps DL (4x4 MIMO) 900, 550Mbps UL (2x2 MIMO); 4G LTE: DL Cat 19 1.6Gbps (4x4 MIMO), UL Cat 18 200Mbps
	HARDWARE/Mobile/3GPP_Release := Release 16
	HARDWARE/Mobile/eSIM := $(HW_MOBILE_ESIM_CONSTANT)
endef

define Device/TEMPLATE_teltonika_otd501
	$(Device/teltonika_otd5_common)
	$(Device/template_otd5_common)

	DEVICE_MODEL := OTD501
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.13.5
	DEVICE_FEATURES := ethernet mobile dual_sim at_sim dsa hw_nat \
		nat_offloading multi_tag port_link gigabit_port poe xfrm-offload \
		tpm networks_external reset_button

	HARDWARE/Mobile/Module := 5G SA: DL 2Gbps,UL 1Gbps; NSA: DL 2.6Gbps, UL 650Mbps; 4G LTE: DL 600 Mbps, UL 150 Mbps;
	HARDWARE/Mobile/3GPP_Release := Release 15
	HARDWARE/Mobile/eSIM := $(HW_MOBILE_ESIM_OPTIONAL)
endef
