//
//  ReceiptServiceView.m
//  ParkNFly
//
//  Created by Bhavesh on 14/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import "ReceiptServiceView.h"

@interface ReceiptServiceView ()
{
    __weak IBOutlet UILabel* cost;
    __weak IBOutlet UITextView* serviceName;
}

@end

@implementation ReceiptServiceView

-(id)init
{
    self = [[[NSBundle mainBundle]   loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject ];
    
    return  self;
}

-(void) setServiceCost:(NSString *)serviceCost
{
    float cst = [serviceCost floatValue];
    
    _serviceCost= [NSString stringWithFormat:@"%.2f", cst];
}

-(void) refreshData
{

    cost.text = [NSString stringWithFormat:@"$%@", self.serviceCost];
    [cost setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];

    
    serviceName.text = self.serName;
    [serviceName setFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];

}



@end
