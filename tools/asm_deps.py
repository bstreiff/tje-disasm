#!/usr/bin/env python3
# return makefile dependencies for a motorola-syntax .asm file

import argparse
import re
import sys

parser = argparse.ArgumentParser(description='ASM dependency gatherer')
parser.add_argument('filename', help='asm filename')
args = vars(parser.parse_args())

include_expr = re.compile('\t(INCLUDE|INCBIN)\t(.*)\n')

deps = []

with open(args['filename'], "r") as table:
    for line in table:
        m = include_expr.match(line)
        if m:
           deps.append(m.group(2))

sys.stdout.write("%s :" % args['filename'])
for d in deps:
    sys.stdout.write(" %s" % d)
sys.stdout.write("\n")
