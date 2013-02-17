//
//  AppDelegate.m
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "AppDelegate.h"
#import "ShellMenuItem.h"

#define VERBOSE NO

@implementation AppDelegate
@synthesize model;
@synthesize shells;
@synthesize settings;
@synthesize notifiables;
@synthesize statusItem;
@synthesize statusMenu;
@synthesize statusImage;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  //awakeFromNib runs before this, so all the init is in there.
}
- (void) awakeFromNib
{
  
  model  = [[Model alloc] init];
  shells = [model shells];
  
  [AppDelegate buildMenu:statusMenu withShells:shells];
  
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  [statusItem setMenu:statusMenu];
  [statusItem setHighlightMode:YES];
  
  settings = [[PrefsWC alloc] initWithShells:shells];
  [settings setSupervisor:self];
  [[settings window] orderOut:self];
  
  notifiables = [NSMutableSet setWithObjects:settings,model,nil];
  
  NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"icon_32x32@2x" ofType:@"png"];
  if(VERBOSE)
  {
    NSLog(@"loading image: %@",imgPath);
  }
  statusImage = [[NSImage alloc] initWithContentsOfFile:imgPath];
  [statusItem setImage:statusImage];
}

-(void) runScript:(id)sender
{
  NSString *script = [NSString stringWithFormat:[[[model config] config] objectForKey:@"script"],[[sender shell] cmd]];
  NSLog(@"running script for %@:\n%@",[[sender shell] nick], script);
  NSDictionary* errorDict;
  NSAppleScript* aScript = [[NSAppleScript alloc] initWithSource:script];
  NSAppleEventDescriptor *returnDescriptor = [aScript executeAndReturnError:&errorDict];
  if(VERBOSE)
  {
    NSLog(@"ed: %@\nevent: %@",errorDict,returnDescriptor);
  }
}
-(void) edit:(id)sender
{
  [settings activate];
}
-(void) addShell:(ShellShortcut *)shell
{
  if(VERBOSE)
  {
    NSLog(@"Adding %@",shell);
    [Debug printShells:shells];
  }
  [shells addObject:shell];
  [self notifyAllWithType:NotificationAdded];
  [AppDelegate buildMenu:statusMenu withShells:shells];
}

-(void) saveShell:(ShellShortcut *)shell atIndex:(NSUInteger)index
{
  if(VERBOSE)
  {
    NSLog(@"Saving at %lu: %@",index,shell);
    [Debug printShells:shells];
  }
  [shells replaceObjectAtIndex:index withObject:shell];
  [self notifyAll];
  [AppDelegate buildMenu:statusMenu withShells:shells];
}
-(void) deleteShellAtIndex:(NSUInteger)index
{
  if(VERBOSE)
  {
    NSLog(@"Deleting at %lu",index);
    [Debug printShells:shells];
  }
  [shells removeObjectAtIndex:index];
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
