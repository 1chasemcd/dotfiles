from cairosvg import svg2png
import sys

with open("/home/chasemcdonald/.cache/wal/colors") as colors:
    colors = colors.read().splitlines()

with open("/home/chasemcdonald/.config/background/background.svg") as svg:
    svg_data = svg.read()

for i in range(len(colors)):
    svg_data = svg_data.replace("{color" + str(i) + "}", colors[i])

png_bytes = svg2png(bytestring=svg_data)

with open("/home/chasemcdonald/.config/background/output.png", "wb") as png:
    png.write(png_bytes)
