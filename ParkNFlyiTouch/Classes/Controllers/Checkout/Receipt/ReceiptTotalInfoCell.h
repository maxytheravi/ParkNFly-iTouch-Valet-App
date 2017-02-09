//
//  ReceiptTotalInfoCell.h
//  ParkNFly
//
//  Created by Bhavesh on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptTotalInfoCell : UITableViewCell


-(void) fillData: (NSDictionary*) data;

+(int) getHeight;

@end
