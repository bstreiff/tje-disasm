#!/usr/bin/env python3
# display an image out of the rom

import argparse
import os
import pygame
from sprite import MetaSprite, Palette

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
        palettes.append( Palette.extract_from(rom).rgb() )

running = True

screen = pygame.display.set_mode((200, 200))
pygame.display.set_caption("gfx_display")
screen.fill((0, 126, 194))
metaspr.draw_to_surface(screen, palettes, (100, 100))
pygame.display.flip()

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
