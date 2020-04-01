# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= exTHmUI

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Default notification/alarm sounds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/exthm/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/exthm/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/exthm/prebuilt/common/bin/50-exthm.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-exthm.sh

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/exthm/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/exthm/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/exthm/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/exthm/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# exTHm-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/exthm/config/permissions/exthm-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/exthm-sysconfig.xml

# Copy all Lineage-specific init rc files
$(foreach f,$(wildcard vendor/exthm/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/exthm/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/exthm/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# This is NOT :) Lineage!
PRODUCT_COPY_FILES += \
    vendor/exthm/config/permissions/org.lineageos.android.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/org.lineageos.android.xml \
    vendor/exthm/config/permissions/privapp-permissions-lineage-system.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-lineage.xml \
    vendor/exthm/config/permissions/privapp-permissions-lineage-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-lineage.xml \
    vendor/exthm/config/permissions/privapp-permissions-cm-legacy.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-cm-legacy.xml

# No! This is exTHm!
PRODUCT_COPY_FILES += \
    vendor/exthm/config/permissions/privapp-permissions-exthm.xml:system/etc/permissions/privapp-permissions-exthm.xml

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Hidden API whitelist
PRODUCT_COPY_FILES += \
    vendor/exthm/config/permissions/exthm-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/exthm-hiddenapi-package-whitelist.xml

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/exthm/config/permissions/exthm-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/exthm-power-whitelist.xml

# Pre-granted permissions
PRODUCT_COPY_FILES += \
    vendor/exthm/config/permissions/exthm-default-permissions.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/exthm-default-permissions.xml

# Include AOSP audio files
include vendor/exthm/config/aosp_audio.mk

# Include Lineage audio files
include vendor/exthm/config/lineage_audio.mk

# Include exTHm audio files
include vendor/exthm/config/exthm_audio.mk

ifneq ($(TARGET_DISABLE_LINEAGE_SDK), true)
# Lineage SDK
include vendor/exthm/config/lineage_sdk_common.mk
endif

# TWRP
ifeq ($(WITH_TWRP),true)
include vendor/exthm/config/twrp.mk
endif

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
PRODUCT_PACKAGES += \
    bootanimation.zip

# AOSP packages
PRODUCT_PACKAGES += \
    ExactCalculator \
    Exchange2 \
    Terminal

# Lineage packages
PRODUCT_PACKAGES += \
    AudioFX \
    Backgrounds \
    LineageParts \
    LineageSettingsProvider \
    LineageSetupWizard \
    TrebuchetQuickStep \
    Eleven \
    Jelly \
    LockClock \
    Profiles \
    WeatherProvider

# Core exTHmUI packages
PRODUCT_PACKAGES += \
    Longshot \
    ThemeManager \
    Updater

# Custom exTHmUI packages
PRODUCT_PACKAGES += \
    APlayer

# exTHmUI Theme
PRODUCT_PACKAGES += \
    DefaultTheme

# MiPush
ifneq ($(WITHOUT_MIPUSH),true)
PRODUCT_PACKAGES += \
    MiPushManager \
    MiPushService
ifeq ($(WITH_MIPUSH_PROP),true)
    PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
        ro.miui.ui.version.name = V10 \
        ro.miui.ui.version.code = 8 \
        ro.miui.version.code_time = 1544025600 \
        ro.fota.oem = Xiaomi \
        ro.miui.internal.storage = /sdcard/
endif
endif

# Accents
PRODUCT_PACKAGES += \
    LineageBlackTheme \
    LineageDarkTheme \
    LineageBlackAccent \
    LineageBlueAccent \
    LineageBrownAccent \
    LineageCyanAccent \
    LineageGreenAccent \
    LineageOrangeAccent \
    LineagePinkAccent \
    LineagePurpleAccent \
    LineageRedAccent \
    LineageYellowAccent

# Accents from crDroid
PRODUCT_PACKAGES += \
    Amber \
    BlueGrey \
    DeepOrange \
    DeepPurple \
    Grey \
    Indigo \
    LightBlue \
    LightGreen \
    Lime \
    Teal \
    White

# Brand Accents from crDroid
PRODUCT_PACKAGES += \
    AospaGreen \
    AndroidOneGreen \
    CocaColaRed \
    DiscordPurple \
    FacebookBlue \
    InstagramCerise \
    JollibeeCrimson \
    MonsterEnergyGreen \
    NextbitMint \
    OneplusRed \
    PepsiBlue \
    PocophoneYellow \
    RazerGreen \
    SamsungBlue \
    SpotifyGreen \
    StarbucksGreen \
    TwitchPurple \
    TwitterBlue \
    XboxGreen \
    XiaomiOrange

# Dark Styles from crDroid
PRODUCT_PACKAGES += \
    SystemAmoledBlack \
    SystemCharcoalBlack \
    SystemMidnightBlue

# Themes
PRODUCT_PACKAGES += \
    LineageThemesStub \
    ThemePicker

# Extra tools in exTHm
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    nano \
    pigz \
    powertop \
    setcap \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Custom off-mode charger
ifeq ($(WITH_LINEAGE_CHARGER),true)
PRODUCT_PACKAGES += \
    lineage_charger_res_images \
    font_log.png \
    libhealthd.lineage
endif

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Conditionally build in su
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    adb_root
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    TrebuchetQuickStep

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/exthm/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/exthm/overlay/common

# FOD
ifeq ($(EXTRA_FOD_ANIMATIONS),true)
DEVICE_PACKAGE_OVERLAYS += vendor/exthm/overlay/fod
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/exthm/overlay/fod
endif

# Extra fonts
ifeq ($(EXTRA_FONTS),true)

PRODUCT_COPY_FILES += \
    vendor/exthm/prebuilt/fonts/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml \
    $(call find-copy-subdir-files,*,vendor/exthm/prebuilt/fonts/ttf,$(TARGET_COPY_OUT_PRODUCT)/fonts)

PRODUCT_PACKAGES += \
	FontAclonicaSourceOverlay \
	FontAmaranteSourceOverlay \
	FontBariolSourceOverlay \
	FontCagliostroSourceOverlay \
	FontComfortaaSourceOverlay \
	FontExotwoSourceOverlay \
	FontStoropiaSourceOverlay \
	FontUbuntuSourceOverlay \
	FontComicSansSourceOverlay \
	FontCoolstorySourceOverlay \
	FontGoogleSansSourceOverlay \
	FontLGSmartGothicSourceOverlay \
	FontNotoSerifSourceOverlay \
	FontOneplusSlateSource \
	FontRosemarySourceOverlay \
	FontSamsungOneSourceOverlay \
	FontSonySketchSourceOverlay \
	FontSurferSourceOverlay \
	FontNokiaPureSourceOverlay \
	FontNunitoSourceOverlay \
	FontFifa2018SourceOverlay \
	FontCoconSourceOverlay \
	FontQuandoSourceOverlay \
	FontGrandHotelSourceOverlay \
	FontRedressedSourceOverlay

endif

-include vendor/exthm/config/generate_version.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/exthm/config/partner_gms.mk
