#!/bin/bash
#set -e

echo -e " << clean >> "
make clean

echo -e " << mrproper >> "
make mrproper

echo -e " << out delete >> "
rm -rf out

echo -e " << Building Kernel >> "
./run.sh