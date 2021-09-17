#!/usr/bin/python

from cairosvg import svg2png
import sys

input_file = "input.svg"
output_file = "output.svg"
custom_replacers = {}

if len(sys.argv) > 1:
    input_file = sys.argv[1]

if len(sys.argv) > 2:
    output_file = sys.argv[2]

with open("/home/chasemcdonald/.cache/wal/colors") as colors:
    colors = colors.read().splitlines()

with open(input_file) as svg:
    svg_data = svg.read()

for i in range(len(colors)):
    svg_data = svg_data.replace("{color" + str(i) + "}", colors[i])

png_bytes = svg2png(bytestring=svg_data)

with open(output_file, "wb") as png:
    png.write(png_bytes)
