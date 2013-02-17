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
#import "NSDictionary+Hide.h"
#import "Model.h"

@interface PrefsWC : NSWindowController <NSTableViewDataSource, Notifiable, NSTextFieldDelegate, NSWindowDelegate>
@property(nonatomic) NSMutableArray *shells;
@property(nonatomic) Model *model;

@property(nonatomic) id <Supervisor> supervisor;

-(id)initWithShells:(NSMutableArray *) someShells model:(Model *) aModel;

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

@property (weak) IBOutlet NSScrollView *tableScroller;
@property(nonatomic) IBOutlet NSTableView *table;
//textfields
@property(nonatomic) NSDictionary *textFields; //to loop through them all at once
@property(nonatomic) IBOutlet NSTextField *nickField;
@property(nonatomic) IBOutlet NSTextField *userField;
@property(nonatomic) IBOutlet NSTextField *hostField;
@property(nonatomic) IBOutlet NSTextField *initField;
@property(nonatomic) IBOutlet NSTextField *portField;

//labels
@property(nonatomic) NSDictionary *labels;
@property(nonatomic) IBOutlet NSTextField *nickLabel;
@property(nonatomic) IBOutlet NSTextField *userLabel;
@property(nonatomic) IBOutlet NSTextField *hostLabel;
@property(nonatomic) IBOutlet NSTextField *initLabel;
@property(nonatomic) IBOutlet NSTextField *portLabel;

//buttons for changing shells
@property(nonatomic) NSDictionary *windowButtons;
@property(nonatomic) IBOutlet NSButton *save;
@property(nonatomic) IBOutlet NSButton *apply;
@property(nonatomic) IBOutlet NSButton *clear;
//Buttons for adding/removing to/from shell list
@property(nonatomic) NSDictionary *listButtons;
@property(nonatomic) IBOutlet NSButton *add;
@property(nonatomic) IBOutlet NSButton *del;
@property(nonatomic) IBOutlet NSButton *start;
@property(nonatomic) IBOutlet NSButton *blankButton;
@property(nonatomic) IBOutlet NSButtonCell *blankButtonCell;

@property(nonatomic) NSArray *normalControls;

//Settings
@property(nonatomic) IBOutlet NSTextField *scriptField;

-(void)saveSettings;

@end
