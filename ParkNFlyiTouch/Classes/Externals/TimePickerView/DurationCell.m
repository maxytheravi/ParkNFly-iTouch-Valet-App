//
//  DurationCellTableViewCell.m
//  PNF-Consumer
//
//  Created by Bhavesh on 02/12/14.
//  Copyright (c) 2014 PNF. All rights reserved.
//

#import "DurationCell.h"

@interface DurationCell()
{
    __weak IBOutlet UILabel* lblduration;
    
    UIView* bgView;
    
    IBOutlet __weak UIView* borderView;
}

@end

@implementation DurationCell

-(void) setShowBorder:(BOOL)showBorder
{
    _showBorder = showBorder;
    
    borderView.hidden = !showBorder;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialize];
}

-(void) initialize
{
    bgView = [[UIView alloc] init];
    
    bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:185/255.0 blue:241/255.0 alpha:1];
    
    CGRect selectedFrame = self.selectedBackgroundView.frame;
    
    selectedFrame.size = CGSizeMake(30, 30);
    
    selectedFrame.origin.x = self.center.x - selectedFrame.size.width/2;
    selectedFrame.origin.y = self.center.y - selectedFrame.size.height/2;
    
    bgView.frame = selectedFrame;
    
//    bgView.layer.cornerRadius = bgView.frame.size.width/2;
    
    self.selectedBackgroundView = [[UIView alloc] init];
    
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])  owner:self options:nil] lastObject ];
    
    [self initialize];
    
    return self;
}

-(void) setSelected:(BOOL)selected
{
    if(selected)
       [self.contentView addSubview:bgView];
    
    else
        [bgView removeFromSuperview];
    
    lblduration.textColor = selected ?  [UIColor whiteColor] : [UIColor blackColor];
    
    [self.contentView bringSubviewToFront:lblduration];
}

-(void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(selected)
        [self.contentView addSubview:bgView];
    
    else
        [bgView removeFromSuperview];
    
    lblduration.textColor = selected ?  [UIColor whiteColor] : [UIColor blackColor];
    
    [self.contentView bringSubviewToFront:lblduration];
}

-(void) setDuration:(NSString *)duration
{
    _duration = duration;
    
    lblduration.text = duration;
    
}

@end
