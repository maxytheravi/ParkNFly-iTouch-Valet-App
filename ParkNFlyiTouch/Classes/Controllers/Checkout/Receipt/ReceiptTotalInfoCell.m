//
//  ReceiptTotalInfoCell.m
//  ParkNFly
//
//  Created by Bhavesh on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptTotalInfoCell.h"

@interface ReceiptTotalInfoCell()
{
    __weak IBOutlet UILabel* lblTotalPrice;
    __weak IBOutlet UILabel* lblCardName;
    __weak IBOutlet UILabel* lblPaymentCharged;
    __weak IBOutlet UILabel* lblCapCardNumber;
    __weak IBOutlet UILabel* lblReceiptFooter;
}

@end

@implementation ReceiptTotalInfoCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReceiptTotalInfoCell class]) owner:self options:nil] lastObject];
    
    return self;
}

-(void) fillData: (NSDictionary*) data
{
    NSDictionary* dic = [[data objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
    
    lblReceiptFooter.text = [self getValue:@"a:_ReceiptFooter" inDic:dic];
    
     NSDictionary* parkingInfo = [dic objectForKey:@"a:parkingCharges"];
    
    lblTotalPrice.text = [self getFormatedAmount: [self getValue:@"a:TotalCharge" inDic:parkingInfo]];
    
    NSDictionary* paymentInfo = [self getPaymentInfoDic:dic];
    NSString *totalamount = [self getFormatedAmount: [self getValue:@"a:TotalCharge" inDic:parkingInfo]];
    
    if ([totalamount isEqual:@"$0.00"]) {
        lblCardName.hidden = YES;
        lblPaymentCharged.hidden = YES;
    }
    
    lblCardName.text = [NSString stringWithFormat:@"%@%@-%@" , [self getValue:@"a:CardType" inDic:paymentInfo] , [self getValue:@"a:CardLastFour" inDic:paymentInfo], [self getValue:@"a:AuthCode" inDic:paymentInfo]];
    
    lblPaymentCharged.text = [self getFormatedAmount:[self getValue:@"a:TotalCharge" inDic:paymentInfo]];
    
    NSString* cardNum = [self getValue:@"a:_CardNumber" inDic:dic];
    
    if (!cardNum)
        cardNum =[self getValue:@"a:_x003C_CardNumber_x003E_k__BackingField" inDic:dic];// in some cases we get this key for card type
    
    NSString* cardType = [self getValue:@"a:_CardType" inDic:dic];
    
    if(!cardType)
        cardType = [self getValue:@"a:_x003C_CardType_x003E_k__BackingField" inDic:dic];// in some cases we get this key for catd number
    
    if(cardType && cardNum)
        lblCapCardNumber.text = [NSString stringWithFormat:@"%@# %@" ,cardType, cardNum];
    
    else
        lblCapCardNumber.hidden = YES;

}

-(NSDictionary*) getPaymentInfoDic : (NSDictionary*) dataDic
{
    
    NSArray* payArr = [[[dataDic objectForKey:@"a:paymentOption"] objectForKey:@"a:CreditPaymentList"] objectForKey:@"a:PaymentCreditInformation"];
    
    NSDictionary* payInfoDic;
    
    for (NSDictionary* dic in payArr) {
        
        if([self getValue:@"a:AmountCharged" inDic:dic] != nil)
        {
            payInfoDic = dic;
            break;
        }
    }
    
    return payInfoDic;
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

+(int) getHeight
{
    return 255;
}


@end
