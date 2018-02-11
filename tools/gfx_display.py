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

pal = palettes[sprite.flags & 0x3]

for pixel in sprite.pixel_generator():
    (x, y, index) = pixel
    if index != 0:
        pygame.draw.rect(screen, pal[index].rgb(), (x, y, 1, 1))

pygame.display.flip()

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
