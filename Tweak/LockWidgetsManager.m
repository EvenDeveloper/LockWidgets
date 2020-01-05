#import "LockWidgetsManager.h"

@implementation LockWidgetsManager

+ (instancetype)sharedInstance {
	static LockWidgetsManager *sharedInstance = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	  sharedInstance = [LockWidgetsManager alloc];
	});

	return sharedInstance;
}

- (id)init {
	return [LockWidgetsManager sharedInstance];
}
@end