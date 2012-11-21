//
//  Config.m
//  Smassh
//
//  Created by perkee on 11/19/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import "Config.h"

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
    NSError *error = [[NSError alloc] init];
    
    appName = [[bundle infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    supportDir = paths[0];
    supportDir = [self.supportDir stringByAppendingPathComponent:self.appName];
    
    cfgFile = @"cfg.plist";
    cfgFile = [self.supportDir stringByAppendingPathComponent:self.cfgFile];
    
    NSString *defaultConfigFile = [[NSBundle mainBundle] pathForResource:@"cfg" ofType:@"plist"];
    
    BOOL isDir;
    BOOL fileExists = [fileManager fileExistsAtPath:supportDir isDirectory:&isDir];
    
    if(fileExists && isDir)
    {
      //the support directory exists
      NSLog(@"Exists support dir: %@",supportDir);
      fileExists = [fileManager fileExistsAtPath:cfgFile isDirectory:&isDir];
      if(fileExists && !isDir)
      {
        //config file exists
        NSLog(@"Exists cfg file: %@",cfgFile);
        //don't load it or anything here, we do that after taking care of missing pieces
      }
      else
      {
        //config file does not exist
        NSLog(@"e: %@ d: %@ dir: %@",
              fileExists ? @"Y" : @"N",
              isDir      ? @"Y" : @"N",
              cfgFile
              );
        if(fileExists)//i.e. the config file exists but it's a dir
        {
          //some joker is having a laugh
          //delete it
          [fileManager removeItemAtPath:cfgFile error:&error];
        }
        //make cfg file
        [fileManager copyItemAtPath:defaultConfigFile toPath:cfgFile error:&error];
      }
    }
    else
    {
      NSLog(@"e: %@ d: %@ dir: %@",
            fileExists ? @"Y" : @"N",
            isDir      ? @"Y" : @"N",
            supportDir
            );
      if(fileExists)//i.e. it exists but is not a directory
      {
        //some joker is having a laugh
        //delete it
        [fileManager removeItemAtPath:supportDir error:&error];
      }
      //make dir, make cfg file
      [fileManager createDirectoryAtPath:supportDir withIntermediateDirectories:YES attributes:nil error:&error];
      [fileManager copyItemAtPath:defaultConfigFile toPath:cfgFile error:&error];
    }
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
  [config removeObjectForKey:@"shells"];
  NSLog(@"cleared %@",config);
  return self;
}

-(void)createConfigFile
{
  
}

-(void)createSupportDir
{
  
}

@end
