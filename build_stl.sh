#!/usr/bin/env bash
# Render every printable part of atoms3_pir_case.scad to STL in ./stl
#   ./build_stl.sh              all parts
#   ./build_stl.sh lid gasket   only the named parts
set -euo pipefail

cd "$(dirname "$0")"
SCAD=atoms3_pir_case.scad
OUT=stl
ALL_PARTS=(base lid gasket atom_collar pir_gasket)

if [[ -n "${OPENSCAD:-}" ]]; then
    :
elif command -v openscad >/dev/null 2>&1; then
    OPENSCAD=openscad
elif [[ -x /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ]]; then
    OPENSCAD=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
else
    echo "OpenSCAD not found; install it or set OPENSCAD=/path/to/openscad" >&2
    exit 1
fi

parts=("$@")
[[ ${#parts[@]} -eq 0 ]] && parts=("${ALL_PARTS[@]}")

mkdir -p "$OUT"
for p in "${parts[@]}"; do
    echo "Rendering $p -> $OUT/$p.stl"
    "$OPENSCAD" -q -D "part=\"$p\"" -o "$OUT/$p.stl" "$SCAD"
done
echo "Done."
