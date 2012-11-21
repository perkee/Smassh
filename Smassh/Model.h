//
//  Model.h
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShellShortcut.h"
#import "Config.h"

@interface Model : NSObject

@property(nonatomic, readonly) Config         *config;
@property(nonatomic, readonly) NSMutableArray *shells;
-(id) init;
@end
