//
//  DynamicReceipt.h
//  ParkNFly
//
//  Created by Bhavesh on 05/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MiniPrinterFunctions.h"
//#import "AppDelegate.h"
#import "ReceiptBasicInfoCell.h"
#import "ReceiptTicketInfoCell.h"
#import "ReceiptFeeInfoCell.h"
#import "ReceiptTotalInfoCell.h"
#import "ReceiptTaxInfoCell.h"
#import "ReceiptReservationCell.h"
#import "ReceiptServicesInfoCell.h"

@protocol DynamicReceiptProtocol <NSObject>

@required
-(void) closeTapped;

@end

@interface DynamicReceipt : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<DynamicReceiptProtocol> delegate;

@property (nonatomic, retain) NSDictionary* receiptData;



@end
