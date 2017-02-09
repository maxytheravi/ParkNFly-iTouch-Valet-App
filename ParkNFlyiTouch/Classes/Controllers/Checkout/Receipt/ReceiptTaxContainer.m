//
//  ReceiptTaxcontainer.m
//  ParkNFly
//
//  Created by Bhavesh on 14/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import "ReceiptTaxContainer.h"

@implementation ReceiptTaxContainer

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

-(int) createTaxView:(NSArray*) taxArray
{
    
    if(taxArray.count ==0)
    {
        self.hidden= YES;
        return 0;
    }
    
    self.hidden = NO;
    
    if([taxArray isKindOfClass:[NSDictionary class]])
    {
        //only one tax
        //need to create array containing this one tax
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        
        [arr addObject:taxArray];
        
        taxArray = arr;
    }
    
    int x = 34;
    int y =0;
    int interSpacing = 45;
    int incHeight =(int) (interSpacing*taxArray.count);
    CGRect frame = self.frame;
    frame.size.height = incHeight + y;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    self.frame = frame;
    
    
    for (NSDictionary* data in taxArray) {
        
        ReceiptTaxView* rtv = [[ReceiptTaxView alloc]init];
        
        rtv.taxName = [self getValue:@"a:TaxName" inDic:data];
        rtv.appliesTo = [self getValue:@"a:TaxAppliesTo" inDic:data];
        rtv.taxDescr = [self getValue:@"a:TaxDescription" inDic:data];
        rtv.cost = [self getValue:@"a:TaxValue" inDic:data];
        
        [rtv refreshData];
        
        CGRect frame = rtv.frame;
        frame.origin.x = x;
        frame.origin.y = y;
        frame.size.width = [UIScreen mainScreen].bounds.size.width - x;
        rtv.frame = frame;
        
        [self addSubview:rtv];
        
        y +=interSpacing;
    }
    return incHeight;
}

@end
