//
//  TimeCell.m
//  PNF-Consumer
//
//  Created by Bhavesh on 01/12/14.
//  Copyright (c) 2014 PNF. All rights reserved.
//

#import "TimeCell.h"

@interface TimeCell ()
{
    __weak IBOutlet UILabel* lblTime;
    

}

@end

@implementation TimeCell

-(void)awakeFromNib {
   
    [super awakeFromNib];
    
    [self initialize];
}


-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])  owner:self options:nil] lastObject ];

    self.frame = frame;
    
    return self;
}

-(void) initialize
{
    self.selectedBackgroundView = [[UIView alloc] init];
    
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:185/255.0 blue:241/255.0 alpha:1];
    
    CGRect frame = self.selectedBackgroundView.frame;
    
    int orgWidth = frame.size.width;
    int orgHeight = frame.size.height;
    
    frame.size.width -=20;
    frame.size.height -=20;
    
    frame.origin.x = (frame.origin.x + orgWidth) /2 - frame.size.width/2;
    frame.origin.y = (frame.origin.y + orgHeight) /2 - frame.size.height/2;
    
    self.selectedBackgroundView.frame = frame;
    
    self.selectedBackgroundView.layer.cornerRadius = self.selectedBackgroundView.frame.size.width/2;
}

-(void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    lblTime.textColor = selected ?  [UIColor whiteColor] : [UIColor blackColor];
}

-(void) setTime:(NSString *)time
{
    _time = time;
    
    lblTime.text = time;
}

@end
