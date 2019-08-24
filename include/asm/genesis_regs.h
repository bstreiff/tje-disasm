/*----------------------------------------------------------------------
 Main header file for constants related to the Genesis/Mega Drive
 hardware.
----------------------------------------------------------------------*/

#ifndef _ASM_GENESIS_REGS_H
#define _ASM_GENESIS_REGS_H

#define BIT(x)				(1 << x)

#define MEM_ROM_START			0x000000
#define MEM_ROM_LENGTH			0x400000

/* Indicates the hardware version. */
#define REG_HWVERSION			0xA10001	/* word */
#define HWVERSION_MODE			0x0080		/* 0: "Domestic", 1: "Overseas" */
#define HWVERSION_VMOD			0x0040		/* 0: NTSC, 1: PAL */
#define HWVERSION_DISK			0x0020		/* 0: FDD unit connected, 1: no FDD */
#define HWVERSION_VER_MASK		0x000F		/* hardware version */

/*
 * I/O ports. There are three general purpose I/O ports,
 * CTRL1, CTRL2, and EXP. Each port has the following registers:
 *     DATA: parallel data
 *     CTRL: parallel control
 *     SCTRL: serial control
 *     TXDATA: transmit data
 *     RXDATA: receive data
 * Both byte and word access is possible, but only the lower byte is meaningful.
 */

#define REG_IO_CTRL1_DATA_HI		0xA10002		/* word */
#define REG_IO_CTRL1_DATA		0xA10003		/* byte */
#define REG_IO_CTRL2_DATA_HI		0xA10004		/* word */
#define REG_IO_CTRL2_DATA		0xA10005		/* byte */
#define REG_IO_EXP_DATA_HI		0xA10006		/* word */
#define REG_IO_EXP_DATA			0xA10007		/* byte */
#define REG_IO_CTRL1_CTRL_HI		0xA10008		/* word */
#define REG_IO_CTRL1_CTRL		0xA10009		/* byte */
#define REG_IO_CTRL2_CTRL_HI		0xA1000A		/* word */
#define REG_IO_CTRL2_CTRL		0xA1000B		/* byte */
#define REG_IO_EXP_CTRL_HI		0xA1000C		/* word */
#define REG_IO_EXP_CTRL			0xA1000D		/* byte */
#define REG_IO_IO_CTRL1_TXDATA_HI	0xA1000E		/* word */
#define REG_IO_CTRL1_TXDATA		0xA1000F		/* byte */
#define REG_IO_CTRL1_RXDATA_HI		0xA10010		/* word */
#define REG_IO_CTRL1_RXDATA		0xA10011		/* byte */
#define REG_IO_CTRL1_SCTRL_HI		0xA10012		/* word */
#define REG_IO_CTRL1_SCTRL		0xA10013		/* byte */
#define REG_IO_CTRL2_TXDATA_HI		0xA10014		/* word */
#define REG_IO_CTRL2_TXDATA		0xA10015		/* byte */
#define REG_IO_CTRL2_RXDATA_HI		0xA10016		/* word */
#define REG_IO_CTRL2_RXDATA		0xA10017		/* byte */
#define REG_IO_CTRL2_SCTRL_HI		0xA10018		/* word */
#define REG_IO_CTRL2_SCTRL		0xA10019		/* byte */
#define REG_IO_EXP_TXDATA_HI		0xA1001A		/* word */
#define REG_IO_EXP_TXDATA		0xA1001B		/* byte */
#define REG_IO_EXP_RXDATA_HI		0xA1001C		/* word */
#define REG_IO_EXP_RXDATA		0xA1001D		/* byte */
#define REG_IO_EXP_SCTRL_HI		0xA1001E		/* word */
#define REG_IO_EXP_SCTRL		0xA1001F		/* byte */

