//
//  FilterViewController.h
//  Yelp
//
//  Created by Allen Chiang on 6/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

- (void)filterViewController: (FilterViewController *) fvc
             didChangeFilter: (NSDictionary *) filter;
@end


@interface FilterViewController : UIViewController

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@end
