#!/usr/bin/env python3
# display an image out of the rom

import argparse
import os
import pygame
import struct
from collections import namedtuple
from enum import Enum
from rle import RleDecompressor

parser = argparse.ArgumentParser(description='Graphic Viewer')
parser.add_argument('-r', '--rom', help='Source ROM', required=True)
parser.add_argument('-a', '--addr', help='Address', required=True)
args = vars(parser.parse_args())

addr = int(args['addr'], 0)

ItemObjHeader = namedtuple("ItemObjHeader", "width_tiles height_tiles offset_x offset_y offset_z draw_flags data_addr")
StatusIconHeader = namedtuple("ItemObjHeader", "width_tiles height_tiles draw_flags data_addr")

# graphics seem to be defined as;
# label_what_data:
#	dc.b	$22, $33, ... ; compressed data
# label_what:
#	dc.b	$01	; ??? frame count
#	dc.b	$00	; ???
#	dc.b	$00	; ???
#	dc.b	$00	; ???
# eachframe:
#	dc.b	$03	; tile width
#	dc.b	$02	; tile height
#	dc.b	$F5	; x draw offset
#	dc.b	$F4	; y draw offset
#	dc.b	$F3	; z offset?
#	dc.b	$02	; palette and other flags?
#	dc.l	label_what_data	; pointer to data

# status icons are just
#	dc.b	$02	; tile width
#	dc.b	$02	; tile height
#	dc.b	$00	; x draw offset
#	dc.b	$00	; y draw offset
#	dc.b	$F0	; z offset?
#	dc.b	$03	; palette and other flags?
#	dc.l	label_what_data	; pointer to data


class DrawOrder(Enum):
    ROW_MAJOR = 0
    COLUMN_MAJOR = 1

width_tiles = 0
height_tiles = 0
decompressed_data = b''
palettes = []
palette_index = 0

def nop():
    return

# turn a CRAM value into a (r,g,b) tuple
def cram_to_color(val):
    blue =  (val & 0x0E00) >> 9
    green = (val & 0x00E0) >> 5
    red =   (val & 0x000E) >> 1
    return (red << 5, green << 5, blue << 5)

# I think this gets used for more than just item objects;
# item objects just use this with framecount=1
def header_parse_itemobj(rom):
    # We have to add an additional two pad bytes because 'struct'
    # wants to have the padding and I don't know how to make it not.
    header = struct.unpack(">bbbbBBbbbBIxx", rom.read(16))

    return ItemObjHeader(header[4], header[5], header[6], header[7], header[8], header[9], header[10])

# used for status icons on the hud
def header_parse_status(rom):
    # We have to add an additional two pad bytes because 'struct'
    # wants to have the padding and I don't know how to make it not.
    header = struct.unpack(">BBbbbBIxx", rom.read(12))
    print(header)

    return StatusIconHeader(header[0], header[1], header[5], header[6])

with open(args['rom'], "rb") as rom:
    rom.seek(addr)
    header = header_parse_itemobj(rom)
    #header = header_parse_status(rom)
    width_tiles = header.width_tiles
    height_tiles = header.height_tiles

    palette_index = header.draw_flags & 0x03
    if ((header.draw_flags & 0x80) == 0x80):
        draw_order = DrawOrder.COLUMN_MAJOR
    else:
        draw_order = DrawOrder.ROW_MAJOR

    total_tiles = width_tiles * height_tiles
    expected_bytes = total_tiles * 32

    if (width_tiles > 0x04):
        raise ValueError("more than four tiles wide, not valid")
    elif (height_tiles > 0x04):
        raise ValueError("more than four tiles high, not valid")

    rom.seek(header.data_addr)
    decompressed_data = RleDecompressor.decompress(rom, expected_bytes)

    # also we need palettes
    rom.seek(0x098138)
    for p in range(0, 4):
        raw_pal = struct.unpack(">16H", rom.read(32));
        palettes.append( [cram_to_color(p) for p in raw_pal] )

running = True

tile_mag = 8

screen = pygame.display.set_mode((width_tiles * 8 * tile_mag, height_tiles * 8 * tile_mag))
pygame.display.set_caption("gfx_display")
screen.fill((255, 255, 255))

tiles = []

def scale(t, s):
    return tuple([s*x for x in t])

pal = palettes[palette_index]

# allocate a bunch of tiles, then draw onto them; we'll assemble
# them as the VDP does later. (it was easier to think about the
# math this way)
for t in range(0, total_tiles):
    tiles.append(pygame.Surface((8 * tile_mag, 8 * tile_mag)))
    tiles[t].fill((123, 45, 67)) # (pal[t])

for b in range(0, 32*total_tiles):
    value = decompressed_data[b]
    v1 = (value & 0xF0) >> 4
    v2 = (value & 0x0F)
    if (draw_order == DrawOrder.ROW_MAJOR):
        row = int((b % 32) / 4)
        col = int(b % 4)
        t = int(b / 32)
    else:
        row = int(b % 8)
        col = int(b / (8 * total_tiles))
        t = int((b % (8 * total_tiles)) / 8)

    #print("tile %d (%d, %d) = %02X" % (t, col, row, value))
    if (v1 != 0):
        pygame.draw.rect(tiles[t], pal[v1], scale((col*2, row, 1, 1), tile_mag))
    if (v2 != 0):
        pygame.draw.rect(tiles[t], pal[v2], scale((col*2+1, row, 1, 1), tile_mag))

# Draw the tiles in VDP order; this is "down, then across"
# VDP draw order is (for 4x4)
#  0  4  8  C
#  1  5  9  D
#  2  6  A  E
#  3  7  B  F
for t in range(0, total_tiles):
    row = int(t % height_tiles);
    col = int(t / height_tiles);
    screen.blit(tiles[t], (col * 8 * tile_mag, row * 8 * tile_mag))

pygame.display.flip()

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
