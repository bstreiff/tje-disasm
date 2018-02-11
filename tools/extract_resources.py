#!/usr/bin/env python3
# Extract binary data (patterns, sprites) from the ROM.

import argparse
import os
import configparser
from collections import namedtuple
from genesisrom import GenesisRomHeader
from resource import Resource, ResourceKind

parser = argparse.ArgumentParser(description='Resource Extractor')
parser.add_argument('rsrccfg', help='Resource Config File')
parser.add_argument('romfile', help='Source ROM')
args = vars(parser.parse_args())

cfg = configparser.ConfigParser()
cfg.read(args['rsrccfg'])

def extract_resource(rom, name, cfgsect):
    resource = Resource(kind=ResourceKind[cfgsect['kind']],
                        address=int(cfgsect['address'], 0),
                        length=int(cfgsect['length'], 0))

    if resource.kind == ResourceKind.RAW_IMAGE:
        # Just write it out as a binary blob
        with open("resources/" + name + ".bin", "wb") as out:
            rom.seek(resource.address)
            out.write(rom.read(resource.length))
    elif resource.kind == ResourceKind.Z80_BINARY:
        # Another binary blob. Decompiling this may someday be
        # interesting, but not today.
        with open("resources/" + name + ".z80.bin", "wb") as out:
            rom.seek(resource.address)
            out.write(rom.read(resource.length))

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
