#include "LockWidgetsPrefsSelectListController.h"
#import "FallingSnow/FallingSnow.h"
#import "FallingSnow/XMASFallingSnowView.h"

@implementation LockWidgetsPrefsSelectListController

CPDistributedMessagingCenter *c = nil;
NSString *cellIdentifier = @"Cell";

NSMutableArray *currentWidgetIdentifiers = nil;
NSMutableArray *currentExtensionIdentifiers = nil;

NSArray *availableWidgetsCache = nil;
NSArray *availableExtensionsCache = nil;

NSMutableDictionary *widgetCellInfoCache = nil;
BOOL refreshDictionary = YES;

- (id)initForContentSize:(CGSize)size {
	self = [super init];

	if (self) {
		[self refreshList];

		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStyleGrouped];
		[_tableView setDataSource:self];
		[_tableView setDelegate:self];
		[_tableView setEditing:NO];
		[_tableView setAllowsSelection:YES];
		[_tableView setAllowsMultipleSelection:NO];
		self.tableView = _tableView;

		if ([self respondsToSelector:@selector(setView:)])
			[self performSelectorOnMainThread:@selector(setView:) withObject:_tableView waitUntilDone:YES];
	}

	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self refreshList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title = @"Select Active Widgets";
	[self refreshList];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.view makeItSnow];
}

- (NSString *)navigationTitle {
	return @"Select Active Widgets";
}

