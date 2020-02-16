include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = liblockwidgets

liblockwidgets_FILES = LockWidgetsView.mm
liblockwidgets_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk

all::
	cp ../.theos/obj/debug/liblockwidgets.dylib $(THEOS)/lib
	mkdir -p $(THEOS_STAGING_DIR)/usr/include/lockwidgets
	cp *.h $(THEOS_STAGING_DIR)/usr/include/lockwidgets