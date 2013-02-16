//
//  PrefsWC.m
//  Smassh
//
//  Created by perkee on 11/20/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "PrefsWC.h"

@implementation PrefsWC
@synthesize shells;
@synthesize nickField;
@synthesize userField;
@synthesize hostField;
@synthesize initField;
@synthesize portField;
@synthesize starter;
@synthesize table;
@synthesize save;
@synthesize apply;
@synthesize clear;
@synthesize supervisor;
@synthesize add;
@synthesize del;
@synthesize textFields;

#define VERBOSE NO

-(id) initWithShells:(NSMutableArray *)someShells
{
  if(self = [super initWithWindowNibName:@"Settings"])
  {
    shells = someShells;
    [self.window setDelegate:self];
  }
  return self;
}
-(void)activate
{
  [[self window] makeKeyAndOrderFront:self];
  [NSApp activateIgnoringOtherApps:YES];
}

- (void)windowDidLoad
{
  [super windowDidLoad];

  CGFloat buttonW = 75, buttonH = 30, margin = 10;
  CGFloat buttonX = self.window.frame.size.width - buttonW - margin;
  
  NSRect frame = NSMakeRect(buttonX, margin, buttonW, buttonH);
  NSButton *button = [[NSButton alloc] initWithFrame:frame];
  [button setTitle:@"Save"];
  [button setTarget:self];
  [button setAction:@selector(save:)];

  [table setAction:@selector(pick:)];
  [table selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
  
  [save  setAction:@selector(save:)];
  [apply setAction:@selector(apply:)];
  [clear setAction:@selector(clear:)];
  [add setAction:@selector(add:)];
  [del setAction:@selector(del:)];
  [portField setDelegate:self];
  [self pickIndex:-1]; //really, pick the first item or nothing if no shells.
  
  textFields = [NSDictionary dictionaryWithObjectsAndKeys:
                nickField, @"nick",
                userField, @"user",
                hostField, @"host",
                initField, @"init",
                portField, @"port",
                nil];
  [self setUsable:([shells count] != 0)];
}

- (void) windowDidResignKey:(NSNotification *)notification
{
  if(VERBOSE)
  {
    NSLog(@"window blur.");
  }
  [self.window orderOut:self];
}

-(void)pick:(id)sender
{
  [self pickIndex:[sender selectedRow]];
}
-(void)pickIndex:(NSUInteger) index
{
  if(index == -1)
  {
    if([table numberOfRows] > 0)
    {
      [table selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
      [self pickIndex:0];
    }
    else
    {
      [nickField setStringValue:@""];
      [userField setStringValue:@""];
      [hostField setStringValue:@""];
      [initField setStringValue:@""];
      [portField setStringValue:@""];
    }
  }
  else
  {
    ShellShortcut *shell = [shells objectAtIndex:index];
    if(VERBOSE)
    {
      NSLog(@"display info from shell: %@",[[shells objectAtIndex:index] nick]);
    }
    [nickField setStringValue:[shell nick]];
    [userField setStringValue:[[shell props] objectForKey:@"user"]];
    [hostField setStringValue:[[shell props] objectForKey:@"host"]];
    [initField setStringValue:[[shell props] objectForKey:@"init"]];
    [portField setStringValue:[[shell props] objectForKey:@"port"]];
  }
}

-(void)add:(id)sender
{
  NSLog(@"add");
  [supervisor addShell:[[ShellShortcut alloc] init]];
}
-(void)del:(id)sender
{
  NSLog(@"del: %ld",[[self table] selectedRow]);
  [supervisor deleteShellAtIndex:[[self table] selectedRow]];
  [self pickIndex:[[self table] selectedRow]];
}

-(void)save:(id)sender
{
  NSLog(@"save: %@",sender);
  //for now just hide.
  [self apply:sender];
  [self.window orderOut:self];
}
-(void)apply:(id)sender
{
  NSLog(@"apply: %@",sender);
  ShellShortcut *tmp = [[ShellShortcut alloc] initWithProps:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                             nickField.stringValue, @"nick",
                                                             userField.stringValue, @"user",
                                                             hostField.stringValue, @"host",
                                                             initField.stringValue, @"init",
                                                             portField.stringValue, @"port",
                                                             nil]];
  [supervisor saveShell:tmp atIndex:[[self table] selectedRow]];
}
-(void)clear:(id)sender
{
  [self pick:table];
}
//Allow use of text fields
-(void)setUsable:(BOOL)flag;
{
  for(id key in textFields)
  {
    id field = [textFields objectForKey:key];
    [field setEditable:flag];
    [field setEnabled:flag];
    [field setSelectable:flag];
  }
  [del setEnabled:flag];
}

//Here begin the Notify methods

-(void)notify
{
  [table reloadData];
  [self setUsable:([shells count] != 0)];
}
-(void)notifyWithType:(NSNumber *)type
{
  [self notify];
  if([type integerValue] == NotificationAdded)
  {
    //select the new value
    NSUInteger index = [table numberOfRows] - 1;
    [table selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    [self pickIndex:index];
    //highlight the nickname field for editing
    [nickField selectText:self];
  }
}

//Here begin the methods to make the NSTableView happy.

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
  if([shells count] > 0)
  {
    [starter setHidden:YES];
  }
  else
  {
    [starter setHidden:NO];
  }
  return [shells count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
  return [[shells objectAtIndex:rowIndex] nick];
}

//textFieldDelegate stuff

-(void)controlTextDidChange:(NSNotification *)obj
{
  NSUInteger value = [[[obj object] stringValue] integerValue];
  if(value <= 0)
  {
    [[obj object] setStringValue:@""];
  }
  else
  {
    [[obj object] setStringValue:[NSString stringWithFormat:@"%ld",value]];
  }
}

@end
