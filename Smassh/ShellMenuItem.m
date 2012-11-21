//
//  ShellMenuItem.m
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "ShellMenuItem.h"

@implementation ShellMenuItem
@synthesize shell;

-(id) initWithShell:(ShellShortcut *)aShell action:(SEL)aSelector keyEquivalent:(NSString *)charCode
{
  if(self = [super initWithTitle:[aShell nick] action:aSelector keyEquivalent:charCode])
  {
    shell = aShell;
  }
  return self;
}

+(id)itemWithShell:(ShellShortcut *)aShell action:(SEL)aSelector keyEquivalent:(NSString *)charCode
{
  return [[ShellMenuItem alloc] initWithShell:aShell action:aSelector keyEquivalent:charCode];
}
+(id)itemWithShell:(ShellShortcut *)aShell action:(SEL)aSelector
{
  return [ShellMenuItem itemWithShell:aShell action:aSelector keyEquivalent:@""];
}

@end
