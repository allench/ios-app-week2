//
//  SwitchCell.h
//  Yelp
//
//  Created by Allen Chiang on 6/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void) SwitchCell: (SwitchCell *)cell
     didUpdateValue: (BOOL)value
    didUpdateRadius: (float)radius;

@end

@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UISlider *switchSlider;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
