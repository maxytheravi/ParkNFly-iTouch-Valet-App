//
//  ReceiptServicesInfoCell.m
//  ParkNFly
//
//  Created by Smita on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptServicesInfoCell.h"

@implementation ReceiptServicesInfoCell{
    
    __weak IBOutlet ReceiptServiceContainer *container;
    
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReceiptServicesInfoCell class]) owner:self options:nil] lastObject];
    
    return self;
}

-(NSString*) getValue :(NSString*) key inDic:(NSDictionary*) dic
{
    return [[dic objectForKey:key]objectForKey:@"innerText"];
}

-(void) fillData: (NSDictionary*) data
{
    NSDictionary* dic = [[data objectForKey:@"GetPaymentReceiptResponse"] objectForKey:@"GetPaymentReceiptResult"];
    
    NSArray* servicesArr = [[dic objectForKey:@"a:selectedServices"] objectForKey:@"a:AddService"];
    
    [container createServiceView:servicesArr];
    
}

+(int) getHeight : (int) cnt
{
    
    int interSpacing = 45; //per section height
    
    int incHeight =(int) (interSpacing*cnt);
    
    return incHeight  + (cnt > 0 ? 30 : 0 ) + 10; // Service title height 30 // 10  top + bottom spacing
    
    
}

@end
