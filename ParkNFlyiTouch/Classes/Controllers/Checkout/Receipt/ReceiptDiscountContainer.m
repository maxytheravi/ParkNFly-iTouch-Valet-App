//
//  ReceiptDiscountContainer.m
//  ParkNFly
//
//  Created by Bhavesh on 14/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import "ReceiptDiscountContainer.h"

@implementation ReceiptDiscountContainer

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

-(int) createDiscountView : (NSArray*) discountArray
{
    
    UILabel* title = [[UILabel alloc]init];
    title.text = @"Discount";
    title.frame = CGRectMake(34, 10, 100, 21);
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    title.adjustsFontSizeToFitWidth = TRUE;
    title.minimumScaleFactor = 12;
    
    [self addSubview:title];
    
    if(discountArray.count ==0)
    {
        self.hidden= YES;
        return 0;
    }
    
    self.hidden = NO;
    
    if([discountArray isKindOfClass:[NSDictionary class]])
    {
        //only one discount
        //need to create array containing this one discount
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        
        [arr addObject:discountArray];
        
        discountArray = arr;
    }

    int x = 34;
    int y =30;
    int interSpacing = 60;
    int incHeight =(int) (interSpacing*discountArray.count);
    CGRect frame = self.frame;
    frame.size.height = incHeight + y;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    self.frame = frame;
    
    for (NSDictionary* data in discountArray) {
        
        ReceiptDiscountView* rdv = [[ReceiptDiscountView alloc]init];
        
        rdv.discountName = [self getValue:@"a:DiscountName" inDic:data];
        rdv.appliesTo = [self getValue:@"a:DiscountApplyTo" inDic:data];
        rdv.qty = [self getValue:@"a:Quantity" inDic:data];
        rdv.discountDescr = [self getValue:@"a:DiscountDesc" inDic:data];
        rdv.discountCost = [self getValue:@"a:TotalDiscount" inDic:data];
        
        [rdv refreshData];
        
        CGRect frame = rdv.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        frame.size.width = [UIScreen mainScreen].bounds.size.width - x;
        rdv.frame = frame;
        
        [self addSubview:rdv];
        
        y +=interSpacing;
    }
    return incHeight;
}

@end
