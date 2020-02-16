#import "LockWidgetsHyperionWidget.h"

@interface LockWidgetsHyperionWidget () {
	LockWidgetsView *lockWidgetsView;
}
@end

@implementation LockWidgetsHyperionWidget
- (void)setup {
	self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
	self.contentView.backgroundColor = [UIColor clearColor];

	lockWidgetsView = [[LockWidgetsView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
	lockWidgetsView.bounds = CGRectInset(lockWidgetsView.frame, 0, 2.5f);

	[self.contentView addSubview:lockWidgetsView];
}

- (void)layoutForPreview {
	[lockWidgetsView setHidden:FALSE];
}
@end