export TARGET = iphone:9.2:9.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = oldpref
oldpref_FILES = CMORootListController.m
oldpref_INSTALL_PATH = /Library/PreferenceBundles
oldpref_FRAMEWORKS = UIKit
oldpref_PRIVATE_FRAMEWORKS = Preferences
oldpref_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/oldpref.plist$(ECHO_END)
