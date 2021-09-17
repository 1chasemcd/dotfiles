#!/bin/bash
set -ueo pipefail

FORCE_INKSCAPE="$(echo "${FORCE_INKSCAPE-False}" | tr '[:upper:]' '[:lower:]')"
if [[ "${FORCE_INKSCAPE}" == "true" ]]; then
  RENDER_SVG=""
else
  RENDER_SVG="$(command -v rendersvg)" || true
fi
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

if [[ -n "${INKSCAPE}" ]]; then
  if "$INKSCAPE" --help | grep -e "--export-filename" > /dev/null; then
    EXPORT_FILE_OPTION="--export-filename"
  elif "$INKSCAPE" --help | grep -e "--export-file" > /dev/null; then
    EXPORT_FILE_OPTION="--export-file"
  elif "$INKSCAPE" --help | grep -e "--export-png" > /dev/null; then
    EXPORT_FILE_OPTION="--export-png"
  fi
fi

i="$1"

echo "Rendering '$i.png'"

if [[ -n "${RENDER_SVG}" ]]; then
  "$RENDER_SVG" --dpi 96 "$i.svg" "$i.png"
else
  "$INKSCAPE" --export-dpi=96 "$EXPORT_FILE_OPTION=$i.png" "$i.svg" >/dev/null
fi

if [[ -n "${OPTIPNG}" ]]; then
  "$OPTIPNG" -o7 --quiet "$i.png"
fi
