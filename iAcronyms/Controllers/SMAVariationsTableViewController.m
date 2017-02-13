//
//  SMAVariationsTableViewController.m
//  iAcronyms
//
//  Created by Shamith Mukundan on 2/12/17.
//  Copyright © 2017 Shamith. All rights reserved.
//

#import "SMAVariationsTableViewController.h"
#import "SMADefinitionsTableViewCell.h"

@interface SMAVariationsTableViewController ()

@property (nonatomic, strong) NSArray *variations;

@end

@implementation SMAVariationsTableViewController

- (instancetype)initWithVariations:(NSArray *)variationsInfo {
    if (self = [super init]) {
        self.variations = variationsInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Variations";
    [self.tableView registerNib:[SMADefinitionsTableViewCell nib] forCellReuseIdentifier:@"DefinitionsCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.variations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"DefinitionsCell";
    
    SMADefinitionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.longFormLabel.text = [self.variations[indexPath.row] valueForKey:@"lf"];
    cell.usedSince.text = [NSString stringWithFormat:@"%zd" ,[[self.variations[indexPath.row] valueForKey:@"since"] integerValue]];
    cell.frequency.text = [NSString stringWithFormat:@"%zd" ,[[self.variations[indexPath.row] valueForKey:@"freq"] integerValue]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = false;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

@end
