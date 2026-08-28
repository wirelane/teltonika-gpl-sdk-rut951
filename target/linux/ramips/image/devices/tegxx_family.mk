define Device/TEMPLATE_teltonika_teg100
	$(Device/tlt-mt7621-hw-common)
	$(Device/teltonika_teg100)

	DEVICE_NET_CONF :=       \
		vlans          4094, \
		max_mtu        2030, \
		readonly_vlans 1

	DEVICE_LAN_OPTION := "lan1"

	DEVICE_INTERFACE_CONF := \
		lan default_ip 192.168.1.1

	DEVICE_FEATURES := ethernet mobile dual_sim at_sim dsa hw_nat \
		nat_offloading multi_tag port_link gigabit_port xfrm-offload \
		networks_external reset_button dot1x-server ios \
		fxs asterisk sip-gw

	DEVICE_DOT1X_SERVER_CAPABILITIES := false false dsa_isolate

	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.24.2

	HARDWARE/Mobile/Module := 4G LTE Cat 1 up to 10 DL/5 UL Mbps; 3G up to 384 DL/384 UL Kbps; 2G up to 296 DL/236.8 UL Kbps
	HARDWARE/Mobile/Modem := Quectel EC21-EU
	HARDWARE/Mobile/3GPP_Release := Release 12
	HARDWARE/Mobile/eSIM := $(HW_MOBILE_ESIM_CONSTANT)
	TECHNICAL/Power/Connector := $(HW_POWER_CONNECTOR_3PIN)
	TECHNICAL/Power/Input_Voltage_Range := $(HW_POWER_VOLTAGE_4PIN_30V)
	TECHNICAL/Physical_Interfaces/Power :=$(HW_POWER_CONNECTOR_3PIN)
	TECHNICAL/Physical_Interfaces/Status_Leds := 1 x connection status LEDs, 1 x connection strength LEDs, 2 x Ethernet port status LEDs
	TECHNICAL/Physical_Interfaces/Antennas := 2 x SMA for LTE
	TECHNICAL/Physical_Interfaces/SIM := 1 $(HW_INTERFACE_SIM_HOLDERS)
	TECHNICAL/Physical_Interfaces/Ethernet := 1 $(HW_ETH_RJ45_PORTS), $(HW_ETH_SPEED_1000)
	TECHNICAL/Physical_Interfaces/Input_Output := 3 x Digital Input, 3 x Digital Output, 1 x NO and 1 x COM Relay output on 6-pin power connector
	TECHNICAL/Physical_Interfaces/IO :=
	TECHNICAL/Power/Power_Consumption := No Data
	TECHNICAL/Physical_Specification/Dimensions := No Data
	TECHNICAL/Physical_Specification/Weight := No Data

endef
