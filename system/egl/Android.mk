ifneq (false,$(BUILD_EMULATOR_OPENGL_DRIVER))

LOCAL_PATH := $(call my-dir)

$(call emugl-begin-shared-library,libEGL_emulation)
$(call emugl-import,libOpenglSystemCommon)
$(call emugl-set-shared-library-subpath,egl)

LOCAL_CFLAGS += -DLOG_TAG=\"EGL_emulation\" -DEGL_EGLEXT_PROTOTYPES -DWITH_GLES2

LOCAL_SRC_FILES := \
    eglDisplay.cpp \
    egl.cpp \
    ClientAPIExts.cpp

ifdef IS_AT_LEAST_PPD1
LOCAL_SHARED_LIBRARIES += libdl libnativewindow
else
LOCAL_SHARED_LIBRARIES += libdl
endif

ifdef IS_AT_LEAST_PPD1
LOCAL_HEADER_LIBRARIES += libnativebase_headers
endif

# Used to access the Bionic private OpenGL TLS slot
LOCAL_C_INCLUDES += bionic/libc/private

$(call emugl-end-module)

#### egl.cfg ####

# Ensure that this file is only copied to emulator-specific builds.
# Other builds are device-specific and will provide their own
# version of this file to point to the appropriate HW EGL libraries.
#
ifneq (,$(filter aosp_arm aosp_x86 aosp_mips full full_x86 full_mips sdk sdk_x86 sdk_mips google_sdk google_sdk_x86 google_sdk_mips,$(TARGET_PRODUCT)))
include $(CLEAR_VARS)

LOCAL_MODULE := egl.cfg
LOCAL_SRC_FILES := $(LOCAL_MODULE)

LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/egl
LOCAL_MODULE_CLASS := ETC

ifeq ($(shell test $(PLATFORM_SDK_VERSION) -lt 19 && echo PreKitkat),PreKitkat)
    LOCAL_MODULE_TAGS := debug
endif

include $(BUILD_PREBUILT)
endif # TARGET_PRODUCT in 'full full_x86 full_mips sdk sdk_x86 sdk_mips google_sdk google_sdk_x86 google_sdk_mips')

endif # BUILD_EMULATOR_OPENGL_DRIVER != false
