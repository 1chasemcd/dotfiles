from cairosvg import svg2png
import sys

with open("/home/chasemcdonald/.cache/wal/colors") as colors:
    color = colors.read().splitlines()[1]

with open("/home/chasemcdonald/.config/background/background.svg") as svg:
    svg_data = svg.read()

svg_data = svg_data.replace("BACKGROUND_COLOR_HERE", color)

png_bytes = svg2png(bytestring=svg_data)

with open("/home/chasemcdonald/.config/background/output.png", "wb") as png:
    png.write(png_bytes)
