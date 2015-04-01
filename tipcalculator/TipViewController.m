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
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UISlider *noOfPeopleSlider;
@property (weak, nonatomic) IBOutlet UILabel *noOfPeople;
@property (weak, nonatomic) IBOutlet UILabel *eachPays;


- (IBAction)onTap:(id)sender;
- (void)updateValues;

@end

@implementation TipViewController

NSString *currencySymbol;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.title = @"Tip Calculator";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forAppRestart)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    return self;
}
- (void)viewDidLoad {
    currencySymbol = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    
    [self.billTextFeild becomeFirstResponder];

    [super viewDidLoad];
    [self updateValues];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    float tipValue = [defaults floatForKey:@"Default Tip"];
    NSLog(@"Tip index %f", tipValue);
    self.tipSlider.value = tipValue;
    self.tip.text = [NSString stringWithFormat:@"%0.1f", self.tipSlider.value];
    
    [self updateValues];
}
- (IBAction)textFieldEdit:(id)sender {
    self.billTextFeild.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (IBAction)slideValueChange:(id)sender {
    NSLog(@"Tip Percentage %f", self.tipSlider.value);
    self.tip.text = [NSString stringWithFormat:@"%0.1f", self.tipSlider.value];
    [self updateValues];
}

- (IBAction)noOfPeopleChange:(id)sender {
    int noOfPeople = (int) self.noOfPeopleSlider.value;
    self.noOfPeople.text = [NSString stringWithFormat:@"%d", noOfPeople];
    [self updateValues];
}

- (void)forAppRestart{
     NSLog(@"applicationWillEnterForeground");
    NSUserDefaults *defaultsForAppRestart = [NSUserDefaults standardUserDefaults];
    NSDate *dateOne = [defaultsForAppRestart valueForKey:@"Ten Mins After"];
    NSDate *dateTwo = [NSDate date];
    float lastBillAmount = [defaultsForAppRestart floatForKey:@"Last Bill Amount"];
    NSLog(@" Date one %@ date Two %@", dateOne, dateTwo);
    NSLog(@" Last Bill Amount @%0.2f", lastBillAmount);
    
    switch ([dateOne compare:dateTwo]) {
        case NSOrderedAscending:
            // dateOne is earlier in time than dateTwo
            NSLog(@" In NSOrderedAscending ");
            self.billTextFeild.text = @"";
            break;
        case NSOrderedSame:
            // The dates are the same
            NSLog(@" In NSOrderedSame ");
            self.billTextFeild.text = @"";
            break;
        case NSOrderedDescending:
            // dateOne is later in time than dateTwo
            NSLog(@" In NSOrderedDescending @%0.2f", [defaultsForAppRestart floatForKey:@"Last Bill Amount"]);
            
            if(!(lastBillAmount == 0.0)){
                NSLog(@" In if ");
                self.billTextFeild.text = [NSString stringWithFormat:@"%0.2f", [defaultsForAppRestart floatForKey:@"Last Bill Amount"]];
            }
            else{
                self.billTextFeild.text = @"";
            }
            break;
    }
}
- (void)updateValues{
    
    NSDate *todayDate = [NSDate date];
    NSDate *tenMinsAfter = [NSDate dateWithTimeInterval:600 sinceDate:todayDate];
    
    float billAmount = [self.billTextFeild.text floatValue];
    
    float tipAmount = (billAmount * self.tipSlider.value) / 100 ;
    int totalNoPeople = [self.noOfPeople.text integerValue];
    float totalAmount = tipAmount + billAmount;
    float inidividualAmout = totalAmount/totalNoPeople;
    
    self.tipLabel.text = [NSString stringWithFormat:@"%@ %0.2f", currencySymbol, tipAmount];
    self.tipTotal.text = [NSString stringWithFormat:@"%@ %0.2f", currencySymbol, totalAmount];
    self.eachPays.text = [NSString stringWithFormat:@"%@ %0.2f", currencySymbol, inidividualAmout];
    
    NSUserDefaults *defaultsForAppRestart = [NSUserDefaults standardUserDefaults];
    [defaultsForAppRestart setFloat:[self.billTextFeild.text floatValue] forKey:@"Last Bill Amount"];
    [defaultsForAppRestart setValue:tenMinsAfter forKey:@"Ten Mins After"];
    [defaultsForAppRestart synchronize];
    
}

- (void)onSettingsButton{
    
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
    
}
@end
