//
//  ReceiptReservationCell.m
//  ParkNFly
//
//  Created by Bhavesh on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptReservationCell.h"

@interface ReceiptReservationCell ()
{
    __weak IBOutlet ReceiptReservationContainer* container;
}

@end

@implementation ReceiptReservationCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReceiptReservationCell class]) owner:self options:nil] lastObject];
    
    return self;
}

-(void) fillData: (NSDictionary*) data
{
    NSDictionary* dic = [[data objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
    
    NSArray* resArr = [[[dic objectForKey:@"a:ticketInfo"] objectForKey:@"a:SelectedReservationInTicket"] objectForKey:@"a:Reservations"];
    
    [container createReservationtView:resArr];

}

-(NSString*) getValue :(NSString*) key inDic:(NSDictionary*) dic
{
    return [[dic objectForKey:key]objectForKey:@"innerText"];
}

+(int) getHeight : (int) cnt
{
    
    int interSpacing = 100; //per section height
    
    int incHeight =(int) (interSpacing*cnt);
    
    return incHeight + (cnt > 0 ? 30 : 0 ) + 10;  // reservation title height 30 // 10  top + bottom spacing
    
    
}



@end
