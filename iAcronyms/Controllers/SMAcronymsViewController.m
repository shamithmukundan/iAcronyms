//
//  SMAcronymsViewController.m
//  iAcronyms
//
//  Created by Shamith Mukundan on 2/11/17.
//  Copyright © 2017 Shamith. All rights reserved.
//

#import "SMAcronymsViewController.h"
#import "SMAVariationsTableViewController.h"
#import "SMARequestManager.h"
#import "SMAShortForm.h"
#import "SMALongForm.h"
#import "SMADefinitionsTableViewCell.h"
#import "MBProgressHUD/MBProgressHUD.h"

@interface SMAcronymsViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SMAShortForm *shortForm;
@property (nonatomic, weak) IBOutlet UITableView *acronymTableView;
@property (nonatomic, weak) IBOutlet UITextField *searchTextField;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;


@end

@implementation SMAcronymsViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.acronymTableView.hidden = YES;
    self.searchTextField.delegate = self;
    [self.searchButton addTarget:self action:@selector(fetchDefinitions) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton.enabled = NO;
    [self.acronymTableView registerNib:[SMADefinitionsTableViewCell nib] forCellReuseIdentifier:@"DefinitionsCell"];
    self.navigationController.title = @"Search Definitions";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.searchTextField isFirstResponder]) {
        [self.searchTextField resignFirstResponder];
    }
    [super viewWillDisappear:animated];
}

//fetch definitions for given string
- (void)fetchDefinitions {
    
    NSString *searchText = [[self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];

    self.acronymTableView.hidden = YES;
    [self.searchTextField resignFirstResponder];
    __weak typeof(self) weakSelf = self;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SMARequestManager sharedManager] fetchDefinitionsFor:searchText success:^(NSURLSessionDataTask *task, SMAShortForm *shortForm){
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (shortForm && shortForm.longForms.count > 0) {
            weakSelf.shortForm = shortForm;
            weakSelf.acronymTableView.hidden = NO;
            [weakSelf.acronymTableView reloadData];
        } else {
            [self showAlert:@"No Results" message:[NSString stringWithFormat:@"No full form for %@", searchText]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [weakSelf showAlert:@"Error" message:error.localizedDescription];
    }];
}

//Alert for error and no result cases.
- (void)showAlert:(NSString *) errorTitle message:(NSString *) errorMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:errorTitle message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UITextField delegate methods
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *trimmedText = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.searchButton.enabled = (trimmedText.length >= 2);
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.searchTextField resignFirstResponder];
    NSString *trimmedText = [self.searchTextField.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    if (trimmedText.length >= 2) {
        [self fetchDefinitions];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.acronymTableView setHidden:YES];
}

#pragma mark- UITableView Datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shortForm.longForms.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 40)];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    NSString *string = self.searchTextField.text;
    label.text = [NSString stringWithFormat:@"Definitions for: %@", string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"DefinitionsCell";
    SMADefinitionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    SMALongForm *longForm = [self.shortForm.longForms objectAtIndex:indexPath.row];
    cell.longFormLabel.text = longForm.longForm;
    cell.usedSince.text = longForm.since;
    cell.frequency.text = longForm.frequency;
    if (longForm.variations.count == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = false;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMALongForm *longForm = self.shortForm.longForms[indexPath.row];
    NSArray *variations = longForm.variations;
    SMAVariationsTableViewController *variationsTableViewController = [[SMAVariationsTableViewController alloc] initWithVariations:variations];
    [self.navigationController pushViewController:variationsTableViewController animated:YES];
    [self.acronymTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

@end
