/*
 * Copyright (C) 2015 Piotr Dymacz <piotr@dymacz.pl>
 * Copyright (C) 2005 Wolfgang Denk, DENX Software Engineering, <wd@denx.de>
 *
 * SPDX-License-Identifier:GPL-2.0
 */

#include <common.h>
#include <flash.h>

#ifndef CFG_NO_FLASH

/* Info for FLASH chips */
flash_info_t flash_info[CFG_MAX_FLASH_BANKS];

/* List of supported and known SPI NOR FLASH chips */
static char VENDOR_ATMEL[]      = "Atmel";
static char VENDOR_EON[]        = "EON";
static char VENDOR_GIGADEVICE[] = "GigaDevice";
static char VENDOR_MACRONIX[]   = "Macronix";
static char VENDOR_MICRON[]     = "Micron";
static char VENDOR_SPANSION[]   = "Spansion";
static char VENDOR_WINBOND[]    = "Winbond";
static char VENDOR_XTX[]        = "XTX";

const spi_nor_ids_info_t spi_nor_ids[] = {
	/* 4 MiB */
	{ "AT25DF321", 0x1F4700, SIZE_4MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0},
	{ "EN25Q32",   0x1C3016, SIZE_4MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "EN25F32",   0x1C3116, SIZE_4MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "GD25Q32",   0xC84016, SIZE_4MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "MX25L320",  0xC22016, SIZE_4MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "M25P32",    0x202016, SIZE_4MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "S25FL032P", 0x010215, SIZE_4MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "W25Q32",    0xEF4016, SIZE_4MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },

	/* 8 MiB */
	{ "AT25DF641", 0x1F4800, SIZE_8MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "EN25Q64",   0x1C3017, SIZE_8MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "GD25Q64",   0xC84017, SIZE_8MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "MX25L64",   0xC22017, SIZE_8MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "MX25L64",   0xC22617, SIZE_8MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "M25P64",    0x202017, SIZE_8MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "S25FL064P", 0x010216, SIZE_8MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "W25Q64",    0xEF4017, SIZE_8MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },

	/* 16 MiB */
	{ "GD25Q128",  0xC84018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "MX25L128",  0xC22018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "MX25L128",  0xC22618, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "N25Q128",   0x20BA18, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "S25FL127S", 0x012018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "W25Q128",   0xEF4018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "W25Q128FW", 0xEF6018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "ZB25VQ128", 0xC84018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "EN25QH128A", 0x1C7018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "XT25F128A", 0x207018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	{ "XT25F128B", 0x0B4018, SIZE_16MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 0 },
	/* 32 MiB */
	{ "XT25F256B", 0x0B4019, SIZE_32MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 1 },
	{ "W25Q256JV", 0xEF4019, SIZE_32MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 1 },
	/* 64 MiB */
	{ "W25Q512JV", 0xEF4020, SIZE_64MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 1 },
	{ "XT25W512B", 0x0B651A, SIZE_64MiB, SIZE_64KiB, 256, SPI_FLASH_CMD_ES_64KB, 1 },
};

const u32 spi_nor_ids_count = sizeof(spi_nor_ids) / sizeof(spi_nor_ids_info_t);

const char *flash_manuf_name(u32 jedec_id)
{
	switch (jedec_id >> 16) {
	case FLASH_VENDOR_JEDEC_ATMEL:
		return VENDOR_ATMEL;
		break;
	case FLASH_VENDOR_JEDEC_EON:
		return VENDOR_EON;
		break;
	case FLASH_VENDOR_JEDEC_GIGADEVICE:
		return VENDOR_GIGADEVICE;
		break;
	case FLASH_VENDOR_JEDEC_MACRONIX:
		return VENDOR_MACRONIX;
		break;
	case FLASH_VENDOR_JEDEC_MICRON:
		return VENDOR_MICRON;
		break;
	case FLASH_VENDOR_JEDEC_SPANSION:
		return VENDOR_SPANSION;
		break;
	case FLASH_VENDOR_JEDEC_WINBOND:
		return VENDOR_WINBOND;
		break;
	case FLASH_VENDOR_JEDEC_XTX:
		return VENDOR_XTX;
		break;
	default:
		return "Unknown";
		break;
	}
}

flash_info_t *addr2info(ulong addr)
{
	return &flash_info[0];
}

/*
 * Copy memory to flash.
 * Make sure all target addresses are within Flash bounds,
 * and no protected sectors are hit.
 * Returns:
 * ERR_OK          0 - OK
 * ERR_TIMOUT      1 - write timeout
 * ERR_NOT_ERASED  2 - Flash not erased
 * ERR_PROTECTED   4 - target range includes protected sectors
 * ERR_INVAL       8 - target address not in Flash memory
 * ERR_ALIGN       16 - target address not aligned on boundary
 *                      (only some targets require alignment)
 */
int flash_write(char *src, ulong addr, ulong cnt)
{
	int i;
	if ((i = write_buff(flash_info, (uchar *)src, addr, cnt)) != 0)
		return i;

	return ERR_OK;
}

void flash_perror(int err)
{
	switch (err) {
	case ERR_OK:
		break;
	case ERR_TIMOUT:
		printf_err("timeout writing to FLASH\n");
		break;
	case ERR_NOT_ERASED:
		printf_err("FLASH not erased\n");
		break;
	case ERR_INVAL:
		printf_err("outside available FLASH\n");
		break;
	case ERR_ALIGN:
		printf_err("start and/or end address not on sector boundary\n");
		break;
	case ERR_UNKNOWN_FLASH_VENDOR:
		printf_err("unknown vendor of FLASH\n");
		break;
	case ERR_UNKNOWN_FLASH_TYPE:
		printf_err("unknown type of FLASH\n");
		break;
	case ERR_PROG_ERROR:
		printf_err("general FLASH programming error\n");
		break;
	default:
		printf_err("%s[%d] FIXME: rc=%d\n", __FILE__, __LINE__, err);
		break;
	}
}
#endif /* !CFG_NO_FLASH */
