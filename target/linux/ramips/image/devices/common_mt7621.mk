include $(INCLUDE_DIR)/hardware.mk

define Device/tlt-mt7621-hw-common
	HARDWARE/System_Characteristics/CPU := MediaTek, Dual-Core, 880 MHz, MIPS1004Kc
	HARDWARE/System_Characteristics/RAM := $(HW_RAM_SIZE_256M), $(HW_RAM_TYPE_DDR3)
	HARDWARE/System_Characteristics/Flash_Storage := $(HW_FLASH_SIZE_16M) $(HW_FLASH_TYPE_NOR_SERIAL), $(HW_FLASH_SIZE_256M) $(HW_FLASH_TYPE_NAND_SERIAL)
	HARDWARE/Wireless/Wireless_mode := 802.11b/g/n/ac Wave 2 (Wi-Fi 5)
	HARDWARE/Wireless/WIFI_users := $(HW_WIFI_150_USERS)
	HARDWARE/Power/Connector := $(HW_POWER_CONNECTOR_4PIN)
	HARDWARE/Power/Input_voltage_range := $(HW_POWER_VOLTAGE_4PIN_50V)
	HARDWARE/Power/PoE_Standards  := $(HW_POWER_POE_PASSIVE_50V)
	HARDWARE/Physical_Interfaces/Power := $(HW_INTERFACE_POWER_4PIN)
	HARDWARE/Physical_Interfaces/Ethernet := 4 $(HW_ETH_RJ45_PORTS), $(HW_ETH_SPEED_1000)
	HARDWARE/Physical_Interfaces/Button := $(HW_INTERFACE_RESET)
	HARDWARE/Physical_Interfaces/IO := $(HW_INTERFACE_IO_4PIN_IN_OUT)
	HARDWARE/Operating_Environment/Operating_Temperature := $(HW_OPERATING_TEMP)
	HARDWARE/Operating_Environment/Operating_Humidity := $(HW_OPERATING_HUMIDITY)
	HARDWARE/Operating_Environment/Ingress_Protection_Rating := $(HW_OPERATING_PROTECTION_IP30)
endef
