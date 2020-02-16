include $(THEOS)/makefiles/common.mk

ARCHS = arm64
TARGET = iphone:clang:11.2:11.2
SDKVERSION = 11.2

BUNDLE_NAME = LockWidgetsPrefs

LockWidgetsPrefs_FILES = LWRootListController.m Cells/LWPreviewCell.m
LockWidgetsPrefs_LIBRARIES = mryipc
LockWidgetsPrefs_INSTALL_PATH = /Library/PreferenceBundles
LockWidgetsPrefs_FRAMEWORKS = UIKit
LockWidgetsPrefs_PRIVATE_FRAMEWORKS = Preferences
LockWidgetsPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LockWidgetsPrefs.plist$(ECHO_END)
