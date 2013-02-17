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

@synthesize textFields;
@synthesize nickField;
@synthesize userField;
@synthesize hostField;
@synthesize initField;
@synthesize portField;

@synthesize tableScroller;
@synthesize table;

@synthesize windowButtons;
@synthesize save;
@synthesize apply;
@synthesize clear;
@synthesize supervisor;
@synthesize add;
@synthesize del;
@synthesize listButtons;

@synthesize start;

@synthesize labels;
@synthesize nickLabel;
@synthesize userLabel;
@synthesize hostLabel;
@synthesize initLabel;
@synthesize portLabel;

@synthesize normalControls;

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
  if(0 == [shells count])
  {
    [self add:self];
  }
}

- (void)windowDidLoad
{
  [super windowDidLoad];

  [table setAction:@selector(pick:)];
  [table selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
  
  [save  setAction:@selector(save:)];
  [apply setAction:@selector(apply:)];
  [clear setAction:@selector(clear:)];
  [add   setAction:@selector(add:)];
  [del   setAction:@selector(del:)];
  [start setAction:@selector(add:)];
  [portField setDelegate:self];
  [self pickIndex:-1]; //really, pick the first item or nothing if no shells.
  
  textFields    = [NSDictionary dictionaryWithObjectsAndKeys:
                   nickField, @"nick",
                   userField, @"user",
                   hostField, @"host",
                   initField, @"init",
                   portField, @"port",
                   nil];
  labels        = [NSDictionary dictionaryWithObjectsAndKeys:
                   nickLabel, @"nick",
                   userLabel, @"user",
                   hostLabel, @"host",
                   initLabel, @"init",
                   portLabel, @"port",
                   nil];
  windowButtons = [NSDictionary dictionaryWithObjectsAndKeys:
                   clear, @"clear",
                   apply, @"apply",
                   save,  @"save",
                   nil];
  listButtons   = [NSDictionary dictionaryWithObjectsAndKeys:
                   add, @"add",
                   del, @"del",
                   nil];
  normalControls = [NSArray arrayWithObjects:
                    textFields,
                    labels,
                    windowButtons,
                    listButtons,
                    tableScroller, //dangerous because mixed, but NSDictionary+Hide provides setHidden:
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
      [textFields setStringValue:@""];
    }
  }
  else
  {
    ShellShortcut *shell = [shells objectAtIndex:index];
    if(VERBOSE)
    {
      NSLog(@"display info from shell: %@",[[shells objectAtIndex:index] nick]);
    }
    for(id key in textFields)
    {
      //the shell properties and the text fields are in dictionaries with corresponding keys
      [[textFields objectForKey:key] setStringValue:[[shell props] objectForKey:key]];
    }
  }
}

-(void)add:(id)sender
{
  NSLog(@"add");
  if([shells count] > 0)
  {
    [self apply:sender];
  }
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
  ShellShortcut *tmp = [[ShellShortcut alloc] initWithProps:[textFields stringValues]];
  [supervisor saveShell:tmp atIndex:[[self table] selectedRow]];
}
-(void)clear:(id)sender
{
  [self pick:table];
}
//Allow use of text fields and list
-(void)setUsable:(BOOL)flag;
{
  for(id obj in normalControls)
  {
    //extended NSDictionaries to hide all children in NSDictionary+Hide
    [obj setHidden:!flag];
  }
}

//Here begin the Notify methods

-(void)notify
{
  [table reloadData];
  NSUInteger count = [shells count];
  [self setUsable:(count != 0)];
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
  NSUInteger count = [shells count];
  [start setHidden:(count!=0)];
  return count;
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
