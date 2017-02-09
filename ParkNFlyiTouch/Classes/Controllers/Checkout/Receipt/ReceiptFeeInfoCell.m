//
//  ReceiptFeeInfoCell.m
//  ParkNFly
//
//  Created by Bhavesh on 05/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptFeeInfoCell.h"

@interface ReceiptFeeInfoCell ()
{
    __weak IBOutlet UILabel* lblParkingCost;
    __weak IBOutlet ReceiptDiscountContainer* container;
}

@end

@implementation ReceiptFeeInfoCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReceiptFeeInfoCell class]) owner:self options:nil] lastObject];
    
    return self;
}

-(void) fillData: (NSDictionary*) data
{
     NSDictionary* dic = [[data objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
    
    NSDictionary* parkingInfo = [dic objectForKey:@"a:parkingCharges"];
    
    lblParkingCost.text = [self getFormatedAmount: [self getValue:@"a:ParkingCharge" inDic:parkingInfo]];
    
    NSArray* discountArr = [[[dic objectForKey:@"a:ticketInfo"] objectForKey:@"a:Discounts"] objectForKey:@"a:DiscountInfo"];
    
    [container createDiscountView:discountArr];
    
}

-(NSString*) getFormatedAmount :(NSString*) amt
{
    float value = [amt floatValue];
    
    return [NSString stringWithFormat:@"$%.2f", value ];
}

-(NSString*) getValue :(NSString*) key inDic:(NSDictionary*) dic
{
    return [[dic objectForKey:key]objectForKey:@"innerText"];
}

+(int) getHeight : (int) cnt
{
   
    int interSpacing = 60; //per section height
    
    int incHeight =(int) (interSpacing*cnt);
  
    return incHeight + 25 + (cnt > 0 ? 30 : 0 ) + 10; //parking fee height is 25 // discount title height 30 // 10  top + bottom spacing
    
 
}


@end
