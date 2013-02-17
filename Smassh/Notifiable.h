//
//  Notifiable.h
//  Smassh
//
//  Created by perkee on 11/20/12.
//  Copyright (c) 2012 perkee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Notifiable <NSObject>
typedef enum {
  NotificationNormal,
  NotificationAdded,
  NotificationScript
} notification;
-(void)notify;
-(void)notifyWithType:(NSNumber *) type;
@end
