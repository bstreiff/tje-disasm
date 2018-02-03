#!/usr/bin/env python3
# display an image out of the rom

import argparse
import os
import pygame
import struct
from enum import Enum
from rle import RleDecompressor
from sprite import SpriteFlags, Sprite, MetaSprite
from sprite import Palette

parser = argparse.ArgumentParser(description='Graphic Viewer')
parser.add_argument('-r', '--rom', help='Source ROM', required=True)
parser.add_argument('-a', '--addr', help='Address', required=True)
args = vars(parser.parse_args())

addr = int(args['addr'], 0)

palettes = []

with open(args['rom'], "rb") as rom:
    rom.seek(addr)
    metaspr = MetaSprite.extract_from(rom)

    # also we need palettes
    for p in range(0, 4):
        rom.seek(0x098138 + 32*p)
        palettes.append( Palette.extract_from(rom) )

running = True

tile_mag = 8

sprite = metaspr.sprites[0]

total_tiles = sprite.width * sprite.height

screen = pygame.display.set_mode((sprite.width * 8 * tile_mag, sprite.height * 8 * tile_mag))
pygame.display.set_caption("gfx_display")
screen.fill((255, 255, 255))

tiles = []

def scale(t, s):
    return tuple([s*x for x in t])

pal = palettes[sprite.flags & 0x3]

# allocate a bunch of tiles, then draw onto them; we'll assemble
# them as the VDP does later. (it was easier to think about the
# math this way)
for t in range(0, total_tiles):
    tiles.append(pygame.Surface((8 * tile_mag, 8 * tile_mag)))
    tiles[t].fill((123, 45, 67)) # (pal[t])

for b in range(0, 32*total_tiles):
    value = sprite.data[b]
    v1 = (value & 0xF0) >> 4
    v2 = (value & 0x0F)
    if (sprite.flags == SpriteFlags.COLUMN_MAJOR_DRAW):
        row = int((b % 32) / 4)
        col = int(b % 4)
        t = int(b / 32)
    else:
        row = int(b % 8)
        col = int(b / (8 * total_tiles))
        t = int((b % (8 * total_tiles)) / 8)

    #print("tile %d (%d, %d) = %02X" % (t, col, row, value))
    if (v1 != 0):
        pygame.draw.rect(tiles[t], pal[v1].rgb(), scale((col*2, row, 1, 1), tile_mag))
    if (v2 != 0):
        pygame.draw.rect(tiles[t], pal[v2].rgb(), scale((col*2+1, row, 1, 1), tile_mag))

# Draw the tiles in VDP order; this is "down, then across"
# VDP draw order is (for 4x4)
#  0  4  8  C
#  1  5  9  D
#  2  6  A  E
#  3  7  B  F
for t in range(0, total_tiles):
    row = int(t % sprite.height);
    col = int(t / sprite.height);
    screen.blit(tiles[t], (col * 8 * tile_mag, row * 8 * tile_mag))

pygame.display.flip()

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
