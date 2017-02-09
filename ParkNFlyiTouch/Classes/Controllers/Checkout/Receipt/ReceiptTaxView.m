//
//  ReceiptTaxView.m
//  ParkNFly
//
//  Created by Bhavesh on 14/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import "ReceiptTaxView.h"

@interface ReceiptTaxView ()
{
    __weak IBOutlet UITextView* info;
    __weak IBOutlet UILabel* taxCost;

}

@end


@implementation ReceiptTaxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle]   loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject ];
    
    return  self;
}

-(void) setCost:(NSString *)serviceCost
{
    float cst = [serviceCost floatValue];
    
    _cost= [NSString stringWithFormat:@"%.2f", cst];
}

-(void) refreshData
{
    info.text =  [NSString stringWithFormat:@"%@ %@ \n (%@)", self.taxName,  self.taxDescr, self.appliesTo];
    [info setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];

    
    taxCost.text = [NSString stringWithFormat:@"$%@", self.cost];
    [taxCost setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];

}


@end
