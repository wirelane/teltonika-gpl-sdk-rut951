#!/usr/bin/env bash
set -euo pipefail
SCRIPT_PWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"

BOOTLOADERS=(
"mipsel|rut14x"
"mipsel|dap14x"
"mipsel|rut2m"
"mipsel|rut301"
"mipsel|rut361"
"mipsel|rut9m"
"mipsel|tap100"
"mipsel|otd140"
"mipsel|trb2m"
)

for BOOTLOADER in "${BOOTLOADERS[@]}"; do
	export TMPL_ARCH="${BOOTLOADER%%|*}"
	export TMPL_BOOTLOADER="${BOOTLOADER##*|}"

	perl -p -e 's/\$\{\@([A-Z0-9_]+)\@\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < "${SCRIPT_PWD}/bootloader_ci_template.yml" > "${SCRIPT_PWD}/${TMPL_BOOTLOADER}.yml"
done
