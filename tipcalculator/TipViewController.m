//
//  TipViewController.m
//  tipcalculator
//
//  Created by Janki on 3/27/15.
//  Copyright (c) 2015 Janki. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipTotal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onTap:(id)sender;
- (void)updateValues;

@end

@implementation TipViewController



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"Tip Calculator";
    }
    return self;
}
- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];

    [super viewDidLoad];
    [self updateValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (void)updateValues{
    float billAmount = [self.billTextFeild.text floatValue];
    
    NSArray *tipValues = @[@(0.1), @(0.15), @(0.2)];
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = tipAmount + billAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.tipTotal.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (void)onSettingsButton{

    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];

}
@end
