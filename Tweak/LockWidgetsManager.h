#import "LockWidgetsView.h"

@interface LockWidgetsManager : NSObject
@property (nonatomic, retain) LockWidgetsView *view;
+ (instancetype)sharedInstance;
- (id)init;
@end