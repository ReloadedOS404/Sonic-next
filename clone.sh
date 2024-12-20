#!/bin/bash
#
# Setup kernelSU & Ubuntu
#

# Setup drivers kernelSU 
git clone https://github.com/rifsxd/KernelSU-Next.git -b susfs-4.14

# Setup kernelSU 
curl -LSs "https://raw.githubusercontent.com/rifsxd/KernelSU/susfs-4.14/kernel/setup.sh" | bash -s main

# Install Dependency
sudo apt update && sudo apt upgrade -y && sudo apt install dialog rlwrap apt-utils -y && sudo apt install nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd sudo make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu -y && sudo apt install build-essential -y && sudo apt install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc -y && sudo apt install pigz -y && sudo apt install python2 -y && sudo apt install python3 -y && sudo apt install cpio -y && sudo apt install lld -y && sudo apt install llvm -y && sudo apt-get install g++-aarch64-linux-gnu -y && sudo apt install libelf-dev -y 

# Update Ubuntu 24 lts
#sudo apt install ubuntu-release-upgrader-core && sudo apt install update-manager-core && sudo apt-get update -y && sudo do-release-upgrade 

# Google Clang 20 Download
mkdir clang && cd clang && wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r547379.tar.gz && tar -xzf clang-r547379.tar.gz && rm -rf clang-r547379.tar.gz && cd ..