#define IO_DATA_ST			0x80
#define IO_DATA_TH			0x40
#define IO_DATA_TR			0x20
#define IO_DATA_TL			0x10
#define IO_DATA_A			IO_DATA_TH
#define IO_DATA_B			IO_DATA_TL
#define IO_DATA_C			IO_DATA_TR
#define IO_DATA_R			0x08
#define IO_DATA_L			0x04
#define IO_DATA_D			0x02
#define IO_DATA_U			0x01

#define IO_CTRL_INT			0x80
#define IO_CTRL_PC6			0x40
#define IO_CTRL_PC5			0x20
#define IO_CTRL_PC4			0x10
#define IO_CTRL_PC3			0x08
#define IO_CTRL_PC2			0x04
#define IO_CTRL_PC1			0x02
#define IO_CTRL_PC0			0x01

#define IO_SCTRL_BPS_SHIFT		6
#define IO_SCTRL_4800BPS		(0 << IO_SCTRL_BPS_SHIFT)
#define IO_SCTRL_2400BPS		(1 << IO_SCTRL_BPS_SHIFT)
#define IO_SCTRL_1200BPS		(2 << IO_SCTRL_BPS_SHIFT)
#define IO_SCTRL_300BPS			(3 << IO_SCTRL_BPS_SHIFT)
#define IO_SCTRL_SIN			0x20
#define IO_SCTRL_SOUT			0x10
#define IO_SCTRL_RINT			0x08
#define IO_SCTRL_RERR			0x04
#define IO_SCTRL_RRDY			0x02
#define IO_SCTRL_TFUL			0x01

#define REG_MEMMODE			0xA11000

/*
 * Z80 bus request.
 */

#define Z80_REG_BUSREQ			0xA11100		/* word */
#define Z80_BUSREQ_REQUEST		0x0100
#define Z80_BUSREQ_CANCEL		0x0000

/*
 * Z80 reset.
 */

#define Z80_REG_RESET			0xA11200		/* word */
#define Z80_RESET_REQUEST		0x0000
#define Z80_RESET_CANCEL		0x0100

#define TMSS_REG_CTRL			0xA14000		/* long */

/*
 * VDP control and status registers.
 */

#define VDP_REG_DATA_PORT		0xC00000		/* word */
#define VDP_REG_DATA_PORT_MIRROR	0xC00002
#define VDP_REG_CTRL_PORT		0xC00004
#define VDP_REG_CTRL_PORT_MIRROR	0xC00006
#define VDP_REG_HVCOUNTER_PORT		0xC00008

#define VDP_CTRL_REG_WRITE		0x8000

#define VDP_CTRL_ADDR_VRAM_RD		0x00000000
#define VDP_CTRL_ADDR_VRAM_WR		0x40000000
#define VDP_CTRL_ADDR_CRAM_RD		0x00000020
#define VDP_CTRL_ADDR_CRAM_WR		0xC0000000
#define VDP_CTRL_ADDR_VSRAM_RD		0x00000010
#define VDP_CTRL_ADDR_VSRAM_WR		0x40000010
#define VDP_CTRL_ADDR_DMA		0x80
#define VDP_CTRL_ADDR_VRAM2VRAM		0x40

/* VDP status flags (read from VDP_CTRL_PORT) */
#define VDP_STS_E			0x0200	/* fifo is empty */
#define VDP_STS_F			0x0100	/* fifo is full */
#define VDP_STS_VI			0x0080	/* vertical interrupt occurred */
#define VDP_STS_SO			0x0040	/* sprite limit hit */
#define VDP_STS_SC			0x0020	/* two sprites overlap */
#define VDP_STS_OD			0x0010	/* odd frame (interlaced mode) */
#define VDP_STS_VB			0x0008	/* vblank in progress */
#define VDP_STS_HB			0x0004	/* hblank in progress */
#define VDP_STS_DMA			0x0002	/* DMA in progress */
#define VDP_STS_PAL			0x0001	/* PAL system */

#define RAM_ADDR			0xFF0000
#define RAM_LENGTH			0x010000
#define RAM_LENGTH_IN_WORDS		0x8000
#define RAM_LENGTH_IN_LONGS		0x4000

#endif
