#import "../headers/LockWidgetsViewController.h"

@implementation LockWidgetsViewController
@synthesize collectionView;
@synthesize widgetIdentifiers;

- (void)loadView {
	[super loadView];

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
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Setup the UICollectionView
	collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame];
	[collectionView setDataSource:self];
	[collectionView setDelegate:self];

	//[self.view addSubview:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [widgetIdentifiers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NULL;
}
@end