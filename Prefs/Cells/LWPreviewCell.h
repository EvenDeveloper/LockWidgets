#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <UIKit/UIKit.h>

@class PSSpecifier;
@protocol PreferencesTableCustomView
- (id)initWithSpecifier:(PSSpecifier *)specifier;
- (CGFloat)preferredHeightForWidth:(CGFloat)width;
@end

@interface LWPreviewCell
	: PSTableCell <PreferencesTableCustomView>
@property (nonatomic, retain) UIView *previewCollectionView;
@end