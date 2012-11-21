//
//  ShellShortcut.h
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShellShortcut : NSObject

@property(nonatomic, copy)     NSString            *nick;
@property(nonatomic, copy)     NSMutableDictionary *props;

-(id) init;
-(id) initWithProps: (NSMutableDictionary *) initProps;
-(id) initWithNick:  (NSString *)            initNick;
-(id) initWithNick:  (NSString *)            initNick
        andProps:    (NSMutableDictionary *) initProps;

-(NSString *) cmd;

-(NSDictionary *) toDictionary;

+(NSString *) buildCommand: (NSDictionary *) cmdProps; 

@end
