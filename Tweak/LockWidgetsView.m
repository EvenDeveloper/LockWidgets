#import "LockWidgetsView.h"

@implementation LockWidgetsView
@synthesize collectionView;
@synthesize widgetIdentifiers;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	// Setup the widgetIdentifiers with some default values if it's not set
	if (!widgetIdentifiers) {
		widgetIdentifiers = [@[ @"com.apple.BatteryCenter.BatteryWidget" ] mutableCopy];
	}

	for (NSString *identifier in widgetIdentifiers) {
		NSError *error;
		NSExtension *extension = [NSExtension extensionWithIdentifier:identifier error:&error];

		WGWidgetInfo *widgetInfo = [[NSClassFromString(@"WGWidgetInfo") alloc] initWithExtension:extension];
		LogDebug(@"%@'s displayName is %@", identifier, [widgetInfo displayName]);
	}

	self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
	self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	self.collectionViewLayout.itemSize = CGSizeMake(355, 150);

	self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.collectionViewLayout];

	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;

	self.collectionView.backgroundColor = [UIColor whiteColor];
	self.collectionView.layer.cornerRadius = 13;
	self.collectionView.layer.masksToBounds = true;
	self.collectionView.pagingEnabled = YES;

	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"WidgetCell"];

	[self addSubview:self.collectionView];
	[NSLayoutConstraint activateConstraints:@[
		[self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
		[self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
	]];

	return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"WidgetCell" forIndexPath:indexPath];

	cell.backgroundColor = [UIColor colorWithHue:drand48() saturation:1.0 brightness:1.0 alpha:1.0];

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [widgetIdentifiers count];
}
@end
