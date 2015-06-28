//
//  FilterViewController.m
//  Yelp
//
//  Created by Allen Chiang on 6/27/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (nonatomic, readonly) NSDictionary *filter;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedSections;
@property (nonatomic, strong) NSString *selectedRadius;

- (void) initSections;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedSections = [NSMutableSet set];
        [self initSections];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButtonClicked)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButtonClicked)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SliderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"RadioCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SwitchCell methods
- (void) SwitchCell:(SwitchCell *)cell didUpdateValue:(BOOL)isOn didUpdateRadius:(float)radius {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *title = self.sections[indexPath.section][@"title"];
    // Sort - clean all selected RadioCell first
    if ([title isEqual: @"Sort"]) {
        if (isOn) {
            NSArray *aSelectedSections = [self.selectedSections allObjects];
            for (NSIndexPath *idxPath in aSelectedSections) {
                if (idxPath.section == indexPath.section) {
                    [self.selectedSections removeObject:idxPath];
                    [(SwitchCell *)[self.tableView cellForRowAtIndexPath:idxPath] setOn:NO];
                }
            }
            [self.selectedSections addObject:indexPath];
        } else {
            [self.selectedSections removeObject:indexPath];
        }
    }
    // Categories
    if ([title isEqual: @"Categories"] || [title isEqual: @"Deals"]) {
        if (isOn) {
            [self.selectedSections addObject:indexPath];
        } else {
            [self.selectedSections removeObject:indexPath];
        }
    }
    // Radius
    if ([title isEqual: @"Radius"]) {
        self.selectedRadius = [NSString stringWithFormat:@"%.0f", radius];
        [self.selectedSections addObject:indexPath];
    }
}

#pragma mark - TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *aRows = self.sections[section][@"rows"];
    return aRows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *typeName = self.sections[indexPath.section][@"type"];
    
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:typeName forIndexPath:indexPath];
    cell.delegate = self;
    cell.switchLabel.text = self.sections[indexPath.section][@"rows"][indexPath.row][@"name"];
    cell.on = [self.selectedSections containsObject:indexPath];
    if ([typeName isEqual: @"SliderCell"]) {
        cell.switchButton.hidden = YES;
    } else {
        cell.switchSlider.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section][@"title"];
}

#pragma mark - Private Methods
- (NSDictionary *)filter {
    NSMutableDictionary *filter = [NSMutableDictionary dictionary];

    NSArray *aSelectedSections = [self.selectedSections allObjects];
    for (NSIndexPath *idxPath in aSelectedSections) {
        NSDictionary *section = self.sections[idxPath.section];
        // Sort
        if ([section[@"title"] isEqual: @"Sort"]) {
            NSDictionary *row = section[@"rows"][idxPath.row];
            [filter setObject:row[@"code"] forKey:section[@"param"]];
        }
        // Deals
        if ([section[@"title"] isEqual: @"Deals"]) {
            NSDictionary *row = section[@"rows"][idxPath.row];
            [filter setObject:row[@"code"] forKey:section[@"param"]];
        }
        // Categories
        if ([section[@"title"] isEqual: @"Categories"]) {
            NSDictionary *row = section[@"rows"][idxPath.row];
            NSMutableArray *aCategories = [NSMutableArray array];
            
            NSString *sCategories = [filter valueForKey:section[@"param"]];
            if (sCategories) {
                [aCategories addObject:sCategories];
            }
            [aCategories addObject:row[@"code"]];
            sCategories = [aCategories componentsJoinedByString:@","];
            
            [filter setObject:sCategories forKey:section[@"param"]];
        }
        // Radius
        if ([section[@"title"] isEqual: @"Radius"]) {
            [filter setObject:self.selectedRadius forKey:section[@"param"]];
        }
    }
    
    return filter;
}

- (void)onCancelButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButtonClicked {
    [self.delegate filterViewController:self didChangeFilter:self.filter];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initSections {
    self.sections =
    @[
      @{
          @"title": @"Sort",
          @"param": @"sort",
          @"type": @"RadioCell",
          @"rows":
              @[
                  @{@"name": @"Best Match", @"code": @"0" },
                  @{@"name": @"Distance", @"code": @"1" },
                  @{@"name": @"Highest Rated", @"code": @"2" }
                  ]
          },
      @{
          @"title": @"Radius",
          @"param": @"radius_filter",
          @"type": @"SliderCell",
          @"rows":
              @[
                  @{@"name": @"Radius", @"code": @40000 }
                  ]
          },
      @{
          @"title": @"Deals",
          @"param": @"deals_filter",
          @"type": @"SwitchCell",
          @"rows":
              @[
                  @{@"name": @"Deals", @"code": @"true" }
                  ]
          },
      @{
          @"title": @"Categories",
          @"param": @"category_filter",
          @"type": @"SwitchCell",
          @"rows":
              @[
                  @{@"name": @"American, New", @"code": @"newamerican" },
                  @{@"name": @"American, Traditional", @"code": @"tradamerican" },
                  @{@"name": @"Asian Fusion", @"code": @"asianfusion" },
                  @{@"name": @"Barbeque", @"code": @"bbq" },
                  @{@"name": @"Beer Garden", @"code": @"beergarden" },
                  @{@"name": @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
                  @{@"name": @"Buffets", @"code": @"buffets" },
                  @{@"name": @"Burgers", @"code": @"burgers" },
                  @{@"name": @"Cafes", @"code": @"cafes" },
                  @{@"name": @"Chinese", @"code": @"chinese" },
                  @{@"name": @"Diners", @"code": @"diners" },
                  @{@"name": @"Fast Food", @"code": @"hotdogs" },
                  @{@"name": @"French", @"code": @"french" },
                  @{@"name": @"Hot Pot", @"code": @"hotpot" },
                  @{@"name": @"Indian", @"code": @"indpak" },
                  @{@"name": @"Italian", @"code": @"italian" },
                  @{@"name": @"Japanese", @"code": @"japanese" },
                  @{@"name": @"Korean", @"code": @"korean" },
                  @{@"name": @"Mexican", @"code": @"mexican" },
                  @{@"name": @"Night Food", @"code": @"nightfood" },
                  @{@"name": @"Pizza", @"code": @"pizza" },
                  @{@"name": @"Pub Food", @"code": @"pubfood" },
                  @{@"name": @"Rice", @"code": @"riceshop" },
                  @{@"name": @"Salad", @"code": @"salad" },
                  @{@"name": @"Seafood", @"code": @"seafood" },
                  @{@"name": @"Soup", @"code": @"soup" },
                  @{@"name": @"Spanish", @"code": @"spanish" },
                  @{@"name": @"Steakhouses", @"code": @"steak" },
                  @{@"name": @"Sushi Bars", @"code": @"sushi" },
                  @{@"name": @"Taiwanese", @"code": @"taiwanese" },
                  @{@"name": @"Thai", @"code": @"thai" },
                  @{@"name": @"Vegetarian", @"code": @"vegetarian" },
                  @{@"name": @"Vietnamese", @"code": @"vietnamese" }
                  ]
          }
      ];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
