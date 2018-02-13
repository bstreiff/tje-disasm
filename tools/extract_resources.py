#!/usr/bin/env python3
# Extract binary data (patterns, sprites) from the ROM.

import argparse
import os
import configparser
import pygame
import struct
from functools import reduce
from collections import namedtuple
from genesisrom import GenesisRomHeader
from resource import Resource, ResourceKind
from sprite import MetaSprite, Sprite, Palette, Rect

parser = argparse.ArgumentParser(description='Resource Extractor')
parser.add_argument('rsrccfg', help='Resource Config File')
parser.add_argument('romfile', help='Source ROM')
args = vars(parser.parse_args())

cfg = configparser.ConfigParser()
cfg.read(args['rsrccfg'])

palettes = {}

EXPORT_PNGS = 0

def extract_rawbin(filename, rom, resource):
    with open(filename, "wb") as out:
        rom.seek(resource.address)
        out.write(rom.read(resource.length))

def extract_metasprite_list(resource_name, rom, resource, palette_name):
    rom.seek(resource.address)
    # the "resource" is just an array of addresses to metasprites
    mspr_pointers = struct.unpack(">%dI" % (resource.length >> 2), rom.read(resource.length))

    msprs = []
    for mptr in mspr_pointers:
        rom.seek(mptr)
        msprs.append(MetaSprite.extract_from(rom))

    for mindex, mspr in enumerate(msprs):
        # fix up names
        mspr.name = resource_name + ("Frame%02d" % mindex)
        for sindex, spr in enumerate(mspr.sprites):
            spr.name = mspr.name + ("Spr%02d" % sindex)

    # ASM file that provides the jump table
    with open("resources/" + resource_name + ".asm", "w") as out:
        out.write("%s:\t\t; offset %08X\n" % (resource_name, resource.address))
        for mspr in msprs:
            out.write("\tdc.l\t%s\n" % mspr.name);

    for mindex, mspr in enumerate(msprs):
        with open("resources/" + mspr.name + ".asm", "w") as out:
            mspr.write_asm(out)

    if not EXPORT_PNGS:
        palette_group = palettes[palette_name]
        msprbounds = msprs[0].bounds()
        msprbounds = reduce((lambda x, y: Rect.union(x, y)),
                            [m.bounds() for m in msprs])

        for mindex, mspr in enumerate(msprs):
            # figure out where this should go
            pos = (-msprbounds[0], -msprbounds[1])
            surface = pygame.Surface((msprbounds[2], msprbounds[3]), depth=24)
            surface.set_colorkey((0,126,194))
            surface.fill((0,126,194))
            mspr.draw_to_surface(surface, palette_group, pos)
            tmpname = "%07d_%02d_%s" % (resource.address, mindex, mspr.name)
            pygame.image.save(surface, "resources/" + tmpname + ".png")


def extract_resource(rom, name, cfgsect):
    kind = ResourceKind[cfgsect['kind']]

    if kind == ResourceKind.PALETTE:
        # not actually extracted, just maintained as metadata
        # for extracting sprites
        pal = []
        for p in range(0, 4):
            rom.seek(int(cfgsect['address%d' % p], 0))
            pal.append(Palette.extract_from(rom).rgba())
        palettes[name] = pal
        return

    resource = Resource(kind=kind,
                        address=int(cfgsect['address'], 0),
                        length=int(cfgsect['length'], 0))

    if resource.kind == ResourceKind.RAW_IMAGE:
        # Just write it out as a binary blob
        extract_rawbin("resources/" + name + ".bin", rom, resource)
    elif resource.kind == ResourceKind.Z80_BINARY:
        # Another binary blob. Decompiling this may someday be
        # interesting, but not today.
        extract_rawbin("resources/" + name + ".z80.bin", rom, resource)
    elif resource.kind == ResourceKind.METASPRITE_LIST:
        palette_name = cfgsect.get('palette', 'PaletteDefault')
        extract_metasprite_list(name, rom, resource, palette_name)

with open(args['romfile'], "rb") as rom:
    romheader = GenesisRomHeader.extract_from(rom)
    # Make sure that this is the right game
    if (romheader['domestic_game_name'] != "TOEJAM & EARL"):
        raise ValueError("Wrong Game: %s" & romheader['domestic_game_name'])
    # Make sure that this is the right version
    if (romheader['product_revision'] != "02"):
        raise ValueError("Wrong Version: %s" % romheader['product_revision'])

    if not os.path.exists("resources"):
        os.makedirs("resources");

    for resource_name in cfg.sections():
        extract_resource(rom, resource_name, cfg[resource_name])
