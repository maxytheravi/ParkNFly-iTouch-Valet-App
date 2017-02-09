//
//  ReceiptTaxInfoCell.h
//  ParkNFly
//
//  Created by Bhavesh on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptTaxContainer.h"

@interface ReceiptTaxInfoCell : UITableViewCell

-(void) fillData: (NSDictionary*) data;

+(int) getHeight : (int) cnt;

@end
