//
//  TimePickerView.h
//  PNF-Consumer
//
//  Created by Bhavesh on 02/12/14.
//  Copyright (c) 2014 PNF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeCell.h"
#import "DurationCell.h"

@interface TimePickerView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain) NSDate* selectedTime;
- (void)updatePredefinedTime;

@property(nonatomic, copy)  void(^onDoneTapped)(void);
@property(nonatomic, copy)  void(^onCancelTapped)(void);

@end
