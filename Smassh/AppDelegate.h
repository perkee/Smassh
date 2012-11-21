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
{
  IBOutlet NSMenu *statusMenu;
  NSStatusItem *statusItem;
}
@property (nonatomic, readonly) Model *model;

@property (assign) IBOutlet NSWindow *window;
@property PrefsWC *settings;

@property (nonatomic) NSMutableArray *shells;

@property (nonatomic) NSMutableSet *notifiables;

-(void) runScript:(id) sender;
-(void) edit:(id)sender;
-(void) notifyAll;
-(void) notifyAllWithType:(notification)type;
+(void) buildMenu:(NSMenu *) menu withShells: (NSArray *) shells;
@end
