//
//  ReceiptFeeInfoCell.h
//  ParkNFly
//
//  Created by Bhavesh on 05/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptDiscountContainer.h"

@interface ReceiptFeeInfoCell : UITableViewCell

-(void) fillData: (NSDictionary*) data;

+(int) getHeight : (int) cnt;


@end
