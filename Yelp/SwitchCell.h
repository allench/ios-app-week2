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
     didUpdateValue: (BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *switchLabel;

@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) id<SwitchCellDelegate> delegate;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
