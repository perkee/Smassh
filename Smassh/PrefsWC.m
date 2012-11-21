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
@synthesize table;
@synthesize save;
@synthesize apply;
@synthesize clear;
@synthesize supervisor;
@synthesize add;
@synthesize del;

-(id) initWithShells:(NSMutableArray *)someShells
{
  if(self = [super initWithWindowNibName:@"Settings"])
  {
    shells = someShells;
  }
  return self;
}

- (void)windowDidLoad
{
  [super windowDidLoad];
    
  // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  
  //NSView *sView = [self.window contentView];
  //NSLog(@"w: %f h: %f",self.window.frame.size.width,self.window.frame.size.height);
  CGFloat buttonW = 75, buttonH = 30, margin = 10;
  CGFloat buttonX = self.window.frame.size.width - buttonW - margin;
  
  NSRect frame = NSMakeRect(buttonX, margin, buttonW, buttonH);
  NSButton *button = [[NSButton alloc] initWithFrame:frame];
  [button setTitle:@"Save"];
  [button setTarget:self];
  [button setAction:@selector(save:)];
  //[sView addSubview:button];
  //NSTableView *table = [[[[[[sView subviews] objectAtIndex:0] subviews] objectAtIndex:0] subviews] objectAtIndex:0];//BOO YOU WHORE
  [table setAction:@selector(pick:)];
  [table selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
  
  [save  setAction:@selector(save:)];
  [apply setAction:@selector(apply:)];
  [clear setAction:@selector(clear:)];
  [add setAction:@selector(add:)];
  [del setAction:@selector(del:)];
  [self pickIndex:-1]; //really, pick the first item or nothing if no shells.
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
    }
  }
  else
  {
    ShellShortcut *shell = [shells objectAtIndex:index];
    NSLog(@"display info from shell: %@",[[shells objectAtIndex:index] nick]);
    [nickField setStringValue:[shell nick]];
    [userField setStringValue:[[shell props] objectForKey:@"user"]];
    [hostField setStringValue:[[shell props] objectForKey:@"host"]];
    [initField setStringValue:[[shell props] objectForKey:@"init"]];
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
                                                             nil]];
  [supervisor saveShell:tmp atIndex:[[self table] selectedRow]];
}
-(void)clear:(id)sender
{
  NSLog(@"clear: %@",sender);
}

//Here begin the Notify methods

-(void)notify
{
  [table reloadData];
  NSLog(@"window got notified");
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
  return [shells count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
  return [[shells objectAtIndex:rowIndex] nick];
}
@end
