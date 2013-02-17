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

#define VERBOSE YES

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
                    self.nick,@"nick",
                    @"",      @"user",
                    @"",      @"host",
                    @"",      @"init",
                    @"",      @"port",
                    nil];
    }
  }
  return self;
}

-(NSString *) cmd
{
  return [ShellShortcut buildCommand:self.props];
}

-(NSDictionary *) toDictionary
{
  NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:props];
  [temp setObject:nick forKey:@"nick"];
  return temp;
}

+(NSString *) buildCommand:(NSDictionary *)cmdProps
{
  NSString *port = @"",
           *user = @"",
           *host,
           *init = @"",
           *cmd = @"#If you don't provide a host there is no command";
  
  id prop = [cmdProps objectForKey:@"host"];
  if(prop != nil && [prop isKindOfClass:[NSString class]] && [prop length] > 0)
  {
    host = [NSString stringWithString:prop];
    prop = [cmdProps objectForKey:@"user"];
    if(prop != nil && [prop isKindOfClass:[NSString class]] && [prop length] > 0)
    {
      user = [NSString stringWithFormat:@"%@@",prop];
    }
    prop = [cmdProps objectForKey:@"init"];
    if(prop != nil && [prop isKindOfClass:[NSString class]] && [prop length] > 0)
    {
      init = [NSString stringWithFormat:@" '%@;bash -il'",prop];
    }
    prop = [cmdProps objectForKey:@"port"];
    if(prop != nil && [prop isKindOfClass:[NSString class]] && [prop length] > 0)
    {
      port = [NSString stringWithFormat:@" -p %@ ", prop];
    }
    cmd = [NSString stringWithFormat:@"%@%@%@%@",port,user,host,init];
  }
  return cmd;
}
@end
