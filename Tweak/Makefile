INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

ARCHS = arm64
TARGET = iphone:clang:11.2:11.2
SDKVERSION = 11.2

TWEAK_NAME = LockWidgets

LockWidgets_LIBRARIES = mryipc
LockWidgets_FILES = Tweak.x LockWidgetsView.mm LockWidgetsManager.m
LockWidgets_CFLAGS = -fobjc-arc
LockWidgets_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk
