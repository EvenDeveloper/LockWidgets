#import "Tweak.h"

// HBPreferences object to be accessed and updated at any time
HBPreferences *tweakPreferences; 

// Values that are loaded from preferences
BOOL tweakEnabled = YES;

%group group
%hook NotificationController
-(void)viewDidLoad {
	%orig;

	CSNotificationAdjunctListViewController *typedSelf = (CSNotificationAdjunctListViewController *)self;

	LockWidgetsView *lockWidgetsView = [[LockWidgetsView alloc] initWithFrame:CGRectMake(0, 0, typedSelf.view.frame.size.width - 10, 150)];

	UIStackView *stackView = [typedSelf valueForKey:@"_stackView"];
	[stackView addArrangedSubview:lockWidgetsView];

	lockWidgetsView.bounds = CGRectInset(lockWidgetsView.frame, 0, 10.0f);

	[NSLayoutConstraint activateConstraints:@[
	    [lockWidgetsView.centerXAnchor constraintEqualToAnchor:stackView.centerXAnchor],
	    [lockWidgetsView.leadingAnchor constraintEqualToAnchor:stackView.leadingAnchor constant:10],
        [lockWidgetsView.trailingAnchor constraintEqualToAnchor:stackView.trailingAnchor constant:-10],
        [lockWidgetsView.heightAnchor constraintEqualToConstant:150]
	]];
}
%end
%end

// Used to reload preferences from Cephei
void reloadPreferences() {
	// Log that the preferences are being loaded
	LogInfo("Reloading preferences...");

	// Load preferences file
	tweakPreferences = [[HBPreferences alloc] initWithIdentifier:@"me.conorthedev.lockwidgets"];

	// Set defaults for preferences incase they're not initialized already
	[tweakPreferences registerDefaults:@{
		@"kEnabled": @YES
	}];

	// Register the boolean tweakEnabled with the identifier kEnabled
	[tweakPreferences registerBool:&tweakEnabled default:YES forKey:@"kEnabled"];

	// Log in the console if LockWidgets is enabled or disabled
	LogInfo("%s", tweakEnabled ? "LockWidgets is enabled!" : "LockWidgets is disabled!");
}

// Called when the tweak is injected into a new process
%ctor {
	// Call reloadPreferences and register notification 'me.conorthedev.lockwidgets/ReloadPrefs' to tell the tweak when it should reload it's preferences
	reloadPreferences();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, CFSTR("me.conorthedev.lockwidgets/ReloadPrefs"), NULL, kNilOptions);

	// If the tweak is enabled, run all code, otherwise ignore everything else
	if(tweakEnabled) {
		// Easier than having multiple groups, reduces the file length by half basically
		NSString *notificationControllerClass = @"SBDashBoardNotificationAdjunctListViewController";
		if(@available(iOS 13.0, *)) {
			notificationControllerClass = @"CSNotificationAdjunctListViewController";
			LogDebug(@"Current version is iOS 13 or higher, using %@", notificationControllerClass);
		} else {
			LogDebug(@"Current version is iOS 12 or lower, using %@", notificationControllerClass);
		}

		// Start hooking into the classes we need to hook
		%init(group, NotificationController = NSClassFromString(notificationControllerClass));
	}
}