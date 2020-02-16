include $(THEOS)/makefiles/common.mk

ARCHS = arm64
TARGET = iphone:clang:11.2:11.2
SDKVERSION = 11.2

SUBPROJECTS += Tweak Prefs

include $(THEOS_MAKE_PATH)/aggregate.mk
