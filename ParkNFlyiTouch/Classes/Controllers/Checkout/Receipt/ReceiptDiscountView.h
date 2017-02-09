//
//  ReceiptTaxView.h
//  ParkNFly
//
//  Created by Bhavesh on 13/10/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptDiscountView : UIView

@property (nonatomic, retain) NSString* discountName;
@property (nonatomic, retain) NSString* appliesTo;
@property (nonatomic, retain) NSString* discountDescr;
@property (nonatomic, retain) NSString* qty;
@property (nonatomic, retain) NSString* discountCost;

-(void) refreshData;

@end
