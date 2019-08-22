INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e

TWEAK_NAME = ChangeMyOldies
ChangeMyOldies_FILES = Tweak.xm
ChangeMyOldies_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += oldpref
include $(THEOS_MAKE_PATH)/aggregate.mk
