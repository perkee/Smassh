//
//  Model.m
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize config;
@synthesize shells;

-(id) init
{
  if(self = [super init])
  {
    config = [[Config alloc] init];
    shells = [config shells];
  }
  return self;
}

@end
