//
//  ShellShortcut.m
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "ShellShortcut.h"

@implementation ShellShortcut
@synthesize nick;
@synthesize props;

-(id)init
{
  return [self initWithNick:nil andProps:nil];
}

-(id)initWithNick:(NSString *)initNick
{
  return [self initWithNick:initNick andProps:nil];
}

-(id)initWithProps:(NSMutableDictionary *)initProps
{
  NSString *aNick = [initProps objectForKey:@"nick"];
  if(aNick == nil || ![aNick isKindOfClass:[NSString class]] || [aNick length] == 0)
  {
    aNick = nil;
  }
  return [self initWithNick:aNick andProps:initProps];
}

-(id)initWithNick:(NSString *)initNick andProps:(NSMutableDictionary *)initProps
{
  if(self = [super init])
  {
    self.nick  = initNick ? initNick  : @"New Shell";
    if(initProps != nil)
    {
      self.props = initProps;
    }
    else
    {
      self.props = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    @"",@"user",
                    @"",@"host",
                    @"",@"init",
                    nil];
    }
  }
  return self;
}

-(NSString *) cmd
{
  return [ShellShortcut buildCommand:self.props];
}

+(NSString *) buildCommand:(NSDictionary *)cmdProps
{
  NSString *user, *host, *init, *cmd;
  
  id prop = [cmdProps objectForKey:@"host"];
  if(prop != nil && [prop isKindOfClass:[NSString class]] && [prop length] > 0)
  {
    host = [NSString stringWithString:prop];
    prop = [cmdProps objectForKey:@"user"];
    if(prop != nil && [prop isKindOfClass:[NSString class]] && [prop length] > 0)
    {
      user = [NSString stringWithFormat:@"%@@",prop];
    }
    else
    {
      user = @"";
    }
    prop = [cmdProps objectForKey:@"init"];
    if(prop != nil && [prop isKindOfClass:[NSString class]] && [prop length] > 0)
    {
      init = [NSString stringWithFormat:@" %@;sh -i",prop];
    }
    else
    {
      init = @"";
    }
    cmd = [NSString stringWithFormat:@"%@%@%@",user,host,init];
  }
  else
  {
    cmd = @"";
  }
  return cmd;
}
@end
