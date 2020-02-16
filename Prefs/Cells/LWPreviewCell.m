#import "LWPreviewCell.h"
#import "MRYIPCCenter.h"

@implementation LWPreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
			  reuseIdentifier:(NSString *)reuseIdentifier
					specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier
					  specifier:specifier];

	if (self) {
		NSLog(@"[LWIPCClient] running client in %@", [NSProcessInfo processInfo].processName);
		NSLog(@"[LWIPCClient] client is attempting to call getLWView:");
		MRYIPCCenter *center = [MRYIPCCenter centerNamed:@"me.conorthedev.lockwidgets.ipc"];
		NSData *result = [center callExternalMethod:@selector(getLWView:)
									  withArguments:@{ @"value1" : @5,
													   @"value2" : @7 }];
		NSLog(@"[LWIPCClient] result = %@", result);
		self.previewCollectionView = (UIView *)[NSKeyedUnarchiver unarchiveObjectWithData:result];
		self.previewCollectionView.translatesAutoresizingMaskIntoConstraints = NO;

		[self.contentView addSubview:self.previewCollectionView];

		NSLog(@"%@", self.previewCollectionView);

		[self.previewCollectionView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
			.active = true;
		[self.previewCollectionView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
			.active = true;
		[self.previewCollectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10].active = true;
		[self.previewCollectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10].active = true;
		[self.previewCollectionView.heightAnchor constraintEqualToConstant:150].active = true;

		[self.heightAnchor constraintEqualToConstant:170].active = true;
	}

	return self;
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	self = [self initWithStyle:UITableViewCellStyleDefault
			   reuseIdentifier:@"DottoAppearanceSelectionTableCell"
					 specifier:specifier];
	return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1 {
	return 170.0f;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
	return [self preferredHeightForWidth:width];
}

@end