#!/bin/bash

# 设置临时文件夹，需要提前手动创建
export TMPDIR="/home/yangle/ffmpeg/ffmpeg-4.0/ffmpegtemp"

# 设置NDK路径
NDK=~/ffmpeg/android-ndk-r14b

# 设置编译针对的平台，可以根据自己的需求进行设置
# 当前设置为最低支持android-14版本，x86架构
SYSROOT=$NDK/platforms/android-14/arch-x86/

# 设置编译工具链，4.9为版本号
TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64

function build_one
{
./configure \
    --enable-cross-compile \
    --enable-shared \
    --enable-pic \
    --disable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --disable-x86asm \
    --prefix=$PREFIX \
    --cross-prefix=$TOOLCHAIN/bin/i686-linux-android- \
    --target-os=android \
    --arch=$CPU \
    --sysroot=$SYSROOT \

$ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
}

# 设置编译后的文件输出目录
CPU=x86
PREFIX=$(pwd)/android/$CPU
build_one
