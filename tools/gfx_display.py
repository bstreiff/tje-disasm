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

scale = 8
bounds = metaspr.bounds()

screen = pygame.display.set_mode((bounds[2]*scale, bounds[3]*scale))
pygame.display.set_caption("gfx_display")

surface = pygame.Surface((bounds[2], bounds[3]))
surface.fill((0, 126, 194))
metaspr.draw_to_surface(surface, palettes, (-bounds[0], -bounds[1]))

pygame.transform.scale(surface, (bounds[2]*scale, bounds[3]*scale), screen)

for s in metaspr.sprites:
    b = s.bounds()
    b = b.move(-bounds[0], -bounds[1])

    for x in range(0, s.width):
        for y in range(0, s.height):
            scaled = ((b[0]+(x*8))*8, (b[1]+(y*8))*8, 8*8, 8*8)
            pygame.draw.rect(screen, (75, 0, 255), scaled, 2)

    scaled = (b[0]*8, b[1]*8, b[2]*8, b[3]*8)
    pygame.draw.rect(screen, (0, 255, 75), scaled, 2)

pygame.display.flip()

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
