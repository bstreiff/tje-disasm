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

screen = pygame.display.set_mode((200, 200))
pygame.display.set_caption("gfx_display")
screen.fill((123, 45, 67))

for s in metaspr.sprites:
    pal = palettes[s.flags & 0x3]
    for pixel in s.pixel_generator():
        (x, y, index) = pixel
        x += s.offset[0] + 100
        y += s.offset[1] + 100
        if index != 0:
            pygame.draw.rect(screen, pal[index].rgb(), (x, y, 1, 1))

pygame.display.flip()

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
