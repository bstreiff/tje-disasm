#!/usr/bin/env python3
# Try to find locations of RLE-compressed images.

import argparse
import os
import struct
from sprite import MetaSprite
from resource import Resource, ResourceKind, ResourceTable

parser = argparse.ArgumentParser(description='Resource Extractor')
parser.add_argument('romfile', help='Source ROM')
args = vars(parser.parse_args())

def extract_section(rom, section_start, section_end):
    resource_table = ResourceTable(range(section_start, section_end))

    for address in range(section_start, section_end, 2):
        rom.seek(address);

        mspr = None
        try:
            mspr = MetaSprite.extract_from(rom)
        except:
            # couldn't parse it as a metasprite, move on
            continue

        # add to the resource table...
        resource_table.append(mspr.resource)
        for s in mspr.sprites:
            resource_table.append(s.data_resource)

    msprlists = []

    # now try to figure out where the metasprite tables are;
    # these are just arrays of pointers that always seem to come
    # immediately after the last metasprite
    for resource_addr in resource_table:
        resource = resource_table[resource_addr]
        if not resource.kind == ResourceKind.METASPRITE_HEADER:
            continue
        # make sure there isn't something following
        table_addr = resource.address + resource.length
        if table_addr in resource_table:
            continue

        # move to past this metasprite
        rom.seek(table_addr)
        table_pointers = []

        while True:
            # get the pointer
            mspr_pointer = struct.unpack(">I", rom.read(4))[0]
            # pointer must point at a metasprite
            mspr_resource = resource_table.get(mspr_pointer)
            if not mspr_resource:
                break
            if not mspr_resource.kind == ResourceKind.METASPRITE_HEADER:
                break
            table_pointers.append(mspr_pointer)

        if (len(table_pointers) > 0):
            print("metasprite table at %08x, count %d" % (table_addr, len(table_pointers)))
            msprlists.append(Resource(ResourceKind.METASPRITE_LIST,
                                      table_addr, len(table_pointers)*4))


        
with open(args['romfile'], "rb") as rom:
    # all the stuff up-front is code, so start with this address
    # so we skip past it
    extract_section(rom, 0x24440, 0x25978)
    extract_section(rom, 0x25FFA, 0x26FF4)
    extract_section(rom, 0x2BDC8, 0x37470)
    extract_section(rom, 0x3F7FE, 0xFFE54)
