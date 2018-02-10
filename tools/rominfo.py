#!/usr/bin/env python3
# Get information from a Sega Genesis ROM header

import argparse
import os
import struct
from genesisrom import GenesisRomHeader

shortnames = {
   "s": "system_name",
   "d": "copyright_data",
   "n": "domestic_game_name",
   "j": "overseas_game_name",
   "p": "product_number",
   "r": "product_revision",
   "c": "checksum"
}

parser = argparse.ArgumentParser(description='Sega Genesis ROM Info')
for sn in shortnames:
   parser.add_argument("-"+sn, "--"+shortnames[sn], action='store_true', required=False)
parser.add_argument('romfile', help='Source ROM File')
args = vars(parser.parse_args())

with open(args['romfile'], "rb") as rom:
   header = GenesisRomHeader.extract_from(rom)

   specified_field_count = 0
   for field in header:
      if (args.get(field, False)):
         specified_field_count += 1

   for field in header:
      # If we specified any field, and it did not include this one, skip it.
      if specified_field_count > 0 and not args.get(field, False):
          continue

      unpacked = header.get(field)

      # Add name if we're dumping more than one field; otherwise, just
      # print the value.
      if specified_field_count == 1:
          print("%s" % unpacked)
      else:
          print("%s: %s" % (field, unpacked))
