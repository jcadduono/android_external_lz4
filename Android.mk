LOCAL_PATH := $(call my-dir)

lz4_version_major := `sed -n '/define LZ4_VERSION_MAJOR/s/.*[[:blank:]]\([0-9][0-9]*\).*/\1/p' < "$(LOCAL_PATH)/lib/lz4.h"`
lz4_version_minor := `sed -n '/define LZ4_VERSION_MINOR/s/.*[[:blank:]]\([0-9][0-9]*\).*/\1/p' < "$(LOCAL_PATH)/lib/lz4.h"`
lz4_version_patch := `sed -n '/define LZ4_VERSION_RELEASE/s/.*[[:blank:]]\([0-9][0-9]*\).*/\1/p' < "$(LOCAL_PATH)/lib/lz4.h"`
lz4_version := $(shell echo $(lz4_version_major).$(lz4_version_minor).$(lz4_version_patch))

common_c_includes := $(LOCAL_PATH)/lib

common_cflags := \
	-std=c99 \
	-Wall -Wextra -Wcast-qual -Wcast-align -Wshadow -Wstrict-aliasing=1 -Wswitch-enum -Wdeclaration-after-statement -Wstrict-prototypes -Wundef \
	-DXXH_NAMESPACE=LZ4_ \
	-DLZ4_VERSION=\"$(lz4_version)\"

lib_cflags := \
	-O3

lib_src_files := \
	lib/lz4.c \
	lib/lz4frame.c \
	lib/lz4hc.c \
	lib/xxhash.c \

programs_c_includes := $(LOCAL_PATH)/programs

programs_cflags := \
	-Wswitch-enum -falign-loops=32

programs_src_files := \
	programs/lz4cli.c \
	programs/lz4io.c \
	programs/datagen.c \
	programs/bench.c

include $(CLEAR_VARS)
LOCAL_MODULE := liblz4-static
LOCAL_C_INCLUDES := $(lib_c_includes) $(common_c_includes)
LOCAL_CFLAGS := $(common_cflags) $(lib_cflags)
LOCAL_SRC_FILES := $(lib_src_files)
LOCAL_SDK_VERSION := 21
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := liblz4
LOCAL_C_INCLUDES := $(lib_c_includes) $(common_c_includes)
LOCAL_CFLAGS := $(common_cflags) $(lib_cflags)
LOCAL_SRC_FILES := $(lib_src_files)
LOCAL_SDK_VERSION := 21
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := lz4
LOCAL_C_INCLUDES := $(programs_c_includes) $(common_c_includes)
LOCAL_CFLAGS := $(common_cflags) $(programs_cflags)
LOCAL_SRC_FILES := $(programs_src_files)
LOCAL_SDK_VERSION := 21
LOCAL_MODULE_TAGS := optional
ifdef LZ4_STATIC
	LOCAL_STATIC_LIBRARIES := liblz4-static
else
	LOCAL_SHARED_LIBRARIES := liblz4
endif
include $(BUILD_EXECUTABLE)

