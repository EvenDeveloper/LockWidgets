#import <UIKit/UIKit.h>
#import "../Common.h"
#import "headers/NSExtension.h"

@interface LockWidgetsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *widgetIdentifiers;
@end

@interface WGWidgetInfo : NSObject {
	NSPointerArray *_registeredWidgetHosts;
	struct {
		unsigned didInitializeWantsVisibleFrame : 1;
	} _widgetInfoFlags;
	BOOL _wantsVisibleFrame;
	NSString *_sdkVersion;
	NSExtension *_extension;
	long long _initialDisplayMode;
	long long _largestAllowedDisplayMode;
	UIImage *_icon;
	UIImage *_outlineIcon;
	NSString *_displayName;
	CGSize _preferredContentSize;
}
@property (setter=_setIcon:, getter=_icon, nonatomic, retain) UIImage *icon; //@synthesize icon=_icon - In the implementation block
@property (setter=_setOutlineIcon:, getter=_outlineIcon, nonatomic, retain) UIImage *outlineIcon; //@synthesize outlineIcon=_outlineIcon - In the implementation block
@property (assign, nonatomic) CGSize preferredContentSize; //@synthesize preferredContentSize=_preferredContentSize - In the implementation block
@property (setter=_setDisplayName:, nonatomic, copy) NSString *displayName; //@synthesize displayName=_displayName - In the implementation block
@property (getter=_sdkVersion, nonatomic, copy, readonly) NSString *sdkVersion; //@synthesize sdkVersion=_sdkVersion - In the implementation block
@property (assign, setter=_setLargestAllowedDisplayMode:, nonatomic) long long largestAllowedDisplayMode; //@synthesize largestAllowedDisplayMode=_largestAllowedDisplayMode - In the implementation block
@property (assign, setter=_setWantsVisibleFrame:, nonatomic) BOOL wantsVisibleFrame; //@synthesize wantsVisibleFrame=_wantsVisibleFrame - In the implementation block
@property (nonatomic, readonly) NSExtension *extension; //@synthesize extension=_extension - In the implementation block
@property (nonatomic, copy, readonly) NSString *widgetIdentifier;
@property (nonatomic, readonly) double initialHeight;
@property (nonatomic, readonly) long long initialDisplayMode; //@synthesize initialDisplayMode=_initialDisplayMode - In the implementation block
+ (id)_productVersion;
+ (double)maximumContentHeightForCompactDisplayMode;
+ (id)widgetInfoWithExtension:(id)arg1;
+ (void)_updateRowHeightForContentSizeCategory;
- (id)_icon;
- (NSString *)displayName;
- (id)_sdkVersion;
- (CGSize)preferredContentSize;
- (void)setPreferredContentSize:(CGSize)arg1;
- (NSExtension *)extension;
- (id)initWithExtension:(id)arg1;
- (void)_setDisplayName:(NSString *)arg1;
- (NSString *)widgetIdentifier;
- (id)_queue_iconWithSize:(CGSize)arg1 scale:(double)arg2 forWidgetWithIdentifier:(id)arg3 extension:(id)arg4;
- (id)_queue_iconWithOutlineForWidgetWithIdentifier:(id)arg1 extension:(id)arg2;
- (void)_resetIconsImpl;
- (void)_resetIcons;
- (id)widgetInfoWithExtension:(id)arg1;
- (void)_setLargestAllowedDisplayMode:(long long)arg1;
- (BOOL)isLinkedOnOrAfterSystemVersion:(id)arg1;
- (void)requestSettingsIconWithHandler:(/*^block*/ id)arg1;
- (id)_queue_iconFromWidgetBundleForWidgetWithIdentifier:(id)arg1 extension:(id)arg2;
- (void)_setIcon:(UIImage *)arg1;
- (void)_requestIcon:(BOOL)arg1 withHandler:(/*^block*/ id)arg2;
- (id)_outlineIcon;
- (void)_setOutlineIcon:(UIImage *)arg1;
- (void)requestIconWithHandler:(/*^block*/ id)arg1;
- (double)initialHeight;
- (BOOL)wantsVisibleFrame;
- (void)_setWantsVisibleFrame:(BOOL)arg1;
- (void)registerWidgetHost:(id)arg1;
- (void)updatePreferredContentSize:(CGSize)arg1 forWidgetHost:(id)arg2;
- (long long)initialDisplayMode;
- (long long)largestAllowedDisplayMode;
@end