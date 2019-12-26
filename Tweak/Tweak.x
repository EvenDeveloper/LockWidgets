#import "Tweak.h"

// HBPreferences object to be accessed and updated at any time
HBPreferences *tweakPreferences; 

// Values that are loaded from preferences
BOOL tweakEnabled = YES;

%group group
%hook NotificationController
%end
%end

// Used to reload preferences from Cephei
void reloadPreferences() {
	LogInfo("Reloading preferences...");

	// Load preferences file
	tweakPreferences = [[HBPreferences alloc] initWithIdentifier:@"me.conorthedev.lockwidgets"];

	// Set defaults for preferences incase they're not initialized already
	[tweakPreferences registerDefaults:@{
		@"kEnabled": @YES
	}];

	// Register the boolean tweakEnabled with the identifier kEnabled
	[tweakPreferences registerBool:&tweakEnabled default:YES forKey:@"kEnabled"];

	LogDebug("Current Enabled State: %i", tweakEnabled);
}

// Called when the tweak is injected into a new process
%ctor {
	// Easier than having multiple groups, reduces the file length by half basically
	NSString *notificationControllerClass = @"SBDashBoardNotificationAdjunctListViewController";
	if(@available(iOS 13.0, *)) {
		notificationControllerClass = @"CSNotificationAdjunctListViewController";
		LogInfo(@"Current version is iOS 13 or higher");
	} else {
		LogInfo(@"Current version is iOS 12 or lower");
	}

	%init(group, NotificationController = NSClassFromString(notificationControllerClass));

	// Call reloadPreferences and register notification 'me.conorthedev.lockwidgets/ReloadPrefs' to tell the tweak when it should reload it's preferences
	reloadPreferences();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, CFSTR("me.conorthedev.lockwidgets/ReloadPrefs"), NULL, kNilOptions);
}