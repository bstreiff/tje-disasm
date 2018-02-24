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
from resource import Resource, ResourceKind, ResourceTable
from sprite import MetaSprite, Sprite, Palette, Rect

parser = argparse.ArgumentParser(description='Resource Extractor')
parser.add_argument('rsrccfg', help='Resource Config File')
parser.add_argument('romfile', help='Source ROM')
args = vars(parser.parse_args())

cfg = configparser.ConfigParser()
cfg.read(args['rsrccfg'])

resource_table = ResourceTable()
resource_labels = {}
palettes = {}

EXPORT_PNGS = 0

def extract_rawbin(filename, rom, resource):
    with open(filename, "wb") as out:
        rom.seek(resource.address)
        out.write(rom.read(resource.length))

def extract_metasprite_list(resource_name, rom, resource):
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

    # group up the metasprite list, metasprites, and 

    # ASM file that provides the jump table
    #with open("resources/" + resource_name + ".asm", "w") as out:

    #if not EXPORT_PNGS:
    #    palette_name = resource.attrs.get('palette', 'PaletteDefault')
    #    palette_group = palettes[palette_name]
    #    msprbounds = msprs[0].bounds()
    #    msprbounds = reduce((lambda x, y: Rect.union(x, y)),
    #                        [m.bounds() for m in msprs])

    #    for mindex, mspr in enumerate(msprs):
    #        # figure out where this should go
    #        pos = (-msprbounds[0], -msprbounds[1])
    #        surface = pygame.Surface((msprbounds[2], msprbounds[3]), depth=24)
    #        surface.set_colorkey((0,126,194))
    #        surface.fill((0,126,194))
    #        mspr.draw_to_surface(surface, palette_group, pos)
    #        tmpname = "%07d_%02d_%s" % (resource.address, mindex, mspr.name)
    #        pygame.image.save(surface, "resources/" + tmpname + ".png")


def extract_resource(rom, resource):
    resource_label = resource.attrs["label"]

    if resource.kind == ResourceKind.RAW_IMAGE:
        # Just write it out as a binary blob
        extract_rawbin("resources/" + resource_label + ".bin", rom, resource)
    if resource.kind == ResourceKind.PCM_AUDIO:
        # Just write it out as a binary blob
        # These appear to have a two-byte length header, followed
        # by mono 8-bit LPCM samples at somewhere around 8kHz.
        extract_rawbin("resources/" + resource_label + ".sfx.bin", rom, resource)
    elif resource.kind == ResourceKind.Z80_BINARY:
        # Another binary blob. Decompiling this may someday be
        # interesting, but not today.
        extract_rawbin("resources/" + resource_label + ".z80.bin", rom, resource)
    elif resource.kind == ResourceKind.METASPRITE_LIST:
        extract_metasprite_list(resource_label, rom, resource)

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

    # Two-phase lookup. Because resources may refer to each other
    # (for instance, palettes), parse all the resources first, then
    # process them.
    for resource_name in cfg.sections():
        cfgsect = cfg[resource_name]
        kind = ResourceKind[cfgsect['kind']]
        if kind == ResourceKind.PALETTE:
            # not actually extracted, just maintained as metadata
            # for extracting sprites
            pal = []
            for p in range(0, 4):
                rom.seek(int(cfgsect['address%d' % p], 0))
                pal.append(Palette.extract_from(rom).rgba())
            palettes[resource_name] = pal
        else:
            resource = Resource(kind=kind,
                                address=int(cfgsect['address'], 0),
                                length=int(cfgsect['length'], 0))
            for key in cfgsect:
                if key == "kind" or key == "address" or key == "length":
                    continue
                resource.attrs[key] = cfgsect[key]
            resource.attrs["label"] = resource_name
            resource_table.append(resource)
            resource_labels[resource_name] = resource.address

    # for all metasprite lists, add in the metasprites they refer to
    resources_to_add = []
    for resource_addr in resource_table:
        resource = resource_table[resource_addr]
        if (resource.kind == ResourceKind.METASPRITE_LIST):
            rom.seek(resource.address)
            pointers = struct.unpack(">%dI" % (resource.length >> 2), rom.read(resource.length))
            for index,p in enumerate(pointers):
                rom.seek(p);
                header = struct.unpack(">bbbb", rom.read(4))
                sprite_count = header[0]
                mspr_resource = Resource(kind=ResourceKind.METASPRITE_HEADER,
                                         address=p,
                                         length=4+(10*sprite_count))
                mspr_name = resource.attrs["label"] + ("Frame%02d" % index)
                if not "label" in mspr_resource.attrs:
                    mspr_resource.attrs["label"] = mspr_name
                resources_to_add.append(mspr_resource)
    for resource in resources_to_add:
        resource_table.append(resource)

    # for all metasprites, add the data
    resources_to_add = []
    for resource_addr in resource_table:
        resource = resource_table[resource_addr]
        if (resource.kind == ResourceKind.METASPRITE_HEADER):
            rom.seek(resource.address)
            mspr = MetaSprite.extract_from(rom)
            for index,s in enumerate(mspr.sprites):
                sprdat_name = resource.attrs["label"] + ("Data%02d" % index)
                if not "label" in s.data_resource.attrs:
                    s.data_resource.attrs["label"] = sprdat_name
                resources_to_add.append(s.data_resource)
    for resource in resources_to_add:
        resource_table.append(resource)

    # for all sprite lists, add in the sprites, and their data
    resources_to_add = []
    for resource_addr in resource_table:
        resource = resource_table[resource_addr]
        if (resource.kind == ResourceKind.SPRITE_LIST):
            rom.seek(resource.address)
            pointers = struct.unpack(">%dI" % (resource.length >> 2), rom.read(resource.length))
            for index,p in enumerate(pointers):
                rom.seek(p);
                spr = Sprite.extract_from(rom)
                spr_name = resource.attrs["label"] + ("Frame%02d" % index)
                if not "label" in spr.header_resource.attrs:
                    spr.header_resource.attrs["label"] = spr_name
                sprdat_name = spr_name + ("Data")
                if not "label" in spr.data_resource.attrs:
                    spr.data_resource.attrs["label"] = sprdat_name
                resources_to_add.append(spr.header_resource)
                resources_to_add.append(spr.data_resource)
    for resource in resources_to_add:
        resource_table.append(resource)

    # now go through extraction
    with open("resources/debug.txt", "w") as out:
        out.write("; known resources\n")
        last_resource = None
        next_addr = 0x00000000
        for resource_addr in sorted(resource_table.keys()):
            resource = resource_table[resource_addr]

            if resource.address != next_addr:
                if resource.address - next_addr < 0:
                    out.write(";;; DATA OVERLAP: %08x:%d vs %08x:%d\n" %
                              (last_resource.address, last_resource.length,
                               resource.address, resource.length))
                else:
                    out.write(";;; MISSING DATA between %08x and %08x (len %d)\n" %
                              (next_addr, resource.address,
                               (resource.address - next_addr)))

            out.write("%s:\t; offset $%08x, len %d\n" % (resource.attrs["label"],
                resource.address, resource.length))
            next_addr = resource.address + resource.length
            last_resource = resource
            
            extract_resource(rom, resource)
