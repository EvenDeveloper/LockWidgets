INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

ARCHS = arm64
TARGET = iphone:clang:11.2:11.2
SDKVERSION = 11.2

TWEAK_NAME = LockWidgets

$(TWEAK_NAME)_FILES = Tweak.x LockWidgetsView.mm LockWidgetsManager.m
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
