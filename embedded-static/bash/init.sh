#!/bin/bash

set -e

SH_SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

source $SH_SCRIPT_DIR/compose.sh