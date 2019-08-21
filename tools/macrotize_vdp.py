#!/usr/bin/env python3

import fileinput
import re


def default_printer(value):
    return "0x{0:02X}".format(value)


def mode1_val(value):
    values = []
    if value & 0x20:
        values.append("VDP_MODE1_L")
    if value & 0x10:
        values.append("VDP_MODE1_IE1")
    if value & 0x04:
        values.append("VDP_MODE1_CM")
    if value & 0x02:
        values.append("VDP_MODE1_M3")
    if value & 0x01:
        values.append("VDP_MODE1_DE")

    if len(values) == 0:
        return "0"
    else:
        return "|".join(values)


def mode2_val(value):
    values = []
    if value & 0x80:
        values.append("VDP_MODE2_VR")
    if value & 0x40:
        values.append("VDP_MODE2_DE")
    if value & 0x20:
        values.append("VDP_MODE2_IE0")
    if value & 0x10:
        values.append("VDP_MODE2_M1")
    if value & 0x08:
        values.append("VDP_MODE2_M2")
    if value & 0x04:
        values.append("VDP_MODE2_M5")

    if len(values) == 0:
        return "0"
    else:
        return "|".join(values)


def mode3_val(value):
    values = []

    if value & 0x08:
        values.append("VDP_MODE3_IE2")
    if value & 0x04:
        values.append("VDP_MODE3_VS")

    if (value & 0x3) == 0:
        values.append("VDP_MODE3_HS_FULL")
    elif (value & 0x3) == 2:
        values.append("VDP_MODE3_HS_8PX")
    elif (value & 0x3) == 3:
        values.append("VDP_MODE3_HS_1PX")        

    if len(values) == 0:
        return "0"
    else:
        return "|".join(values)


def mode4_val(value):
    values = []

    if value & 0x81:
        values.append("VDP_MODE4_RS")
        value = value & ~(0x81)

    if value & 0x80:
        values.append("VDP_MODE4_RS1")
    if value & 0x40:
        values.append("VDP_MODE4_VS")
    if value & 0x20:
        values.append("VDP_MODE4_HS")
    if value & 0x10:
        values.append("VDP_MODE4_EP")
    if value & 0x08:
        values.append("VDP_MODE4_SH")
    if value & 0x04:
        values.append("VDP_MODE4_LS1")
    if value & 0x02:
        values.append("VDP_MODE4_LS0")
    if value & 0x01:
        values.append("VDP_MODE4_RS0")

    if len(values) == 0:
        return "0"
    else:
        return "|".join(values)


VDP_REGISTERS = [
    { 'id': 0x00, 'name': "MODE1", 'printer': mode1_val },
    { 'id': 0x01, 'name': "MODE2", 'printer': mode2_val },
    { 'id': 0x02, 'name': "NAMTBLA" },
    { 'id': 0x03, 'name': "WINTBL" },
    { 'id': 0x04, 'name': "NAMTBLB" },
    { 'id': 0x05, 'name': "SPRTBL" },
    { 'id': 0x06, 'name': "SPRTBL2" },
    { 'id': 0x07, 'name': "BGCOLOR" },
    { 'id': 0x08, 'name': "SMS_HSCR" },
    { 'id': 0x09, 'name': "SMS_VSCR" },
    { 'id': 0x0A, 'name': "HINTC" },
    { 'id': 0x0B, 'name': "MODE3", 'printer': mode3_val },
    { 'id': 0x0C, 'name': "MODE4", 'printer': mode4_val },
    { 'id': 0x0D, 'name': "HSDTADDR" },
    { 'id': 0x0E, 'name': "NTPADDR" },
    { 'id': 0x0F, 'name': "AUTOINCR" },
    { 'id': 0x10, 'name': "PSIZE" },
    { 'id': 0x11, 'name': "WINHPOS" },
    { 'id': 0x12, 'name': "WINVPOS" },
    { 'id': 0x13, 'name': "DMALENL" },
    { 'id': 0x14, 'name': "DMALENH" },
    { 'id': 0x15, 'name': "DMASRCL" },
    { 'id': 0x16, 'name': "DMASRCM" },
    { 'id': 0x17, 'name': "DMASRCH" },
]


word_access = re.compile(r"""MOVE.w(\s+)#0x([0-9A-F]+), VDP_REG_CTRL_PORT""")
long_access = re.compile(r"""MOVE.l(\s+)#0x([0-9A-F]+), VDP_REG_CTRL_PORT""")


for line in fileinput.input():
    line = line.rstrip()

    m = word_access.search(line)
    if m:
        vdp_value = int(m.group(2), 16)
        assert vdp_value & 0x8000 == 0x8000
        vdp_register = (vdp_value & 0x1F00) >> 8
        vdp_data = (vdp_value & 0x00FF)
        vdp_register_name = "VDP_REG_" + VDP_REGISTERS[vdp_register]['name']

        if 'printer' in VDP_REGISTERS[vdp_register]:
            printer = VDP_REGISTERS[vdp_register]['printer']
        else:
            printer = default_printer

        print("\tVDP_SET_REG({0}, {1})".format(vdp_register_name,
                                               printer(vdp_data)))
        continue

    m = long_access.search(line)
    if m:
        # longword accesses can be a bunch of things
        vdp_value = int(m.group(2), 16)
        cd_bits = vdp_value & 0xC0000030
        dma_flag = vdp_value & 0x80
        vr2vr_flag = vdp_value & 0x40
        address = ((vdp_value & 0x3FFF0000) >> 16) | ((vdp_value & 0x3) << 14)

        flags = []
        if dma_flag:
            flags.append("VDP_CTRL_ADDR_DMA")
        if vr2vr_flag:
            flags.append("VDP_CTRL_ADDR_VRAM2VRAM")
        if len(flags) == 0:
            flags_str = "0"
        else:
            flags_str = "|".join(flags)

        if cd_bits == 0x00000000:
            print("\tVDP_SET_VRAM_RD(0x{0:04X}, {1})".format(address, flags_str))
        elif cd_bits == 0x40000000:
            print("\tVDP_SET_VRAM_WR(0x{0:04X}, {1})".format(address, flags_str))
        elif cd_bits == 0x00000020:
            print("\tVDP_SET_CRAM_RD(0x{0:04X}, {1})".format(address, flags_str))
        elif cd_bits == 0xC0000000:
            print("\tVDP_SET_CRAM_WR(0x{0:04X}, {1})".format(address, flags_str))
        elif cd_bits == 0x00000010:
            print("\tVDP_SET_VSRAM_RD(0x{0:04X}, {1})".format(address, flags_str))
        elif cd_bits == 0x40000010:
            print("\tVDP_SET_VSRAM_WR(0x{0:04X}, {1})".format(address, flags_str))
        elif cd_bits == 0x80008000:
            # This is a pair of register writes.
            # TJ&E never does this, either.
            vdp_reg1 = (vdp_value & 0x1F000000) >> 24
            vdp_data1 = (vdp_value & 0x00FF0000) >> 16
            vdp_reg2 = (vdp_value & 0x00001F00) >> 8
            vdp_data2 = (vdp_value & 0x000000FF)

            vdp_reg1name = "VDP_REG_" + VDP_REGISTERS[vdp_reg1]['name']
            vdp_reg2name = "VDP_REG_" + VDP_REGISTERS[vdp_reg2]['name']

            print("\tVDP_SET_REG2({0}, 0x{1:02X}, {2}, {3:02X})".format(
                vdp_reg1name, vdp_data1, vdp_reg2name, vdp_data2))

        else:
            assert False
        continue

    # no match? just re-print the line
    print(line)
