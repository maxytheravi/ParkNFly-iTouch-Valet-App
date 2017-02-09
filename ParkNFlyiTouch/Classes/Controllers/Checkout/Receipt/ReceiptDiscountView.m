//
//  ReceiptTaxView.m
//  ParkNFly
//
//  Created by Bhavesh on 13/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import "ReceiptDiscountView.h"

@interface ReceiptDiscountView ()
{
    __weak IBOutlet UITextView* discountInfo;
    __weak IBOutlet UILabel* cost;
}

@end

@implementation ReceiptDiscountView

-(id)init
{
    self = [[[NSBundle mainBundle]   loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject ];
        
    return  self;
}

-(NSString*) getFormatedAmount :(NSString*) amt
{
    float value = [amt floatValue];
    
    return [NSString stringWithFormat:@"$%.2f", value ];
}

-(void) refreshData
{
    discountInfo.text =  [NSString stringWithFormat:@"%@ (%@)\n(%@-Qty-%@)", self.discountName, self.appliesTo, self.discountDescr , self.qty];
    [discountInfo setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
    
    cost.text = [NSString stringWithFormat:@"(%@)",[self getFormatedAmount:self.discountCost]];
    [cost setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
}



@end
