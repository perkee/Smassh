//
//  Supervisor.h
//  Smassh
//
//  Created by perkee on 11/20/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShellShortcut.h"

@protocol Supervisor <NSObject>
-(void) saveShell:(ShellShortcut *) shell atIndex:(NSUInteger) index;
-(void) deleteShellAtIndex:(NSUInteger) index;
-(void) addShell:(ShellShortcut *) shell;
-(void) setScript:(NSString *) script;
@end
