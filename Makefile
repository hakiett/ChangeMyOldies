export TARGET = iphone:9.2:9.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ChangeMyOldies
ChangeMyOldies_FILES = Tweak.xm
ChangeMyOldies_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += oldpref
include $(THEOS_MAKE_PATH)/aggregate.mk
