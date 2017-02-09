//
//  ReceiptServicesInfoCell.h
//  ParkNFly
//
//  Created by Smita on 09/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptServiceContainer.h"

@interface ReceiptServicesInfoCell : UITableViewCell

-(void) fillData: (NSDictionary*) data;

+(int) getHeight : (int) cnt;

@end
