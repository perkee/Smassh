//
//  Config.m
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "Config.h"
#define VERBOSE NO

@implementation Config

@synthesize appName;
@synthesize supportDir;
@synthesize cfgFile;

@synthesize config;

@synthesize shells;

-(id)init
{
  if(self = [super init])
  {
    NSBundle *bundle = [NSBundle mainBundle];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error = nil;
    
    appName = [[bundle infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    supportDir = [paths[0] stringByExpandingTildeInPath];
    supportDir = [self.supportDir stringByAppendingPathComponent:self.appName];
    
    cfgFile = @"cfg.plist";
    cfgFile = [self.supportDir stringByAppendingPathComponent:self.cfgFile];
    
    NSString *defaultConfigFile = [[NSBundle mainBundle] pathForResource:@"cfg" ofType:@"plist"];
    
    BOOL isDir;
    BOOL fileExists = [fileManager fileExistsAtPath:supportDir isDirectory:&isDir];
    
    if(!fileExists || !isDir)
    {
      //support directory does not exist
      if(fileExists)
      {
        //i.e. it exists but is not a directory
        [fileManager removeItemAtPath:supportDir error:&error];
      }
      [fileManager createDirectoryAtPath:supportDir withIntermediateDirectories:YES attributes:nil error:&error];
    }
    fileExists = [fileManager fileExistsAtPath:cfgFile isDirectory:&isDir];
    if(!fileExists || isDir)
    {
      //config file does not exist
      if(isDir)
      {
        //i.e. it exists but is a directory
        [fileManager removeItemAtPath:cfgFile error:&error];
      }
      [fileManager copyItemAtPath:defaultConfigFile toPath:cfgFile error:&error];
    }
    //load it as a dictionary
    config = [NSMutableDictionary dictionaryWithContentsOfFile:cfgFile];
    shells = [NSMutableArray arrayWithCapacity:[[config objectForKey:@"shells"] count]];
    [shells addObjectsFromArray:[config objectForKey:@"shells"]];
    for(NSUInteger ii = 0; ii < [shells count]; ii++)
    {
      //replace each Dictionary with a ShellShortcut
      [shells replaceObjectAtIndex:ii withObject:[[ShellShortcut alloc] initWithProps:[shells objectAtIndex:ii]]];
    }
  }
  if(VERBOSE)
  {
    NSLog(@"Config: %@",config);
  }
  return self;
}

-(NSMutableArray *)dictFromShells:(NSArray *)someShells
{
  NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[someShells count]];
  for(id shell in someShells)
  {
    [temp addObject:[shell toDictionary]];
  }
  return temp;
}

-(void)notify
{
  [config setObject:[self dictFromShells:shells] forKey:@"shells"];
  BOOL couldWrite = [config writeToFile:cfgFile atomically:YES];
  if(VERBOSE)
  {
    NSLog(@"%@ to config file", couldWrite ? @"Wrote" : @"Didn't write");
  }
}
-(void)notifyWithType:(NSNumber *)type
{
  if([type integerValue] == NotificationAdded)
  {
    [config setObject:[self dictFromShells:shells] forKey:@"shells"];
    //Don't write to disk just yet—the content is guaranteed to be uninteresting
  }
  else if([type integerValue] == NotificationScript)
  {
    BOOL couldWrite = [config writeToFile:cfgFile atomically:YES];
    if(VERBOSE)
    {
      NSLog(@"New applescript:\n%@",[config objectForKey:@"script"]);
      NSLog(@"%@ to config file", couldWrite ? @"Wrote" : @"Didn't write");
    }
  }
  else
  {
    [self notify];
  }
}

@end
