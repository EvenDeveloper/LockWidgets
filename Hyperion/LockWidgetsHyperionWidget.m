#import "LockWidgetsHyperionWidget.h"

@interface LockWidgetsHyperionWidget () {
	LockWidgetsView *lockWidgetsView;
}
@end

@implementation LockWidgetsHyperionWidget
- (void)setup {
	self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 10, 150)];
	self.contentView.backgroundColor = [UIColor clearColor];

	lockWidgetsView = [[LockWidgetsView alloc] initWithFrame:self.contentView.frame];

	[self.contentView addSubview:lockWidgetsView];
}

- (void)layoutForPreview {
	[lockWidgetsView setHidden:FALSE];
}
@end