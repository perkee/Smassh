//
//  NSDictionary+Hide.m
//  Smassh
//
//  Created by perkee on 2/16/13.
//  Copyright (c) 2013 perkee. All rights reserved.
//

#import "NSDictionary+Hide.h"

@implementation NSDictionary (Hide)

-(void) setHidden:(BOOL)flag
{
  for(id key in self)
  {
    [[self objectForKey:key] setHidden:flag];
  }
}

@end
