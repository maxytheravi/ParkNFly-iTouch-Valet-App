//
//  ReceiptTaxInfoCell.m
//  ParkNFly
//
//  Created by Bhavesh on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptTaxInfoCell.h"

@interface ReceiptTaxInfoCell ()
{
    __weak IBOutlet UILabel* lblSubTotalCharge;
    __weak IBOutlet ReceiptTaxContainer* container;
}

@end

@implementation ReceiptTaxInfoCell


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReceiptTaxInfoCell class]) owner:self options:nil] lastObject];
    
    return self;
}

-(void) fillData: (NSDictionary*) data
{
    NSDictionary* dic = [[data objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];

    NSDictionary* parkingInfo = [dic objectForKey:@"a:parkingCharges"];
    NSArray* taxArr  = [[parkingInfo objectForKey:@"a:TaxInfoList"] objectForKey:@"a:TaxInfo"];
    
    lblSubTotalCharge.text = [self getSubTotal : dic];
    
    [container createTaxView:taxArr];

}

-(NSString*) getSubTotal : (NSDictionary*) dic
{
    
    NSDictionary* parkingInfo = [dic objectForKey:@"a:parkingCharges"];
    
    
    float totalAmt =   [[self getValue:@"a:TotalCharge" inDic:parkingInfo] floatValue];
    
    NSArray* taxArray  = [[parkingInfo objectForKey:@"a:TaxInfoList"] objectForKey:@"a:TaxInfo"];
    
    float tax = 0;
    
    if([taxArray isKindOfClass:[NSDictionary class]])
    {
        //only one discount
        //need to create array containing this one discount
        
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        
        [arr addObject:taxArray];
        
        taxArray = arr;
    }
    
    for (NSDictionary* taxDic in taxArray) {
        
        tax += [[self getValue:@"a:TaxValue" inDic:taxDic] floatValue];
    }
    
    return [self getFormatedAmount:[NSString stringWithFormat:@"%f", totalAmt - tax]];
    
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

    int interSpacing = 45; //per section height
    
    int incHeight =(int) (interSpacing*cnt);
    
    return incHeight + 25 + 10; //subtotal fee height is 25 // 10  top + bottom spacing
}


@end
