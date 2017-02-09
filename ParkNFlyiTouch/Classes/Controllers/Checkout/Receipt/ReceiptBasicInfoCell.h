//
//  ReceiptBasicInfoCell.h
//  ParkNFly
//
//  Created by Bhavesh on 05/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptBasicInfoCell : UITableViewCell

-(void) fillData: (NSDictionary*) data;

+(int) getHeight;


@end
