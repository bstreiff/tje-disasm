#!/usr/bin/env python3
# Try to find locations of RLE-compressed images.

import argparse
import os
import sys
import struct
import configparser
from sprite import MetaSprite
from resource import Resource, ResourceKind, ResourceTable

parser = argparse.ArgumentParser(description='Resource Extractor')
parser.add_argument('romfile', help='Source ROM')
args = vars(parser.parse_args())

def extract_section(cfg, rom, section_start, section_end):
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
            msprlists.append(Resource(ResourceKind.METASPRITE_LIST,
                                      table_addr, len(table_pointers)*4))
    # stick these into the resource table (we can't do so while iterating
    # over it)
    for msprlist in msprlists:
        resource_table.append(msprlist)

    # Now, we're going to reduce the resource table down quite a bit;
    # From the metasprite lists, we can reference the metasprites and
    # sprites from those, so we should remove things that can be referenced
    # from other things.
    reduced_resource_table = resource_table.copy()

    # First, remove all sprite data resources referred to by a metasprite
    resources_to_remove = []
    for resource_addr in reduced_resource_table:
        resource = reduced_resource_table[resource_addr]
        if resource.kind == ResourceKind.METASPRITE_HEADER:
            rom.seek(resource.address)
            mspr = MetaSprite.extract_from(rom)
            for s in mspr.sprites:
                resources_to_remove.append(s.data_resource.address)
    for rmv_addr in resources_to_remove:
        reduced_resource_table.pop(rmv_addr, None)

    # Now, remove all metasprites that are part of a metasprite list
    resources_to_remove = []
    for resource_addr in reduced_resource_table:
        resource = reduced_resource_table[resource_addr]
        if resource.kind == ResourceKind.METASPRITE_LIST:
            rom.seek(resource.address)
            pointers = struct.unpack(">%dI" % (resource.length >> 2), rom.read(resource.length))
            for p in pointers:
                resources_to_remove.append(p)
    for rmv_addr in resources_to_remove:
        reduced_resource_table.pop(rmv_addr, None)

    # Add then save off whatever's left
    for resource_addr in reduced_resource_table:
        resource = reduced_resource_table[resource_addr]
        resource_name = 'addr_%08x' % resource_addr
        cfg.add_section(resource_name)
        cfg.set(resource_name, 'kind', resource.kind.name)
        cfg.set(resource_name, 'address', "0x%08x" % resource.address)
        cfg.set(resource_name, 'length', "%d" % resource.length)
        
with open(args['romfile'], "rb") as rom:
    cfg = configparser.ConfigParser()
    # all the stuff up-front is code, so start with this address
    # so we skip past it
    extract_section(cfg, rom, 0x24440, 0x25978)
    extract_section(cfg, rom, 0x25FFA, 0x26FF4)
    extract_section(cfg, rom, 0x2BDC8, 0x37470)
    extract_section(cfg, rom, 0x3F7FE, 0xFFE54)
    cfg.write(sys.stdout, False)
