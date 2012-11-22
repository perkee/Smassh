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

@interface PrefsWC : NSWindowController <NSTableViewDataSource, Notifiable>
@property(nonatomic) NSMutableArray *shells;

@property(nonatomic) id <Supervisor> supervisor;

-(id)initWithShells:(NSMutableArray *) someShells;

-(void)save:(id)sender;
-(void)apply:(id)sender;
-(void)pick:(id)sender;
-(void)clear:(id)sender;
-(void)add:(id)sender;
-(void)del:(id)sender;

-(void)pickIndex:(NSUInteger) index;

-(void)setUsable:(BOOL)flag;

@property(nonatomic) IBOutlet NSTableView *table;
@property(nonatomic) IBOutlet NSTextField *nickField;
@property(nonatomic) IBOutlet NSTextField *userField;
@property(nonatomic) IBOutlet NSTextField *hostField;
@property(nonatomic) IBOutlet NSTextField *initField;

@property(nonatomic) IBOutlet NSButton *save;
@property(nonatomic) IBOutlet NSButton *apply;
@property(nonatomic) IBOutlet NSButton *clear;

@property(nonatomic) IBOutlet NSButton *add;
@property(nonatomic) IBOutlet NSButton *del;

@property(nonatomic) NSDictionary *textFields;

@end
