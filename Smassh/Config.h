//
//  Config.h
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShellShortcut.h"
#import "Notifiable.h"

@interface Config : NSObject <Notifiable>

@property(nonatomic, readonly) NSMutableArray *shells;

@property(nonatomic, readonly) NSString *appName;
@property(nonatomic, readonly) NSString *supportDir;
@property(nonatomic, readonly) NSString *cfgFile;

@property(nonatomic, readonly) NSMutableDictionary *config;

-(id)   init;

@end
