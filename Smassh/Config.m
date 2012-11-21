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

@synthesize fileManager;

@synthesize shells;

-(id)init
{
  if(self = [super init])
  {
    appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    supportDir = paths[0];
    supportDir = [self.supportDir stringByAppendingPathComponent:self.appName];
    
    cfgFile = @"cfg.plist";
    cfgFile = [self.supportDir stringByAppendingPathComponent:self.cfgFile];
    
    fileManager =[NSFileManager defaultManager];
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
        //load it as a dictionary
        config = [NSMutableDictionary dictionaryWithContentsOfFile:cfgFile];
        //shells = [NSMutableArray arrayWithContentsOfFile:cfgFile];
        shells = [NSMutableArray arrayWithCapacity:[[config objectForKey:@"shells"] count]];
        [shells addObjectsFromArray:[config objectForKey:@"shells"]];
        for(NSUInteger ii = 0; ii < [shells count]; ii++)
        {
          //replace each Dictionary with a ShellShortcut
          [shells replaceObjectAtIndex:ii withObject:[[ShellShortcut alloc] initWithProps:[shells objectAtIndex:ii]]];
        }
        [config removeObjectForKey:@"shells"];
        NSLog(@"cleared %@",config);
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
        }
        //make cfg file
        //make empty shells array
        shells = [NSMutableArray array];
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
      }
      //make dir, make cfg file
      //make empty shells array
      shells = [NSMutableArray array];
    }
  }
  return self;
}

-(void)createConfigFile
{
  
}

-(void)createSupportDir
{
  
}

-(void)printPath
{
  NSLog(@"path: %@",cfgFile);
  //[self printShells];
}

@end
