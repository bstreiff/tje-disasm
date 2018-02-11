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
parser.add_argument('-i', '--index', help='Metasprite index')
args = vars(parser.parse_args())

addr = int(args['addr'], 0)
index = int(args['index'] or '0')

palettes = []

with open(args['rom'], "rb") as rom:
    rom.seek(addr)
    metaspr = MetaSprite.extract_from(rom)

    # also we need palettes
    for p in range(0, 4):
        rom.seek(0x098138 + 32*p)
        palettes.append( Palette.extract_from(rom) )

running = True

sprite = metaspr.sprites[index]

screen = pygame.display.set_mode((sprite.width * 8, sprite.height * 8))
pygame.display.set_caption("gfx_display")
screen.fill((123, 45, 67))

tiles = []

pal = palettes[sprite.flags & 0x3]

for b in range(0, 32*sprite.width*sprite.height):
    value = sprite.data[b]
    v1 = (value & 0xF0) >> 4
    v2 = (value & 0x0F)
    # Get the position within this VDP tile
    sub_y = int((b % 32) / 4)
    sub_x = int(b % 4)

    # Draw the tiles in VDP order; this is "down, then across"
    # VDP draw order is (for 4x4)
    #  0  4  8  C
    #  1  5  9  D
    #  2  6  A  E
    #  3  7  B  F
    t = int(b / 32)
    x = int(t / sprite.height)*4 + sub_x
    y = int(t % sprite.height)*8 + sub_y

    if (v1 != 0):
        pygame.draw.rect(screen, pal[v1].rgb(), (x*2, y, 1, 1))
    if (v2 != 0):
        pygame.draw.rect(screen, pal[v2].rgb(), (x*2+1, y, 1, 1))

pygame.display.flip()

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
