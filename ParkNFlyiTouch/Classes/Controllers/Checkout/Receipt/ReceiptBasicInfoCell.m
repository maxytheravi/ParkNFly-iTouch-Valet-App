//
//  ReceiptBasicInfoCell.m
//  ParkNFly
//
//  Created by Bhavesh on 05/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptBasicInfoCell.h"

@interface ReceiptBasicInfoCell ()
{
    __weak IBOutlet UILabel* lblTicketTitle;
    __weak IBOutlet UITextView* ticketAddress;
    __weak IBOutlet UILabel* lblReceiptNumber;
    __weak IBOutlet UILabel* lblReceiptDateTime;
    __weak IBOutlet UILabel* lblChasherName;
    __weak IBOutlet UILabel* lblDeviceName;
    __weak IBOutlet UILabel* lblShiftCode;
    
    
}

@end

@implementation ReceiptBasicInfoCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReceiptBasicInfoCell class]) owner:self options:nil] lastObject];
    
    return self;
}

-(void) fillData: (NSDictionary*) data
{
    lblTicketTitle.text = [data objectForKey:@"facilityName"];
    
    ticketAddress.text =[NSString stringWithFormat:@"%@\n%@", [data objectForKey:@"address"], [data objectForKey:@"phone"]];
    [ticketAddress setFont:[UIFont fontWithName:@"Helvetica Neue" size:21]];

    
    NSDictionary* dic = [[data objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
    
    lblReceiptNumber.text = [self getValue:@"a:_PaymentReceiptNumber" inDic:dic];
    lblReceiptDateTime.text = [self getValue:@"a:_ReceiptDateTime" inDic:dic];
    lblChasherName.text = [data objectForKey:@"cashierName"];
    lblDeviceName.text = [self getValue:@"a:_DeviceName" inDic:dic];
    lblShiftCode.text = [data objectForKey:@"shiftCode"];
}

-(NSString*) getValue :(NSString*) key inDic:(NSDictionary*) dic
{
    return [[dic objectForKey:key]objectForKey:@"innerText"];
}

+(int) getHeight
{
    return 250;
}

@end
