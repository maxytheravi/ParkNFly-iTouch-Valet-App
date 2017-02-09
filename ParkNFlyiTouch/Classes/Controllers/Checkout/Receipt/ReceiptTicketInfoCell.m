//
//  ReceiptTicketInfoCell.m
//  ParkNFly
//
//  Created by Bhavesh on 05/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptTicketInfoCell.h"

@interface ReceiptTicketInfoCell ()
{
    __weak IBOutlet UILabel* lblTicketNumber;
    __weak IBOutlet UILabel* lblParkingType;
    __weak IBOutlet UILabel* lblEntry;
    __weak IBOutlet UILabel* lblExit;
    __weak IBOutlet UILabel* lblPeriod;
}

@end

@implementation ReceiptTicketInfoCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReceiptTicketInfoCell class]) owner:self options:nil] lastObject];
    
    return self;
}

-(void) fillData: (NSDictionary*) data
{
      NSDictionary* dic = [[data objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
    
    NSDictionary* ticketInfo = [dic objectForKey:@"a:ticketInfo"];
    
    lblTicketNumber.text = [self getValue:@"a:Barcode" inDic: ticketInfo];
    lblParkingType.text = [self getValue:@"a:ParkingTypeName" inDic:ticketInfo];
    lblEntry.text = [self getFormatedTime: [self getValue:@"a:FromDate" inDic:ticketInfo]];
    lblExit.text =[self getFormatedTime:  [self getValue:@"a:ToDate" inDic:ticketInfo]];
    
    NSString* day = [self getValue:@"a:_parkedDays" inDic:dic];
    NSString* hr = [self getValue:@"a:_parkedHours" inDic:dic];
    NSString* min = [self getValue:@"a:_parkedMinutes" inDic:dic];
    NSString* per = [NSString stringWithFormat: @"%@D %@H %@M", day,hr,min ];
    lblPeriod.text = per;

}

-(NSString*) getFormatedTime : (NSString*) serverTime
{
    NSArray* token = [serverTime componentsSeparatedByString:@"T"];
    
    NSString* date = [token objectAtIndex:0];
    NSString* time = [[token objectAtIndex:1] substringToIndex:8];
    
    return [NSString stringWithFormat:@"%@ %@", date, time];
}

-(NSString*) getValue :(NSString*) key inDic:(NSDictionary*) dic
{
    return [[dic objectForKey:key]objectForKey:@"innerText"];
}

+(int) getHeight
{
    return 150;
}

@end
