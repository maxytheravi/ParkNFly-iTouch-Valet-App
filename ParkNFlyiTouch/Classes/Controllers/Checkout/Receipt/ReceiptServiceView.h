//
//  ReceiptServiceView.h
//  ParkNFly
//
//  Created by Bhavesh on 14/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptServiceView : UIView

@property (nonatomic, retain) NSString* serName;
@property (nonatomic, retain) NSString* serviceCost;

-(void) refreshData;

@end
