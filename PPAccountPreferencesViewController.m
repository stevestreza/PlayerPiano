//
//  PPAccountPreferencesViewController.m
//
//  Created by Matt Ball on 5/22/10.
//
//  See LICENSE.md file in the PlayerPiano source directory, or at
//  http://github.com/amazingsyco/PlayerPiano/blob/master/LICENSE.md
//

#import "PPAccountPreferencesViewController.h"


@implementation PPAccountPreferencesViewController

-(NSString *)title{
	return NSLocalizedString(@"Account", @"Title of 'Account' preference pane");
}

-(NSString *)identifier{
	return @"AccountPreferences";
}

-(NSImage *)image{
	return [NSImage imageNamed:NSImageNameUserAccounts];
}

@end
