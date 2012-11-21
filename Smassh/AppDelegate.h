//
//  AppDelegate.h
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"
#import "PrefsWC.h"
#import "Supervisor.h"
#import "Notifiable.h"
#import "Debug.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, Supervisor>

@property (nonatomic, readonly) IBOutlet NSMenu *statusMenu;
@property (nonatomic, readonly) NSStatusItem    *statusItem;
@property (nonatomic, readonly) PrefsWC         *settings;

@property (nonatomic, readonly) Model          *model;
@property (nonatomic, readonly) NSMutableArray *shells;
@property (nonatomic, readonly) NSMutableSet   *notifiables;

-(void) runScript: (id)sender;
-(void) edit:      (id)sender;
-(void) notifyAll;
-(void) notifyAllWithType:(notification)type;
+(void) buildMenu:(NSMenu *) menu withShells: (NSArray *) shells;
@end
