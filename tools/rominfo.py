#!/usr/bin/env python3
# Get information from a Sega Genesis ROM header

import argparse
import os
import struct
from collections import namedtuple

HeaderField = namedtuple("HeaderField", "offset length shortarg name pack");

fields = [
   HeaderField(0x100, 0x10, "s", "system_name", "16s"),
   HeaderField(0x110, 0x10, "d", "copyright_date", "16s"),
   HeaderField(0x120, 0x30, "n", "domestic_game_name", "48s"),
   HeaderField(0x150, 0x30, "j", "overseas_game_name", "48s"),
   HeaderField(0x180, 10,   "p", "product_number", "10s"),
   HeaderField(0x18C, 2,    "r", "product_revision", "2s"),
   HeaderField(0x18E, 2,    "c", "checksum", ">H"),
];

parser = argparse.ArgumentParser(description='Sega Genesis ROM Info')
for field in fields:
   parser.add_argument("-"+field.shortarg, "--"+field.name, action='store_true', required=False)
parser.add_argument('romfile', help='Source ROM File')
args = vars(parser.parse_args())

specified_field_count = 0
for field in fields:
   if (args[field.name]):
      specified_field_count += 1

with open(args['romfile'], "rb") as rom:
   for field in fields:
      # If we specified any field, and it did not include this one, skip it.
      if specified_field_count > 0 and not args[field.name]:
          continue

      rom.seek(field.offset)
      data = rom.read(field.length)

      unpacked = struct.unpack(field.pack, data)[0]
      if type(unpacked) is bytes:
          unpacked = unpacked.decode('ascii').strip()

      # Add name if we're dumping more than one field; otherwise, just
      # print the value.
      if specified_field_count == 1:
          print("%s" % unpacked)
      else:
          print("%s: %s" % (field.name, unpacked))
