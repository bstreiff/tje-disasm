/*
 * Convenience macros for dealing with the VDP.
 */

#include "genesis_regs.h"
#include "vdp_regs.h"

#ifndef _ASM_VDP_MACROS_H
#define _ASM_VDP_MACROS_H

#ifdef __ASSEMBLER__

#define _VDP_REGISTER_WRITE(reg, val) \
	(VDP_CTRL_REG_WRITE | (reg << 8) | (val))

#define _VDP_BUILD_ADDR(addr) \
	(((addr&0x3FFF)<<16)+((addr&0xC000)>>14))

/*
 * Set the VDP register indicated by `reg` to `val`.
 */
#define VDP_SET_REG(reg, val) \
	MOVE.w #(_VDP_REGISTER_WRITE(reg, val)), VDP_REG_CTRL_PORT

/*
 * Set two VDP registers `reg1` and `reg2` to `val1` and `val2`
 * in a single operation. This takes advantage of the mirrored
 * nature of the Genesis VDP control port.
 */
#define VDP_SET_REG2(reg1, val1, reg2, val2) \
	MOVE.l #((_VDP_REGISTER_WRITE(reg1, va1l) << 16) | _VDP_REGISTER_WRITE(reg2, val2)), VDP_REG_CTRL_PORT

/*
 * Configure the VDP for VRAM reads from `addr`.
 */
#define VDP_SET_VRAM_RD(addr, flags) \
	MOVE.l #(VDP_CTRL_ADDR_VRAM_RD|_VDP_BUILD_ADDR(addr)|flags), VDP_REG_CTRL_PORT

/*
 * Configure the VDP for VRAM writes to `addr`.
 */
#define VDP_SET_VRAM_WR(addr, flags) \
	MOVE.l #(VDP_CTRL_ADDR_VRAM_WR|_VDP_BUILD_ADDR(addr)|flags), VDP_REG_CTRL_PORT

/*
 * Configure the VDP for CRAM reads from `addr`.
 */
#define VDP_SET_CRAM_RD(addr, flags) \
	MOVE.l #(VDP_CTRL_ADDR_CRAM_RD|_VDP_BUILD_ADDR(addr)|flags), VDP_REG_CTRL_PORT

/*
 * Configure the VDP for CRAM writes to `addr`.
 */
#define VDP_SET_CRAM_WR(addr, flags) \
	MOVE.l #(VDP_CTRL_ADDR_CRAM_WR|_VDP_BUILD_ADDR(addr)|flags), VDP_REG_CTRL_PORT

/*
 * Configure the VDP for VSRAM reads from `addr`.
 */
#define VDP_SET_VSRAM_RD(addr, flags) \
	MOVE.l #(VDP_CTRL_ADDR_VSRAM_RD|_VDP_BUILD_ADDR(addr)|flags), VDP_REG_CTRL_PORT

/*
 * Configure the VDP for VSRAM writes to `addr`.
 */
#define VDP_SET_VSRAM_WR(addr, flags) \
	MOVE.l #(VDP_CTRL_ADDR_VSRAM_WR|_VDP_BUILD_ADDR(addr)|flags), VDP_REG_CTRL_PORT

/*
 * Value for "set MODE2 with M5 bit set". Usually OR'd with other bits.
 */
#define VDP_MODE2_M5_SET	_VDP_REGISTER_WRITE(VDP_REG_MODE2, VDP_MODE2_M5)

#endif /* __ASSEMBLER__ */

#endif /* _ASM_VDP_MACROS_H */
