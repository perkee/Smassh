//
//  AppDelegate.m
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "AppDelegate.h"
#import "ShellMenuItem.h"

@implementation AppDelegate
@synthesize model;
@synthesize shells;
@synthesize settings;
@synthesize notifiables;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSLog(@"adfl");
  // Insert code here to initialize your application
  //awakeFromNib runs before this, so all the init is in there.
}
- (void) awakeFromNib
{
  NSLog(@"afn");
  
  model  = [[Model alloc] init];
  shells = [model shells];
  
  [AppDelegate buildMenu:statusMenu withShells:shells];
  
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:statusMenu];
  [statusItem setTitle:@"SG"];
  [statusItem setHighlightMode:YES];
  
  settings = [[PrefsWC alloc] initWithShells:shells];
  [settings setSupervisor:self];
  [[settings window] orderOut:self];
  
  notifiables = [NSMutableSet setWithObject:settings];
}

-(void) runScript:(id)sender
{
  NSString *script = [NSString stringWithFormat:[[[model config] config] objectForKey:@"script"],[[sender shell] cmd]];
  NSLog(@"running script for %@:\n%@",[[sender shell] nick], script);
  NSDictionary* errorDict;
  NSAppleScript* aScript = [[NSAppleScript alloc] initWithSource:script];
  NSAppleEventDescriptor *returnDescriptor = [aScript executeAndReturnError:&errorDict];
  NSLog(@"ed: %@\nevent: %@",errorDict,returnDescriptor);
}
-(void) edit:(id)sender
{
  [[settings window] orderFront:self];
}
-(void) addShell:(ShellShortcut *)shell
{
  NSLog(@"Adding %@",shell);
  [shells addObject:shell];
  [Debug printShells:shells];
  [self notifyAllWithType:NotificationAdded];
  [AppDelegate buildMenu:statusMenu withShells:shells];
}

-(void) saveShell:(ShellShortcut *)shell atIndex:(NSUInteger)index
{
  NSLog(@"Saving at %lu: %@",index,shell);
  [shells replaceObjectAtIndex:index withObject:shell];
  [Debug printShells:shells];
  [self notifyAll];
  [AppDelegate buildMenu:statusMenu withShells:shells];
}
-(void) deleteShellAtIndex:(NSUInteger)index
{
  NSLog(@"Deleting at %lu",index);
  [shells removeObjectAtIndex:index];
  [Debug printShells:shells];
  [self notifyAll];
  [AppDelegate buildMenu:statusMenu withShells:shells];
}

-(void)notifyAll
{
  [notifiables makeObjectsPerformSelector:@selector(notify)];
}
-(void)notifyAllWithType:(notification)type
{
  //You can't pass scalars via mOPS, so we have to do this
  [notifiables makeObjectsPerformSelector:@selector(notifyWithType:) withObject:[NSNumber numberWithUnsignedInteger:type]];
}

+(void)buildMenu:(NSMenu *)menu withShells:(NSArray *)shells
{
  [menu removeAllItems];
  for(id shell in shells)
  {
    [menu addItem:[ShellMenuItem itemWithShell:shell action:@selector(runScript:)]];
  }
  [menu addItem:[NSMenuItem separatorItem]];
  [menu addItemWithTitle:@"Preferences…" action:@selector(edit:) keyEquivalent:@","];
  [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
}

@end
