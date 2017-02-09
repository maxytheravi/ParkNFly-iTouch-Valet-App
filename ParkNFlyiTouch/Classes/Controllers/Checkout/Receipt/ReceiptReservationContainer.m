//
//  ReceiptReservationContainer.m
//  ParkNFly
//
//  Created by Bhavesh on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptReservationContainer.h"

@implementation ReceiptReservationContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(NSString*) getValue :(NSString*) key inDic:(NSDictionary*) dic
{
    return [[dic objectForKey:key]objectForKey:@"innerText"];
}

-(int) createReservationtView : (NSArray*) reservationArray;
{
    
    UILabel* title = [[UILabel alloc]init];
    title.text = @"Reservation(s) applied";
    title.frame = CGRectMake(12, 2, 450, 21);
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19];
    title.adjustsFontSizeToFitWidth = TRUE;
    title.minimumScaleFactor = 12;
    
    [self addSubview:title];
    
    if(reservationArray.count ==0)
    {
        self.hidden= YES;
        return 0;
    }
    
    self.hidden = NO;
    
    if([reservationArray isKindOfClass:[NSDictionary class]])
    {
        //only one reservation
        //need to create array containing this one reservation
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        
        [arr addObject:reservationArray];
        
        reservationArray = arr;
    }
    
    int x = 34;
    int y =30;
    int interSpacing = 100;
    int incHeight =(int) (interSpacing*reservationArray.count);
    CGRect frame = self.frame;
    frame.size.height = incHeight + y;
    self.frame = frame;
    
    for (NSDictionary* data in reservationArray) {
        
        ReceiptReservationView* rrv = [[ReceiptReservationView alloc]init];
        
        NSString* start = [self getFormatedTime:[self getValue:@"a:From" inDic:data]];
        NSString* end = [self getFormatedTime:[self getValue:@"a:To" inDic:data]];
        
        rrv.reservationName = [NSString  stringWithFormat:@"%@ %@",[self getValue:@"a:ReservationCode" inDic:data], [self getValue:@"a:ParkingTypeName" inDic:data]];
        rrv.startDate = start;
        rrv.endDate = end;
        rrv.duration = [self getParkingDuration:start To:end];
        
        [rrv refreshData];
        
        CGRect frame = rrv.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        rrv.frame = frame;
        
        [self addSubview:rrv];
        
        y +=interSpacing;
    }
    return incHeight;
}

-(NSString*) getParkingDuration :(NSString*) fromDateStr To:(NSString*) toDateStr;
{
    //2014-09-11T16:01:11.683 >> = format of server
    NSRange tRange =[fromDateStr rangeOfString:@"T" ];
    
    if(tRange.length)
        fromDateStr = [fromDateStr stringByReplacingCharactersInRange:tRange withString:@" "];
    
    fromDateStr = [fromDateStr substringToIndex:19];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* fromDate = [df dateFromString:fromDateStr];
    
    tRange =[toDateStr rangeOfString:@"T" ];
    
    if(tRange.length)
        toDateStr = [toDateStr stringByReplacingCharactersInRange:tRange withString:@" "];
    
    toDateStr = [toDateStr substringToIndex:19];
    
    NSDate* toDate = [df dateFromString:toDateStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    int year = (int)[components year];
    int month = (int)[components month];
    int day = (int)[components day];
    int hour = (int)[components hour];
    int min = (int)[components minute];
    
    NSString* duration ;
    
    if(year > 0)
        duration = [NSString stringWithFormat:@"(%dYear(s), %dMonth(s), %dDay(s), %dHour(s), %dMinute(s))", year,month,day,hour,min];
    
    else if(month > 0)
        duration = [NSString stringWithFormat:@"(%dMonth(s), %dDay(s), %dHour(s), %dMinute(s))",month,day,hour,min];
    
    else if(day >0)
        duration = [NSString stringWithFormat:@"(%dDay(s), %dHour(s), %dMinute(s))",day,hour,min];
    
    else if(hour >0)
        duration = [NSString stringWithFormat:@"(%dHour(s), %dMinute(s))",hour,min];
    
    else
        duration = [NSString stringWithFormat:@"(%dMinute(s))",min];
    
    return duration;
}

-(NSString*) getFormatedTime : (NSString*) serverTime
{
    NSArray* token = [serverTime componentsSeparatedByString:@"T"];
    
    NSString* date = [token objectAtIndex:0];
    NSString* time = [[token objectAtIndex:1] substringToIndex:8];
    
    return [NSString stringWithFormat:@"%@ %@", date, time];
    
}


@end
