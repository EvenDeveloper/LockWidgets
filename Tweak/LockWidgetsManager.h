#import "LockWidgetsView.h"

@interface LockWidgetsManager : NSObject
@property (nonatomic, weak) LockWidgetsView *view;
+ (instancetype)sharedInstance;
- (id)init;
@end