//Copyright © 2018 Kiet Ha

@interface SBUILegibilityLabel : UIView
@property (nonatomic,copy) NSString *string;
@end

@interface NCNotificationListSectionRevealHintView : UIView
- (void)_updateHintTitle;
@end


@interface NCNotificationNoContentView : UIView
//you dont have to declare -(void)layoutSubviews since that method is public / check UIView.h in UIKit
@end

static BOOL enabled;
static NSString *changeNotiTxt = @""; // just set it to nothing cz some want it blank


#define kIdentifier @"com.kaitouiet.changemyoldies"
#define kSettingsChangedNotification (CFStringRef)@"com.kaitouiet.changemyoldies/ReloadPrefs"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.kaitouiet.changemyoldies.plist"

%group iOS11

%hook NCNotificationListSectionRevealHintView
- (void)_updateHintTitle {
    %orig; // returns original method if the tweak aint enabled
    // %orig; here runs the original code then runs your code 
    // if you put it in the end your code will run first then the original code 
    // plus this doesn't return anythiny since the method return type is void 
    if (enabled) {
      [MSHookIvar<SBUILegibilityLabel *>(self, "_revealHintTitle") setString:changeNotiTxt];
}
}
%end

%end


%group iOS10

static UILabel *ios10isabitch;

%hook NCNotificationNoContentView
-(void)layoutSubviews {
  %orig;
  if (enabled) {
  ios10isabitch = MSHookIvar<UILabel *>(self,"_noNotificationsLabel");
  // when you say UILabel *ios10isabitch
  //you're creating a new label instince each time layoutSubviews runs which runs two time every time you swipe the nc down or up
  ios10isabitch.text = [NSString stringWithFormat:@"%@", changeNotiTxt]; // you can put changeNotiTxt rather than using stringWithFormat since its an NSString
  //since its a UILabel we change the text to the string we made above
}
}
%end

%end


static void reloadPrefs() {
	CFPreferencesAppSynchronize((CFStringRef)kIdentifier);

	NSDictionary *prefs = nil;
	if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (keyList != nil) {
			prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
			if (prefs == nil)
				prefs = [NSDictionary dictionary];
			CFRelease(keyList);
		}
	} else {
		prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
	}

	enabled = [prefs objectForKey:@"enabled"] ? [(NSNumber *)[prefs objectForKey:@"enabled"] boolValue] : true;
  changeNotiTxt = [prefs objectForKey:@"changeNotiTxt"] ? [prefs objectForKey:@"changeNotiTxt"] : changeNotiTxt;

	}

%ctor {
    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, kSettingsChangedNotification, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

//%init;

    if (%c(NCNotificationListSectionRevealHintView))  // if it has this class
        %init(iOS11); // then use the iOS11 group
    else
        %init(iOS10);


  }

//thanks Tonyk7🖤 for teaching me new things everyday:), was a good lesson of MSHookIvar
