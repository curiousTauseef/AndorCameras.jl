#! /bin/sh
#
# gencode.sh --
#
# Bash script to generate Julia contants for Andor cameras.
#
#-------------------------------------------------------------------------------
#
# This file is part of "AndorCameras.jl" released under the MIT license.
#
# Copyright (C) 2017, Éric Thiébaut.
#

if test $# != 1; then
   echo >&2 "Usage: $0 DEST"
   exit 1
fi
DEST=$1

COMMAND=./gencode

if ! test -x "$COMMAND"; then
   echo >&2 "Error: command '$COMMAND' is not an executable."
   exit 1
fi

# Generate header.
cat >"$DEST" <<'EOF'
#
# constants.jl --
#
# Definitions of types and constants for interfacing Andor cameras in Julia.
#
# *DO NOT EDIT* as this file is automatically generated for your machine.
#
#------------------------------------------------------------------------------
#
# This file is part of "AndorCameras.jl" released under the MIT license.
#
# Copyright (C) 2017, Éric Thiébaut.
#

module Constants

# Export prefixed constants.
export
EOF

# First pass to generate list of exported symbols.
$COMMAND | sed -n -r >>"$DEST" \
               -e 's/[ \t]+/ /g' \
               -e '/^ *const AT_/!d' \
               -e 's/^ *const (AT_[_A-Z0-9]*).*/    \1,/' \
               -e 'H' \
               -e '${x;s/^[ \n]*/    /;s/,[ \n]*$//;p}'

# Second and third passes to generate code and definitions.
echo >>"$DEST"
echo >>"$DEST" "# Constants."
$COMMAND | grep '^ *const AT_' >>"$DEST"
echo >>"$DEST"
echo >>"$DEST" "end # module Constants"
echo >>"$DEST"
echo >>"$DEST" "# Dynamic library."
$COMMAND | grep '^ *const _DLL' >>"$DEST"
