//
//  Debug.m
//  Smassh
//
//  Created by perkee on 11/20/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "Debug.h"

@implementation Debug

+(void) printShells:(NSArray *)shellsA
{
  NSLog(@"Shells are now %ld shells:", [shellsA count]);
  NSUInteger nickLength = 0;//length of the longest nickname
  for(id shell in shellsA)
  {
    if(nickLength < [[shell nick] length])
    {
      nickLength = [[shell nick] length];
    }
  }
  //this format string lines up the colons. It is a good thing
  NSString *fmt = [NSString stringWithFormat:@" %%-%lds: %%@",nickLength];
  for(id shell in shellsA)
  {
    NSLog(fmt,[[shell nick] UTF8String],[shell cmd]);
  }
}
@end
