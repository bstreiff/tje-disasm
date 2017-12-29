#!/usr/bin/env python3
# Extract binary data (patterns, sprites) from the ROM.

import argparse
import os
from collections import namedtuple

parser = argparse.ArgumentParser(description='Resource Extractor')
parser.add_argument('-r', '--rom', help='Source ROM', required=True)
args = vars(parser.parse_args())

Region = namedtuple("Region", "address length file");

regions = [
    Region(0x0009287c,	0x620,	"splash_sega_logo.pat"),
    Region(0x000a783c,	0x560,	"starfield_large.pat"),
    Region(0x000a7d9c,	0x100,	"starfield_small.pat"),
    Region(0x0002c54c,	0x21E0,	"tjae_logo.pat"),
    Region(0x000a839e,	0x1540,	"text.pat"),
]

with open(args['rom'], "rb") as rom:
    # Make sure that this is the right game
    # Get from 0x120 "TOEJAM & EARL   "
    rom.seek(0x120)
    gamename = rom.read(16)
    if (gamename != b"TOEJAM & EARL   "):
        raise "Wrong Game"

    # Figure out which version of the ROM this is
    # Get from 0x18C "00" or "02"
    rom.seek(0x18C)
    version = rom.read(2)
    if (version != b"00"):
        raise "Wrong Version"

    if not os.path.exists("resources"):
        os.makedirs("resources");

    for region in regions:
        with open("resources/" + region.file, "wb") as rsrc:
            rom.seek(region.address);
            rsrc.write(rom.read(region.length));