- (void)refreshList {
	c = [CPDistributedMessagingCenter centerNamed:@"me.conorthedev.lockwidgets.messagecenter"];
	NSDictionary *reply = [c sendMessageAndReceiveReplyName:@"getWidgets" userInfo:nil];

	// Get a list of available widget identifiers
	if (availableWidgetsCache == nil) {
		if (self.tableData == nil) {
			NSArray *widgets = reply[@"widgets"];
			availableWidgetsCache = widgets;
			self.tableData = availableWidgetsCache;
		}
	} else {
		if (availableExtensionsCache == nil) {
			if (self.extensionIdentifiers == nil) {
				NSArray *extensions = reply[@"extensions"];
				availableExtensionsCache = extensions;
				self.extensionIdentifiers = availableExtensionsCache;
			}
		} else {
			if (self.tableData == nil) {
				self.tableData = availableWidgetsCache;
			}

			if (self.extensionIdentifiers == nil) {
				self.extensionIdentifiers = availableExtensionsCache;
			}
		}
	}

	// Get the list of currently active identifiers
	NSDictionary *identifierReply = [c sendMessageAndReceiveReplyName:@"getCurrentIdentifiers" userInfo:nil];

	NSMutableArray *currentIdentifiers = identifierReply[@"currentIdentifiers"];
	currentWidgetIdentifiers = currentIdentifiers;

	for (int section = 0, sectionCount = self.tableView.numberOfSections; section < sectionCount; ++section) {
		for (int row = 0, rowCount = [self.tableView numberOfRowsInSection:section]; row < rowCount; ++row) {
			[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];

			for (NSString *identifier in currentWidgetIdentifiers) {
				if ([cell.detailTextLabel.text isEqualToString:identifier]) {
					cell.accessoryType = UITableViewCellAccessoryCheckmark;
					return;
				} else {
					cell.accessoryType = UITableViewCellAccessoryNone;
				}
			}
		}
	}
	[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		if (self.extensionIdentifiers == nil || [self.extensionIdentifiers count] == 0) {
			return 1;
		} else {
			return [self.extensionIdentifiers count];
		}
	} else {
		return [self.tableData count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}

	if (indexPath.section == 0) {
		if (self.extensionIdentifiers == nil || [self.extensionIdentifiers count] == 0) {
			cell.textLabel.text = @"No extensions found!";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.detailTextLabel.text = @"Maybe you should try out Notepad?";
			cell.detailTextLabel.textColor = [UIColor grayColor];

			return cell;
		}

		NSString *identifier = [self.extensionIdentifiers objectAtIndex:indexPath.row];

		c = [CPDistributedMessagingCenter centerNamed:@"me.conorthedev.lockwidgets.messagecenter"];
		NSDictionary *reply = [c sendMessageAndReceiveReplyName:@"getExtensionInfo" userInfo:@{@"identifier" : identifier}];

		NSData *imageData = reply[@"imageData"];
		UIImage *image = [UIImage imageWithData:imageData];

		cell.textLabel.text = reply[@"displayName"];
		cell.detailTextLabel.text = identifier;
		cell.detailTextLabel.textColor = [UIColor grayColor];

		if (image) {
			cell.imageView.image = [self rescaleImage:image scaledToSize:CGSizeMake(30, 30)];
		} else {
			cell.imageView.image = [self rescaleImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LockWidgetsPrefs.bundle/icon@3x.png"] scaledToSize:CGSizeMake(30, 30)];
		}

		for (NSString *identifier in currentWidgetIdentifiers) {
			if ([cell.detailTextLabel.text isEqualToString:identifier]) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
	} else {
		if (widgetCellInfoCache == nil) {
			widgetCellInfoCache = [[NSMutableDictionary alloc] init];
		}

		NSString *identifier = [self.tableData objectAtIndex:indexPath.row];

		NSDictionary *reply = [widgetCellInfoCache objectForKey:identifier];

		if (refreshDictionary || reply == nil) {
			c = [CPDistributedMessagingCenter centerNamed:@"me.conorthedev.lockwidgets.messagecenter"];
			reply = [c sendMessageAndReceiveReplyName:@"getInfo" userInfo:@{@"identifier" : identifier}];

			[widgetCellInfoCache setObject:reply forKey:identifier];

			refreshDictionary = NO;
		}

		NSData *imageData = reply[@"imageData"];
		UIImage *image = [UIImage imageWithData:imageData];

		cell.textLabel.text = reply[@"displayName"];
		cell.detailTextLabel.text = identifier;
		cell.detailTextLabel.textColor = [UIColor grayColor];

		if (image) {
			cell.imageView.image = [self rescaleImage:image scaledToSize:CGSizeMake(30, 30)];
		} else {
			cell.imageView.image = [self rescaleImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/LockWidgetsPrefs.bundle/icon@3x.png"] scaledToSize:CGSizeMake(30, 30)];
		}

		for (NSString *identifier in currentWidgetIdentifiers) {
			if ([cell.detailTextLabel.text isEqualToString:identifier]) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				return cell;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
	}

	return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if (cell.selectionStyle == UITableViewCellSelectionStyleNone) {
		return nil;
	}
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier;
	bool isExtension;

	if (indexPath.section == 0) {
		isExtension = YES;
		identifier = [self.extensionIdentifiers objectAtIndex:indexPath.row];
	} else {
		isExtension = NO;
		identifier = [self.tableData objectAtIndex:indexPath.row];
	}

	c = [CPDistributedMessagingCenter centerNamed:@"me.conorthedev.lockwidgets.messagecenter"];

	NSDictionary *reply = [c sendMessageAndReceiveReplyName:@"setIdentifier" userInfo:@{@"identifier" : identifier, @"isExtension" : @(isExtension)}];

	NSDictionary *displayReply = [widgetCellInfoCache objectForKey:identifier];

	if (!(bool)reply[@"status"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
														message:[NSString stringWithFormat:@"Failed to toggle widget \"%@\"!", displayReply[@"displayName"]]
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];

		[alert show];
	}

	refreshDictionary = YES;

	[self refreshList];

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *sectionName;
	switch (section) {
		case 0:
			sectionName = @"Available Extensions";
			break;
		case 1:
			sectionName = @"Available Widgets";
			break;
		default:
			sectionName = @"";
			break;
	}
	return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (UIImage *)rescaleImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end
