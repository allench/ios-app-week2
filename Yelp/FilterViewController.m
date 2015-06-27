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
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;

- (void) initCategories;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SwitchCell methods
- (void) SwitchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (value) {
        [self.selectedCategories addObject:self.categories[indexPath.row]];
    } else {
        [self.selectedCategories removeObject:self.categories[indexPath.row]];
    }
}

#pragma mark - TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
    cell.switchLabel.text = self.categories[indexPath.row][@"name"];
    cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - Private Methods
- (NSDictionary *)filter {
    NSMutableDictionary *filter = [NSMutableDictionary dictionary];

    if (self.selectedCategories.count > 0) {
        NSMutableArray *aNames = [NSMutableArray array];
        for (NSDictionary *dict in self.selectedCategories) {
            [aNames addObject:dict[@"code"]];
        }
        NSString *sCategoryFilter = [aNames componentsJoinedByString:@","];
        [filter setObject:sCategoryFilter forKey:@"category_filter"];
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

- (void)initCategories {
    self.categories =
        @[
          @{@"name" : @"American, New", @"code": @"newamerican" },
          @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
          @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
          @{@"name" : @"Barbeque", @"code": @"bbq" },
          @{@"name" : @"Beer Garden", @"code": @"beergarden" },
          @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
          @{@"name" : @"Buffets", @"code": @"buffets" },
          @{@"name" : @"Burgers", @"code": @"burgers" },
          @{@"name" : @"Cafes", @"code": @"cafes" },
          @{@"name" : @"Chinese", @"code": @"chinese" },
          @{@"name" : @"Diners", @"code": @"diners" },
          @{@"name" : @"Fast Food", @"code": @"hotdogs" },
          @{@"name" : @"French", @"code": @"french" },
          @{@"name" : @"Hot Pot", @"code": @"hotpot" },
          @{@"name" : @"Indian", @"code": @"indpak" },
          @{@"name" : @"Italian", @"code": @"italian" },
          @{@"name" : @"Japanese", @"code": @"japanese" },
          @{@"name" : @"Korean", @"code": @"korean" },
          @{@"name" : @"Mexican", @"code": @"mexican" },
          @{@"name" : @"Night Food", @"code": @"nightfood" },
          @{@"name" : @"Pizza", @"code": @"pizza" },
          @{@"name" : @"Pub Food", @"code": @"pubfood" },
          @{@"name" : @"Rice", @"code": @"riceshop" },
          @{@"name" : @"Salad", @"code": @"salad" },
          @{@"name" : @"Seafood", @"code": @"seafood" },
          @{@"name" : @"Soup", @"code": @"soup" },
          @{@"name" : @"Spanish", @"code": @"spanish" },
          @{@"name" : @"Steakhouses", @"code": @"steak" },
          @{@"name" : @"Sushi Bars", @"code": @"sushi" },
          @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
          @{@"name" : @"Thai", @"code": @"thai" },
          @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
          @{@"name" : @"Vietnamese", @"code": @"vietnamese" }
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
