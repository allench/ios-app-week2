//
//  SwitchCell.m
//  Yelp
//
//  Created by Allen Chiang on 6/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell()

- (IBAction)onSwitchValueChanged:(id)sender;

@end

@implementation SwitchCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOn:(BOOL)on {
    _on = on;
    [self.switchButton setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    _on = on;
    [self.switchButton setOn:on animated:animated];
}

- (IBAction)onSwitchValueChanged:(id)sender {
    [self.delegate SwitchCell:self didUpdateValue:self.switchButton.on didUpdateRadius:self.switchSlider.value];
}

@end
