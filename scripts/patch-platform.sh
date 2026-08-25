#!/bin/sh

set -eu

platform=".arduino/data/packages/UIAP/hardware/ch32v/1.0.42/platform.txt"
original='tools.minichlink.upload.pattern="{path}{cmd}" -w "{build.path}/{build.project_name}.bin" flash'
patched='tools.minichlink.upload.pattern="{path}{cmd}" -c 0x1209b803 -w "{build.path}/{build.project_name}.bin" flash'

if grep -Fq "$patched" "$platform"; then
  exit 0
fi

if ! grep -Fq "$original" "$platform"; then
  echo "想定したminichlink設定が見つかりません: $platform" >&2
  exit 1
fi

ORIGINAL="$original" PATCHED="$patched" \
  perl -0pi -e 's/\Q$ENV{ORIGINAL}\E/$ENV{PATCHED}/' "$platform"
