# 设置Cmake版本
cmake_minimum_required(VERSION 3.4.1)

# 设置cpp目录路径
set(CPP_DIR ${CMAKE_SOURCE_DIR}/src/main/cpp)

# 设置jniLibs目录路径
set(LIBS_DIR ${CMAKE_SOURCE_DIR}/src/main/jniLibs)

# 设置CPU目录 armeabi
if(${ANDROID_ABI} STREQUAL "armeabi")
set(CPU_DIR armeabi)
endif(${ANDROID_ABI} STREQUAL "armeabi")

# armeabi-v7a
if(${ANDROID_ABI} STREQUAL "armeabi-v7a")
set(CPU_DIR armeabi-v7a)
endif(${ANDROID_ABI} STREQUAL "armeabi-v7a")

# arm64-v8a
if(${ANDROID_ABI} STREQUAL "arm64-v8a")
set(CPU_DIR arm64-v8a)
endif(${ANDROID_ABI} STREQUAL "arm64-v8a")

# x86
if(${ANDROID_ABI} STREQUAL "x86")
set(CPU_DIR x86)
endif(${ANDROID_ABI} STREQUAL "x86")

# x86_64
if(${ANDROID_ABI} STREQUAL "x86_64")
set(CPU_DIR x86_64)
endif(${ANDROID_ABI} STREQUAL "x86_64")

# 添加库
add_library( # 库名称
             ffmpeg

             # 动态库，生成so文件
		     SHARED

		     # 源码
		     ${CPP_DIR}/cmdutils.c
		     ${CPP_DIR}/ffmpeg.c
		     ${CPP_DIR}/ffmpeg_filter.c
		     ${CPP_DIR}/ffmpeg_opt.c
		     ${CPP_DIR}/ffmpeg_cmd.c )

# 用于各种类型声音、图像编解码
add_library( # 库名称
             avcodec

             # 动态库，生成so文件
             SHARED

             # 表示该库是引用的不是生成的
             IMPORTED )

# 引用库文件
set_target_properties( # 库名称
                       avcodec

                       # 库的路径
                       PROPERTIES IMPORTED_LOCATION
                       ${LIBS_DIR}/${CPU_DIR}/libavcodec.so )

# 用于各种音视频封装格式的生成和解析，读取音视频帧等功能
add_library( avformat
             SHARED
             IMPORTED )

set_target_properties( avformat
                       PROPERTIES IMPORTED_LOCATION
                       ${LIBS_DIR}/${CPU_DIR}/libavformat.so )

# 包含一些公共的工具函数
add_library( avutil
             SHARED
             IMPORTED )

set_target_properties( avutil
                       PROPERTIES IMPORTED_LOCATION
                       ${LIBS_DIR}/${CPU_DIR}/libavutil.so )

# 提供了各种音视频过滤器
add_library( avfilter
             SHARED
             IMPORTED )

set_target_properties( avfilter
                       PROPERTIES IMPORTED_LOCATION
                       ${LIBS_DIR}/${CPU_DIR}/libavfilter.so )

# 用于音频重采样，采样格式转换和混合
add_library( swresample
             SHARED
             IMPORTED )

set_target_properties( swresample
                       PROPERTIES IMPORTED_LOCATION
                       ${LIBS_DIR}/${CPU_DIR}/libswresample.so )

# 用于视频场景比例缩放、色彩映射转换
add_library( swscale
             SHARED
             IMPORTED )

set_target_properties( swscale
                       PROPERTIES IMPORTED_LOCATION
                       ${LIBS_DIR}/${CPU_DIR}/libswscale.so )

# 引用源码 ../代表上级目录
include_directories( ../../ffmpeg-4.0/
                     ${CPP_DIR}/include/ )

# 关联库
target_link_libraries( ffmpeg
                       avcodec
                       avformat
                       avutil
                       avfilter
                       swresample
                       swscale )