//
//  ReceiptTaxView.h
//  ParkNFly
//
//  Created by Bhavesh on 14/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptTaxView : UIView

@property (nonatomic, retain) NSString* taxName;
@property (nonatomic, retain) NSString* appliesTo;
@property (nonatomic, retain) NSString* taxDescr;
@property (nonatomic, retain) NSString* cost;

-(void) refreshData;

@end
