//
//  ReceiptReservationView.h
//  ParkNFly
//
//  Created by Bhavesh on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptReservationView : UIView

@property (nonatomic,retain) NSString* reservationName;
@property (nonatomic,retain) NSString* startDate;
@property (nonatomic,retain) NSString* endDate;
@property (nonatomic,retain) NSString* duration;

-(void) refreshData;

@end
