#!/usr/bin/env bash
echo "Starting to Compile"
rm -rf AnyKernel
echo "Cloning Clang"
git clone --depth=1 https://github.com/kdrag0n/proton-clang clang
echo "Cloning AnyKernel"
git clone --depth=1 https://github.com/eun0115/AnyKernel3.git -b m20lte AnyKernel
echo "Cloning gcc4.9-64"
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 los-4.9-64
echo "Cloning gcc4.9-32"
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 los-4.9-32
echo "Done"
chat_id="-1001542481275"
token="5389275341:AAFtB8oBu3KUO2_EY68XwQ-mEwBXPOEp64A"
IMAGE=$(pwd)/out/arch/arm64/boot/Image
TANGGAL=$(date +"%F-%S")
START=$(date +"%s")
KERNEL_DIR=$(pwd)
export USE_CCACHE=1
sudo apt install ccache -y
ccache -M 100G
export PATH=$KERNEL_DIR/clang/bin:$PATH
export KBUILD_COMPILER_STRING="$(${KERNEL_DIR}/clang/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"
export ARCH=arm64
export KBUILD_BUILD_HOST=loveade
export KBUILD_BUILD_USER="eun0115"
#export ANDROID_SIMPLE_LMK_MINFREE=96
#export ANDROID_SIMPLE_LMK_TIMEOUT_MSEC=100
export LOCALVERSION="-liquid-EOL-OC-RCU-LMKD-m20lte"
export USB_ANDROID_SAMSUNG_MTP=y
# sticker plox
function sticker() {
    curl -s -X POST "https://api.telegram.org/bot$token/sendSticker" \
        -d sticker="CAACAgEAAxkBAAEnKnJfZOFzBnwC3cPwiirjZdgTMBMLRAACugEAAkVfBy-aN927wS5blhsE" \
        -d chat_id=$chat_id
}
# Send info plox channel
function sendinfo() {
    curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
        -d chat_id="$chat_id" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=html" \
        -d text="<b>Test Kernel</b>%0ABuild started on <code>CI</code>%0AFor device Samsung Galaxy M20%0Abranch <code>$(git rev-parse --abbrev-ref HEAD)</code> (master)%0AUnder commit <code>$(git log --pretty=format:'"%h : %s"' -1)</code>%0AUsing compiler: <code>${KBUILD_COMPILER_STRING}</code>%0AStarted on <code>$(date)</code>%0A<b>Build Status:</b> Beta"
}
# Push kernel to channel
function push() {
    cd AnyKernel
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$token/sendDocument" \
        -F chat_id="$chat_id" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="Build took $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s). | For <b>m20lte</b> | <b>$(${GCC}gcc --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')</b>"
}
# Fin Error
function finerr() {
    curl -s -X POST "https://api.telegram.org/bot$token/sendMessage"
        -d chat_id="$chat_id" \
        -d "disable_web_page_preview=true" \
        -d "parse_mode=markdown" \
        -d text="Build throw an error(s)"
    exit 1
}
# Compile plox
function compile() {
    make O=out ARCH=arm64 m20lte_defconfig
    make -j$(nproc --all) O=out \
                      LLVM=1 \
                      PATH=$KERNEL_DIR/clang/bin:$PATH \
                      ARCH=arm64 \
                      CC=clang \
                      AR=llvm-ar \
                      NM=llvm-nm \
                      STRIP=llvm-strip \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      OBJSIZE=llvm-size \
                      HOSTCC=clang \
                      HOSTCXX=clang++ \
                      HOSTAR=llvm-ar \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi- \

    if ! [ -a "$IMAGE" ]; then
        finerr
        exit 1
    fi
    cp out/arch/arm64/boot/Image AnyKernel
}
# Zipping
function zipping() {
    cd AnyKernel || exit 1
    zip -r9 ${TANGGAL}-oneui-liquid-EOL-OC-personal-m20lte.zip *
    cd ..
}

sendinfo
compile
zipping
END=$(date +"%s")
DIFF=$(($END - $START))
push
exit
done