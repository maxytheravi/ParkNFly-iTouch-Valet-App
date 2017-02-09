//
//  ReceiptServiceContainer.m
//  ParkNFly
//
//  Created by Bhavesh on 14/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import "ReceiptServiceContainer.h"

@implementation ReceiptServiceContainer

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

-(int) createServiceView : (NSArray*) servicesArray
{
    
    UILabel* title = [[UILabel alloc]init];
    title.text = @"Services";
    title.frame = CGRectMake(34, 10, 100, 21);
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    title.adjustsFontSizeToFitWidth = TRUE;
    title.minimumScaleFactor = 12;
    
    [self addSubview:title];
    

    if(servicesArray.count ==0)
    {
        self.hidden= YES;
        return 0;
    }
    
    self.hidden = NO;
    
    if([servicesArray isKindOfClass:[NSDictionary class]])
    {
        //only one service
        //need to create array containing this one service
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        
        [arr addObject:servicesArray];
        
        servicesArray = arr;
    }
    
    int x = 34;
    int y =30;
    int interSpacing = 45;
    int incHeight =(int) (interSpacing*servicesArray.count);
    CGRect frame = self.frame;
    frame.size.height = incHeight + y;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    self.frame = frame;

    for (NSDictionary* data in servicesArray) {
        
        ReceiptServiceView* rsv = [[ReceiptServiceView alloc]init];
        
        rsv.serName = [self getValue:@"a:ServiceName" inDic:data];
        rsv.serviceCost = [self getValue:@"a:TotalServiceCharge" inDic:data];
        
       [rsv refreshData];
        
        CGRect frame = rsv.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        frame.size.width = [UIScreen mainScreen].bounds.size.width - x;
        rsv.frame = frame;
        
        [self addSubview:rsv];
        
        y +=interSpacing;
    }
    return incHeight;
}

@end
