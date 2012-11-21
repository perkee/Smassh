//
//  ShellMenuItem.h
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ShellShortcut.h"

@interface ShellMenuItem : NSMenuItem

@property(nonatomic, readonly) ShellShortcut *shell;

-(id) initWithShell: (ShellShortcut *) aShell action:(SEL)aSelector keyEquivalent:(NSString *)charCode;
+(id) itemWithShell: (ShellShortcut *) aShell action:(SEL)aSelector keyEquivalent:(NSString *)charCode;
+(id) itemWithShell: (ShellShortcut *) aShell action:(SEL)aSelector;

@end
