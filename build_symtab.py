#!/usr/bin/env python3
# Turn the output of objdump into an .asm with constants for all
# the symbols.

import argparse
import os
from collections import namedtuple
from operator import attrgetter

parser = argparse.ArgumentParser(description='Symbol Table Header Builder')
parser.add_argument('-t', '--table', help='text output from objdump', required=True)
args = vars(parser.parse_args())

Symbol = namedtuple("Symbol", "address name");

labels = []
constants = []

with open(args['table'], "r") as table:
    for line in table:
        data = line.split()
        if (len(data) > 1):
            address = int(data[0], 16)
            name = data[-1]
            if (name.isupper()):
                constants.append(Symbol(address, name))
            else:
                if (address != 0):
                    labels.append(Symbol(address, name))


labels.sort(key=attrgetter("address"));
constants.sort(key=attrgetter("name"));

print(";");
print("; label and constant definitions.")
print(";");
print();

print("; labels")
for label in labels:
    print("%s\tequ\t$%08X" % (label.name, label.address))

print("; constants")
for const in constants:
    print("%s\tequ\t$%08X" % (const.name, const.address))
