//
//  ReceiptReservationView.m
//  ParkNFly
//
//  Created by Bhavesh on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "ReceiptReservationView.h"

@interface ReceiptReservationView ()
{
    __weak IBOutlet UILabel* lblreservationName;
    __weak IBOutlet UILabel* lblStartDate;
    __weak IBOutlet UILabel* lblEndDate;
    __weak IBOutlet UILabel* lblDuration;
}

@end

@implementation ReceiptReservationView

-(id)init
{
    self = [[[NSBundle mainBundle]   loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject ];
    
    return  self;
}



-(void) refreshData
{
    lblreservationName.text = self.reservationName;
    [lblreservationName setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];

    lblStartDate.text = self.startDate;
    [lblStartDate setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];

    lblEndDate.text = self.endDate;
    [lblEndDate setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];

    lblDuration.text = self.duration;
    [lblDuration setFont:[UIFont fontWithName:@"Helvetica Neue" size:19]];

}

@end
