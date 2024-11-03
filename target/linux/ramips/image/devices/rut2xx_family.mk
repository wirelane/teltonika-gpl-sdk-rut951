define Device/teltonika_rut2m_common
	$(Device/tlt-mt7628-hw-common)
	HARDWARE/Wireless/WIFI_users := $(HW_WIFI_50_USERS)
	HARDWARE/Wireless/Wireless_mode := $(HW_WIFI_4), Access Point (AP), Station (STA)
	HARDWARE/WAN/Port := 1 $(HW_ETH_WAN_PORT)
	HARDWARE/WAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/WAN/Standard := $(HW_ETH_WAN_STANDARD)
	HARDWARE/LAN/Port := 1 $(HW_ETH_LAN_PORT)
	HARDWARE/LAN/Speed := $(HW_ETH_SPEED_100)
	HARDWARE/LAN/Standard := $(HW_ETH_LAN_STANDARD)
	HARDWARE/Power/Power_consumption := < 6.5 W Max
	HARDWARE/Physical_Interfaces/Status_leds := 3 x Connection type status LEDs, 5 x Connection strength LEDs, 2 x LAN status LEDs, 1 x Power LED
	HARDWARE/Physical_Interfaces/SIM := 1 $(HW_INTERFACE_SIM_HOLDER)
	HARDWARE/Physical_Interfaces/Antennas := 2 x SMA for LTE, 1 x RP-SMA for Wi-Fi antenna connectors
	HARDWARE/Input_Output/Input := 1 $(HW_INPUT_DI_30V)
	HARDWARE/Input_Output/Output := 1 $(HW_OUTPUT_DO_30V)
	HARDWARE/Physical_Specification/Casing_material := $(HW_PHYSICAL_HOUSING_AL_PL)
	HARDWARE/Physical_Specification/Dimensions := 83 x 25 x 74 mm
	HARDWARE/Physical_Specification/Weight := 125 g
	HARDWARE/Physical_Specification/Mounting_options := Bottom and sideways DIN rail mounting slots
endef

define Device/TEMPLATE_teltonika_rut200
	$(Device/teltonika_rut2m_common)
	DEVICE_MODEL := RUT200
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE, UKCA, RCM, EAC, Anatel, ANRT, Kenya, ICASA, NCC, \
	ETA-WPC, SIRIM, IMDA, NTC, NBTC, MTC NOM, E-mark, CB, RoHS, REACH, R118
	HARDWARE/EMC_Emissions_&_Immunity/Standards := EN 55032:2015 + A1:2020; $(HW_EI_STANDARDS_EN_55035); $(HW_EI_STANDARDS_EN_IEC_61000-3-2); \
	$(HW_EI_STANDARDS_EN_61000-3-3); $(HW_EI_STANDARDS_EN_301_489-1_V2.2.3); $(HW_EI_STANDARDS_EN_301_489-17_V3.2.4); $(HW_EI_STANDARDS_EN_301_489-52_V1.2.1);
	HARDWARE/EMC_Emissions_&_Immunity/ESD := $(HW_IMUNITY_EMISION_ESD)
	HARDWARE/EMC_Emissions_&_Immunity/Radiated_Immunity := EN IEC 61000-4-3:2020
	HARDWARE/EMC_Emissions_&_Immunity/EFT := $(HW_IMUNITY_EMISION_EFT)
	HARDWARE/EMC_Emissions_&_Immunity/Surge_Immunity_(AC_Mains_Power_Port) := $(HW_IMUNITY_EMISION_SURGE)
	HARDWARE/EMC_Emissions_&_Immunity/CS := $(HW_IMUNITY_EMISION_CS)
	HARDWARE/EMC_Emissions_&_Immunity/DIP := $(HW_IMUNITY_EMISION_DIP)
	HARDWARE/RF/Standards := $(HW_RF_EN_300_328_V2.2.2); $(HW_RF_EN_301_511_V12.5.1); $(HW_RF_EN_301_908-1_V15.1.1); $(HW_RF_EN_301_908-2_V13.1.1); \
	$(HW_RF_EN_301_908-13-V13.1.1)
	HARDWARE/Safety/Standards := CE:$(HW_SAFETY_EN_IEC_62368-1), $(HW_SAFETY_EN_IEC_62311), $(HW_SAFETY_EN_5066); RCM:$(HW_SAFETY_AS/NZS_62368); \
	CB: $(HW_SAFETY_IEC_62368-1);
endef

define Device/TEMPLATE_teltonika_rut241
	$(Device/teltonika_rut2m_common)
	DEVICE_MODEL := RUT241
	DEVICE_FEATURES := io small_flash mobile wifi
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE, UKCA, ANRT, Kenya, ICASA, FCC, IC, PTCRB, NOM, RCM, KC, Giteki, \
	IMDA, E-mark, CB, UL/CSA Safety, RoHS, REACH, R118
	HARDWARE/Regulatory_&_Type_Approvals/Operator := AT&T, Verizon, T-Mobile, Uscellula
	HARDWARE/EMC_Emissions_&_Immunity/Standards := $(HW_EI_STANDARDS_EN_55032); $(HW_EI_STANDARDS_EN_55035); \
	$(HW_EI_STANDARDS_EN_IEC_61000-3-2); $(HW_EI_STANDARDS_EN_61000-3-3); \
	$(HW_EI_STANDARDS_EN_301_489-1_V2.2.3); $(HW_EI_STANDARDS_EN_301_489-17_V3.2.4); Final Draft EN 301 489-52 V1.2.0;
	HARDWARE/EMC_Emissions_&_Immunity/ESD := $(HW_IMUNITY_EMISION_ESD)
	HARDWARE/EMC_Emissions_&_Immunity/Radiated_Immunity := EN IEC 61000-4-3:2020
	HARDWARE/EMC_Emissions_&_Immunity/EFT := $(HW_IMUNITY_EMISION_EFT)
	HARDWARE/EMC_Emissions_&_Immunity/Surge_Immunity_(AC_Mains_Power_Port) := $(HW_IMUNITY_EMISION_SURGE)
	HARDWARE/EMC_Emissions_&_Immunity/CS := $(HW_IMUNITY_EMISION_CS)
	HARDWARE/EMC_Emissions_&_Immunity/DIP := $(HW_IMUNITY_EMISION_DIP)
	HARDWARE/RF/Standards := $(HW_RF_EN_300_328_V2.2.2); $(HW_RF_EN_301_511_V12.5.1); $(HW_RF_EN_301_908-1_V15.2.1); $(HW_RF_EN_301_908-2_V13.1.1); \
	$(HW_RF_EN_301_908-13_V13.2.1);
	HARDWARE/Safety/Standards := CE:$(HW_SAFETY_EN_IEC_62368-1), $(HW_SAFETY_EN_IEC_62311), EN 50665:201; RCM:$(HW_SAFETY_AS/NZS_62368); \
	CB: $(HW_SAFETY_IEC_62368-1); UL/CSA Safety:UL 62368-1, Ed. 3 dated December 13, 20, CAN/CSA C22.2 No. 62368-1:19
endef

define Device/TEMPLATE_teltonika_rut260
	$(Device/teltonika_rut2m_common)
	DEVICE_MODEL := RUT260
	HARDWARE/LAN/Standard := $(HW_ETH_LAN_2_STANDARD)
	HARDWARE/Power/Power_consumption := Idle:< 2 W, Max:< 6.5 W
	HARDWARE/Physical_Interfaces/Status_leds := 2 x Connection type status, 5 x Mobile connection strength, 1 x LAN status, 1 x WAN status, 1 x Power
	HARDWARE/Physical_Specification/Weight := 130 g
	HARDWARE/Physical_Specification/Mounting_options:= $(HW_PHYSICAL_MOUNTING)
	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE/RED, UKCA, UCRF, RCM, EAC, WEEE, RCM, R118
endef

