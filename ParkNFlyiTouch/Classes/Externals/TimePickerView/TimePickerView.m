//
//  TimePickerView.m
//  PNF-Consumer
//
//  Created by Bhavesh on 02/12/14.
//  Copyright (c) 2014 PNF. All rights reserved.
//

#import "TimePickerView.h"
#import "GCSValet-Swift.h"

@interface TimePickerView ()
{
    __weak IBOutlet UICollectionView* timeCV;
    __weak IBOutlet UITableView* durationTable;
    __weak IBOutlet UIButton *doneBtn;
    __weak IBOutlet UIView* topView;
    
    int selTime;
    int selectedDuration;
    int selectedState;
    
    BOOL isManual;
}

@end

@implementation TimePickerView

-(id) init
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])  owner:self options:nil] lastObject ];
    
    [timeCV registerClass:[TimeCell class] forCellWithReuseIdentifier:@"TimeCell"];
    
    timeCV.layer.borderColor = [UIColor grayColor].CGColor;
    timeCV.layer.borderWidth = 1;
    
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1;
    
    [durationTable registerClass:[DurationCell class] forCellReuseIdentifier:@"DurationCell"];
    
//    selTime = 1; //smita
    selTime = 0;
    selectedDuration = 0;
    selectedState = 0;
    
    doneBtn.layer.cornerRadius = 5.0f;
//    self.layer.cornerRadius = 15;
    
    return self;
}

- (void)updatePredefinedTime
{
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:self.selectedTime];
    selTime = (int)[comps hour];
    if (selTime > 12) {
        selTime -= 12;
        selectedState = 12;
    } else {
        selectedState = 0;
    }
    selectedDuration = (int)[comps minute];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        TimeCell *timeCell = (TimeCell *)[timeCV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(selTime - 1) inSection:0]];
        timeCell.time = [NSString stringWithFormat:@"%d",selTime];
        [timeCell setSelected:YES];
        isManual = TRUE;
        [self collectionView:timeCV didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:(selTime - 1) inSection:0]];
        isManual = FALSE;
        
        DurationCell *durationCell = [durationTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(selectedDuration == 0 ? 0 : 1) inSection:0]];
        [durationCell setSelected:YES animated:NO];
        [self tableView:durationTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(selectedDuration == 0 ? 0 : 1) inSection:0]];
        
        DurationCell *durationCell2 = [durationTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(selectedState == 0 ? 0 : 1) inSection:1]];
        [durationCell2 setSelected:YES animated:NO];
        [self tableView:durationTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:(selectedState == 0 ? 0 : 1) inSection:1]];
    });
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TimeCell* tc = [collectionView dequeueReusableCellWithReuseIdentifier:@"TimeCell" forIndexPath:indexPath];
    
    tc.time = [NSString stringWithFormat:@"%d" ,(int)(indexPath.item + 1)];
    
    return tc;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DurationCell* dc = [tableView dequeueReusableCellWithIdentifier:@"DurationCell" forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0:
//            dc.duration = indexPath.section == 0 ? @"AM" : @"00";
             dc.duration = indexPath.section == 0 ? @"00" : @"AM";
            break;
            
        case 1:
//            dc.duration = indexPath.section == 0 ? @"PM" : @"30";
            dc.duration = indexPath.section == 0 ? @"30" : @"PM";

            break;
            
        default:
            break;
    }
    
  dc.showBorder = indexPath.item == 1 && indexPath.section == 0 ;
    
    return dc;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isManual && selTime > 0) {
        TimeCell *timeCell = (TimeCell *)[timeCV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(selTime - 1) inSection:0]];
        [timeCell setSelected:NO];
    }
    
    selTime =(int) indexPath.item +1;
    
    [self updateSelectedTime];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   UITableViewCell* cell= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item == 0 ? 1 : 0  inSection:indexPath.section]];
    
    [cell setSelected:NO];
    
    DurationCell* dc= (DurationCell*) [tableView cellForRowAtIndexPath:indexPath];
    
//    if(indexPath.section == 0)
    if(indexPath.section == 1)

        selectedState = [dc.duration isEqualToString:@"AM"] ? 0 : 12;
    
    else
        selectedDuration = [dc.duration isEqualToString:@"00"] ? 0 : 30;
    
    [self updateSelectedTime];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DurationCell* dc= (DurationCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    [dc setSelected:YES];
}

-(void) updateSelectedTime
{
    NSDateComponents* dc = [[NSCalendar currentCalendar] components: NSCalendarUnitHour | NSCalendarUnitMinute  fromDate:[NSDate date]];

    int hrs;
    
    if(selTime ==12)
        hrs = selectedState ;
    
    else
        hrs = selTime + selectedState;
    
    [dc setHour:hrs ];
    [dc setMinute:selectedDuration];
    [dc setSecond:0];
    
    self.selectedTime = [[NSCalendar currentCalendar]dateFromComponents:dc];
}

-(IBAction)onDoneTapped:(id)sender
{
    if(!self.selectedTime || selTime == 0)
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select time" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    
    else
    {
        [self removeFromSuperview];
        
        if(self.onDoneTapped)
            self.onDoneTapped();
    }
    
}
- (IBAction)onCancelTapped:(id)sender {
    [self removeFromSuperview];
    if(self.onCancelTapped)
        self.onCancelTapped();
    
}

@end
