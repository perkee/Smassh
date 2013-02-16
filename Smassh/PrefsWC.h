//
//  PrefsWC.h
//  Smassh
//
//  Created by perkee on 11/20/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ShellShortcut.h"
#import "Supervisor.h"
#import "Notifiable.h"

@interface PrefsWC : NSWindowController <NSTableViewDataSource, Notifiable, NSTextFieldDelegate, NSWindowDelegate>
@property(nonatomic) NSMutableArray *shells;

@property(nonatomic) id <Supervisor> supervisor;

-(id)initWithShells:(NSMutableArray *) someShells;

-(void)activate;

//shell manipulation methods
-(void)save:(id)sender;
-(void)apply:(id)sender;
-(void)pick:(id)sender;
-(void)clear:(id)sender;
-(void)add:(id)sender;
-(void)del:(id)sender;

//User interaction methods
-(void)pickIndex:(NSUInteger) index;
-(void)setUsable:(BOOL)flag;

//textfields
@property(nonatomic) NSDictionary *textFields; //to loop through them all at once
@property(nonatomic) IBOutlet NSTableView *table;
@property(nonatomic) IBOutlet NSTextField *nickField;
@property(nonatomic) IBOutlet NSTextField *userField;
@property(nonatomic) IBOutlet NSTextField *hostField;
@property(nonatomic) IBOutlet NSTextField *initField;
@property(nonatomic) IBOutlet NSTextField *portField;
@property(nonatomic) IBOutlet NSTextField *starter; //popover when there are no shells

//buttons for changing shells
@property(nonatomic) IBOutlet NSButton *save;
@property(nonatomic) IBOutlet NSButton *apply;
@property(nonatomic) IBOutlet NSButton *clear;
//Buttons for adding/removing to/from shell list
@property(nonatomic) IBOutlet NSButton *add;
@property(nonatomic) IBOutlet NSButton *del;

@end