define Device/tlt-desc-rut206
	$(Device/teltonika_rut2m_common)
	DEVICE_MODEL := RUT206
	HARDWARE/Input_Output/Input :=
	HARDWARE/Input_Output/Output :=
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_2PIN)
	HARDWARE/Power/PoE_Standards := $(HW_POWER_POE_PASSIVE_ACTIVE)
	HARDWARE/Physical_Interfaces/SIM := 2 $(HW_INTERFACE_SIM_TRAY)
	HARDWARE/Physical_Interfaces/Status_leds := 3 x Connection type status LEDs, 3 x Connection strength LEDs, 2 x LAN status LEDs, 1 x Power LED
	HARDWARE/Physical_Interfaces/Power := $(HW_INTERFACE_POWER_2PIN)
	HARDWARE/Physical_Interfaces/IO :=
	HARDWARE/Physical_Interfaces/RS232 := 1 $(HW_INTERFACE_RS232_6PIN)
	HARDWARE/Physical_Interfaces/RS485 := 1 $(HW_INTERFACE_RS485_6PIN)
	HARDWARE/Serial/RS232 := $(HW_SERIAL_RS232_FLOW)
	HARDWARE/Serial/RS485 := $(HW_SERIAL_RS485_HALF)
	HARDWARE/Serial/Serial_functions := Console, Serial over IP, Modem, MODBUS gateway, NTRIP Client
	HARDWARE/SD_card/Physical_size := $(HW_SD_PHYSICAL_SIZE)
	HARDWARE/SD_card/Applications := $(HW_SD_APLICATIONS)
	HARDWARE/SD_card/Capacity := $(HW_SD_CAPACITY);
	HARDWARE/SD_card/Storage_formats := $(HW_SD_STORAGE_FORMATS)
endef

define Device/TEMPLATE_teltonika_rut271
	$(Device/teltonika_rut2m_common)
	DEVICE_MODEL := RUT271
	DEVICE_FEATURES := io small_flash mobile wifi
	DEVICE_INITIAL_FIRMWARE_SUPPORT := 7.10.2

	HARDWARE/Regulatory_&_Type_Approvals/Regulatory := CE, UKCA, ANRT, Kenya, ICASA, FCC, IC, PTCRB, NOM, RCM, KC, Giteki, \
	IMDA, E-mark, CB, UL/CSA Safety, RoHS, REACH, R118
	HARDWARE/Regulatory_&_Type_Approvals/Operator := AT&T, Verizon, T-Mobile, Uscellula
	HARDWARE/EMC_Emissions_&_Immunity/Standards := $(HW_EI_STANDARDS_EN_55032); $(HW_EI_STANDARDS_EN_55035); \
	$(HW_EI_STANDARDS_EN_IEC_61000-3-2); $(HW_EI_STANDARDS_EN_61000-3-3); \
	$(HW_EI_STANDARDS_EN_301_489-1_V2.2.3); $(HW_EI_STANDARDS_EN_301_489-17_V3.2.4); Final Draft EN 301 489-52 V1.2.0;
	HARDWARE/EMC_Emissions_&_Immunity/ESD := $(HW_IMUNITY_EMISION_ESD)
	HARDWARE/EMC_Emissions_&_Immunity/Radiated_Immunity := EN IEC 61000-4-3:2020
	HARDWARE/EMC_Emissions_&_Immunity/EFT := $(HW_IMUNITY_EMISION_EFT)
	HARDWARE/EMC_Emissions_&_Immunity/Surge_Immunity_(AC_Mains_Power_Port) := $(HW_IMUNITY_EMISION_SURGE)
	HARDWARE/EMC_Emissions_&_Immunity/CS := $(HW_IMUNITY_EMISION_CS)
	HARDWARE/EMC_Emissions_&_Immunity/DIP := $(HW_IMUNITY_EMISION_DIP)
	HARDWARE/RF/Standards := $(HW_RF_EN_300_328_V2.2.2); $(HW_RF_EN_301_511_V12.5.1); $(HW_RF_EN_301_908-1_V15.2.1); $(HW_RF_EN_301_908-2_V13.1.1); \
	$(HW_RF_EN_301_908-13_V13.2.1);
	HARDWARE/Safety/Standards := CE:$(HW_SAFETY_EN_IEC_62368-1), $(HW_SAFETY_EN_IEC_62311), EN 50665:201; RCM:$(HW_SAFETY_AS/NZS_62368); \
	CB: $(HW_SAFETY_IEC_62368-1); UL/CSA Safety:UL 62368-1, Ed. 3 dated December 13, 20, CAN/CSA C22.2 No. 62368-1:19
endef
