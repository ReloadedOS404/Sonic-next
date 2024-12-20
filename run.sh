#!/bin/bash
#set -e

echo -e ""
echo -e "$blue << initializing compilation script >> \n $nocol"
echo -e ""

KERNEL_DEFCONFIG=sweet_defconfig
date=$(date +"%Y-%m-%d-%H%M")
export PATH="$PWD/clang/bin:$PATH"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=ZyuxS
export KBUILD_BUILD_HOST=Action-Github
export KBUILD_COMPILER_STRING="$PWD/clang"

# Speed up build process
MAKE="./makeparallel"
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

echo -e "$blue********************************************"
echo "    Select Build Type < MIUI & OSS >  "
echo -e "*******************************************$nocol"
echo "Choose the build type:"
echo "1. MIUI"
echo "2. OSS"
read -p "Enter the number of your choice: " build_choice

if [ "$build_choice" = "1" ]; then
    sed -i 's/qcom,mdss-pan-physical-width-dimension = <69>;$/qcom,mdss-pan-physical-width-dimension = <695>;/' arch/arm64/boot/dts/qcom/xiaomi/sweet/dsi-panel-k6-38-0c-0a-fhd-dsc-video.dtsi
    sed -i 's/qcom,mdss-pan-physical-height-dimension = <154>;$/qcom,mdss-pan-physical-height-dimension = <1546>;/' arch/arm64/boot/dts/qcom/xiaomi/sweet/dsi-panel-k6-38-0c-0a-fhd-dsc-video.dtsi
echo " "
echo -e "$blue << MIUI Build Select >> \n $nocol"
    name="MIUI"
elif [ "$build_choice" = "2" ]; then
    sed -i 's/qcom,mdss-pan-physical-width-dimension = <695>;$/qcom,mdss-pan-physical-width-dimension = <69>;/' arch/arm64/boot/dts/qcom/xiaomi/sweet/dsi-panel-k6-38-0c-0a-fhd-dsc-video.dtsi
    sed -i 's/qcom,mdss-pan-physical-height-dimension = <1546>;$/qcom,mdss-pan-physical-height-dimension = <154>;/' arch/arm64/boot/dts/qcom/xiaomi/sweet/dsi-panel-k6-38-0c-0a-fhd-dsc-video.dtsi
echo " "
echo -e "$blue << OSS Build Select >> \n $nocol"
    name="OSS"
else
    echo "Invalid choice. Exiting..."
    exit 1
fi

echo " << defconfig is set to $KERNEL_DEFCONFIG >> "
echo -e "$blue***********************************************"
echo "          BUILDING KERNEL          "
echo -e "***********************************************$nocol"
make $KERNEL_DEFCONFIG O=out CC=clang
make -j$(nproc --all) O=out \
                              ARCH=arm64 \
                              LLVM=1 \
                              LLVM_IAS=1 \
                              AR=llvm-ar \
                              NM=llvm-nm \
                              LD=ld.lld \
                              OBJCOPY=llvm-objcopy \
                              OBJDUMP=llvm-objdump \
                              STRIP=llvm-strip \
                              CC=clang \
                              CROSS_COMPILE=aarch64-linux-gnu- \
                              CROSS_COMPILE_ARM32=arm-linux-gnueabi-  2>&1 | tee error.log
                              kernel="out/arch/arm64/boot/Image.gz"
                              dtbo="out/arch/arm64/boot/dtbo.img"
                              dtb="out/arch/arm64/boot/dtb.img"

if [ ! -f "$kernel" ] || [ ! -f "$dtbo" ] || [ ! -f "$dtb" ]; then
	echo -e "\nCompilation failed!"
	exit 1
fi

echo -e "\nKernel compiled successfully! Zipping up...\n"

if [ ! -d "AnyKernel3" ]; then
git clone -q https://github.com/basamaryan/AnyKernel3 -b master AnyKernel3
fi

# Modify anykernel.sh to replace device names
sed -i "s/kernel\.string=.*/kernel.string=Kernel By @ZyuxS/" AnyKernel3/anykernel.sh
sed -i "s/device\.name1=.*/device.name1=sweet/" AnyKernel3/anykernel.sh
sed -i "s/device\.name2=.*/device.name2=sweetin/" AnyKernel3/anykernel.sh
sed -i "s/supported\.versions=.*/supported.versions=11-15/" AnyKernel3/anykernel.sh

cp $kernel AnyKernel3
cp $dtbo AnyKernel3
cp $dtb AnyKernel3
rm -f *zip
cd AnyKernel3
zip -r9 "../SONIC--${name}-${date}.zip" * -x .git
cd ..
rm -rf AnyKernel3/Image.gz
rm -rf AnyKernel3/dtbo.img
rm -rf AnyKernel3/dtb.img
echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"



