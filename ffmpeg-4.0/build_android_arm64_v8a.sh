#!/bin/bash

# 设置临时文件夹，需要提前手动创建
export TMPDIR="/home/yangle/ffmpeg/ffmpeg-4.0/ffmpegtemp"

# 设置NDK路径
NDK=~/ffmpeg/android-ndk-r14b

# 设置编译针对的平台，可以根据自己的需求进行设置
# 当前设置为最低支持android-21版本，arch-arm64架构
SYSROOT=$NDK/platforms/android-21/arch-arm64/

# 设置编译工具链，4.9为版本号
TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

function build_one
{
./configure \
    --enable-cross-compile \
    --enable-shared \
    --disable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --prefix=$PREFIX \
    --cross-prefix=$TOOLCHAIN/bin/aarch64-linux-android- \
    --target-os=android \
    --arch=$CPU \
    --sysroot=$SYSROOT \

$ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
}

# 设置编译后的文件输出目录
CPU=aarch64
PREFIX=$(pwd)/android/$CPU
build_one
