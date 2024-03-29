#
# Copyright 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_PACKAGES += \
    memtrack.$(TARGET_BOARD_PLATFORM) \
    WallpaperPicker \
    Launcher3

#$_rbox_$_modify_$_zhengyang: add displayd
PRODUCT_PACKAGES += \
    displayd \
    libion

PRODUCT_PACKAGES += \
    npu_powerctrl
PRODUCT_COPY_FILES += \
    hardware/rockchip/npu_powerctrl/npu_powerctrl.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/npu_powerctrl.rc

#enable this for support f2fs with data partion
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

# This ensures the needed build tools are available.
# TODO: make non-linux builds happy with external/f2fs-tool; system/extras/f2fs_utils
ifeq ($(HOST_OS),linux)
  TARGET_USERIMAGES_USE_F2FS := true
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.rk3399pro.rc:root/init.rk3399pro.rc \
    $(LOCAL_PATH)/init.rk30board.usb.rc:root/init.rk30board.usb.rc \
    $(LOCAL_PATH)/wake_lock_filter.xml:system/etc/wake_lock_filter.xml \
    device/rockchip/rk3399pro/package_performance.xml:$(TARGET_COPY_OUT_OEM)/etc/package_performance.xml \
    device/rockchip/$(TARGET_BOARD_PLATFORM)/media_profiles_default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

ifeq ($(strip $(BOARD_USE_ANDROIDNN)), true)
# ARMNN
PRODUCT_COPY_FILES += \
    device/rockchip/rk3399pro/armnn/android.hardware.neuralnetworks@1.0-service-armnn.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.neuralnetworks@1.0-service-armnn.rc \
    device/rockchip/rk3399pro/armnn/android.hardware.neuralnetworks@1.0-service-armnn:$(TARGET_COPY_OUT_VENDOR)/bin/hw/android.hardware.neuralnetworks@1.0-service-armnn \
    device/rockchip/rk3399pro/armnn/tuned_data:$(TARGET_COPY_OUT_VENDOR)/etc/armnn/tuned_data

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,device/rockchip/rk3399pro/armnn/bin,$(TARGET_COPY_OUT_VENDOR)/etc/armnn/bin)

# OVX
PRODUCT_COPY_FILES += \
    device/rockchip/rk3399pro/ovx/android.hardware.neuralnetworks@1.0-service-ovx.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/android.hardware.neuralnetworks@1.0-service-ovx.rc \
    device/rockchip/rk3399pro/ovx/android.hardware.neuralnetworks@1.0-service-ovx:$(TARGET_COPY_OUT_VENDOR)/bin/hw/android.hardware.neuralnetworks@1.0-service-ovx
endif

$(call inherit-product-if-exists, hardware/rockchip/upgrade_tool/npu_upgrade.mk)
$(call inherit-product-if-exists, hardware/rockchip/npu_transfer/npu_transfer.mk)

# setup dalvik vm configs.
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)


$(call inherit-product-if-exists, vendor/rockchip/rk3399pro/device-vendor.mk)

#for enable optee support
ifeq ($(strip $(PRODUCT_HAVE_OPTEE)),true)
#Choose TEE storage type
#auto (storage type decide by storage chip emmc:rpmb nand:rkss)
#rpmb
#rkss
PRODUCT_PROPERTY_OVERRIDES += ro.tee.storage=rkss
PRODUCT_COPY_FILES += \
       device/rockchip/common/init.optee_verify.rc:root/init.optee.rc
endif

PRODUCT_COPY_FILES += \
    device/rockchip/rk3399pro/public.libraries.txt:vendor/etc/public.libraries.txt

#fireware for dp
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/dptx.bin:root/lib/firmware/rockchip/dptx.bin

#
#add Rockchip properties here
#
PRODUCT_PROPERTY_OVERRIDES += \
                ro.ril.ecclist=112,911 \
                ro.opengles.version=196610 \
                wifi.interface=wlan0 \
                rild.libpath=/vendor/lib64/libril-rk29-dataonly.so \
                rild.libargs=-d /dev/ttyACM0 \
                persist.tegra.nvmmlite = 1 \
                ro.audio.monitorOrientation=true \
                debug.nfc.fw_download=false \
                debug.nfc.se=false \
                ro.rk.screenoff_time=60000 \
                ro.rk.screenshot_enable=true \
                ro.rk.def_brightness=200 \
                ro.rk.homepage_base=http://www.google.com/webhp?client={CID}&amp;source=android-home \
                ro.rk.install_non_market_apps=false \
                sys.hwc.compose_policy=6 \
				sys.hwc.device.primary=HDMI-A \
				sys.hwc.device.extend=eDP,DSI,DP \
                sys.wallpaper.rgb565=0 \
                sf.power.control=2073600 \
                sys.rkadb.root=0 \
                ro.sf.fakerotation=false \
                ro.sf.hwrotation=0 \
                ro.rk.MassStorage=false \
                ro.rk.systembar.voiceicon=true \
                ro.rk.systembar.tabletUI=false \
                ro.rk.LowBatteryBrightness=false \
                ro.tether.denied=false \
                sys.resolution.changed=false \
                ro.default.size=100 \
                ro.product.usbfactory=rockchip_usb \
                wifi.supplicant_scan_interval=15 \
                ro.factory.tool=0 \
                ro.kernel.android.checkjni=0 \
                ro.sf.lcd_density=280 \
                ro.build.shutdown_timeout=6 \
		persist.enable_task_snapshots=false \
		npu.inactivity.sleep.secs=0 \
		ro.product.version = v1.3.0
