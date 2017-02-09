//
//  ObjectiveCCommonMethods.h
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 07/12/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DSLCalendarView;
@interface ObjectiveCCommonMethods : NSObject

+ (NSString*)base64forData:(NSData*)theData;
+ (NSData *)base64DataFromString: (NSString *)string;
+ (NSDateComponents *)setVisibleMonthForDSLCalendar:(DSLCalendarView *)dslCalendar withDate:(NSDate *)date;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
