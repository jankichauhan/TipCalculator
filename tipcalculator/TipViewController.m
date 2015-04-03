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
@property (weak, nonatomic) IBOutlet UILabel *billText;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountText;
@property (weak, nonatomic) IBOutlet UILabel *tipPerText;
@property (weak, nonatomic) IBOutlet UILabel *totalText;
@property (weak, nonatomic) IBOutlet UILabel *individualText;
@property (weak, nonatomic) IBOutlet UILabel *noOfPeopleText;

@property (weak, nonatomic) IBOutlet UITextField *billTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipTotal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UISlider *noOfPeopleSlider;
@property (weak, nonatomic) IBOutlet UILabel *noOfPeople;
@property (weak, nonatomic) IBOutlet UILabel *eachPays;
@property (nonatomic) NSNumberFormatter *currencySymbol;
@property (nonatomic) UIColor *darkBackground;


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
    
    self.darkBackground = [UIColor colorWithRed: 85.0/255.0 green:107.0/255.0 blue:47.0/255.0 alpha:1.0];
    //self.darkBackground = [UIColor colorWithRed: 107.0/255.0 green:142.0/255.0 blue:35.0/255.0 alpha:1.0];

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
    BOOL theme = [defaults boolForKey:@"Theme Set"];
    if (theme) {
        [self setDarkMode];
    } else {
        [self setLightMode];
    }
    
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
            [self updateValues];
            [self.billTextFeild becomeFirstResponder];
            break;
        case NSOrderedSame:
            // The dates are the same
            NSLog(@" In NSOrderedSame ");
            self.billTextFeild.text = @"";
            [self updateValues];
            [self.billTextFeild becomeFirstResponder];
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
    
    self.currencySymbol = [[NSNumberFormatter alloc] init];
    [self.currencySymbol setNumberStyle:NSNumberFormatterCurrencyStyle];
   
    self.tipLabel.text = [self.currencySymbol stringFromNumber:[[NSNumber alloc] initWithFloat:tipAmount]];
    self.tipTotal.text = [self.currencySymbol stringFromNumber:[[NSNumber alloc] initWithFloat:totalAmount]];
    self.eachPays.text = [self.currencySymbol stringFromNumber:[[NSNumber alloc] initWithFloat:inidividualAmout]];

    
    NSUserDefaults *defaultsForAppRestart = [NSUserDefaults standardUserDefaults];
    [defaultsForAppRestart setFloat:[self.billTextFeild.text floatValue] forKey:@"Last Bill Amount"];
    [defaultsForAppRestart setValue:tenMinsAfter forKey:@"Ten Mins After"];
    [defaultsForAppRestart synchronize];
    
}

- (void)onSettingsButton{
    
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
    
}

- (void)setDarkMode{
    self.view.backgroundColor = self.darkBackground;
    self.billTextFeild.backgroundColor = self.darkBackground;
    self.billTextFeild.textColor = [UIColor whiteColor];
    self.billTextFeild.tintColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.billTextFeild.attributedPlaceholder = [[NSAttributedString alloc]
                                                      initWithString:[self.currencySymbol currencySymbol]
                                                      attributes:@{NSForegroundColorAttributeName:
                                                                       self.darkBackground}];
    self.billTextFeild.keyboardAppearance = UIKeyboardAppearanceDark;
    
    self.tipLabel.textColor = [UIColor whiteColor];
    
    self.tipTotal.backgroundColor = self.darkBackground;
    self.tipTotal.textColor = [UIColor whiteColor];
    
    self.tip.backgroundColor = self.darkBackground;
    self.tip.textColor = [UIColor whiteColor];
    
    self.noOfPeople.backgroundColor = self.darkBackground;
    self.noOfPeople.textColor = [UIColor whiteColor];
    
    self.eachPays.backgroundColor = self.darkBackground;
    self.eachPays.textColor = [UIColor whiteColor];
    
    
    self.billText.textColor = [UIColor whiteColor];
    self.tipAmountText.textColor = [UIColor whiteColor];
    self.tipPerText.textColor = [UIColor whiteColor];
    self.totalText.textColor = [UIColor whiteColor];
    self.individualText.textColor = [UIColor whiteColor];
    self.noOfPeopleText.textColor = [UIColor whiteColor];
    
    NSDictionary *settingsTitleProperties = @{
                                              NSFontAttributeName: [UIFont fontWithName:@"helvetica" size:16],
                                              NSForegroundColorAttributeName: self.darkBackground
                                              };
   [self.navigationItem.rightBarButtonItem setTitleTextAttributes:settingsTitleProperties forState:UIControlStateNormal];
    
    // Make status bar white text on black
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)setLightMode{
    self.view.backgroundColor = [UIColor whiteColor];
    self.billTextFeild.backgroundColor = [UIColor whiteColor];
    self.billTextFeild.textColor = [UIColor grayColor];
    self.billTextFeild.tintColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.billTextFeild.attributedPlaceholder = [[NSAttributedString alloc]
                                                      initWithString:[self.currencySymbol currencySymbol]
                                                      attributes:@{NSForegroundColorAttributeName:
                                                                       [UIColor grayColor]}];
    self.billTextFeild.keyboardAppearance = UIKeyboardAppearanceDefault;
    
    self.tipLabel.textColor = [UIColor grayColor];
    
    self.tipTotal.backgroundColor = [UIColor whiteColor];
    self.tipTotal.textColor = [UIColor grayColor];
    
    self.tip.backgroundColor = [UIColor whiteColor];
    self.tip.textColor = [UIColor grayColor];
    
    self.noOfPeople.backgroundColor = [UIColor whiteColor];
    self.noOfPeople.textColor = [UIColor grayColor];
    
    self.eachPays.backgroundColor = [UIColor whiteColor];
    self.eachPays.textColor = [UIColor grayColor];
    
    
    self.billText.textColor = [UIColor grayColor];
    self.tipAmountText.textColor = [UIColor grayColor];
    self.tipPerText.textColor = [UIColor grayColor];
    self.totalText.textColor = [UIColor grayColor];
    self.individualText.textColor = [UIColor grayColor];
    self.noOfPeopleText.textColor = [UIColor grayColor];
    
    NSDictionary *settingsTitleProperties = @{
                                              NSFontAttributeName: [UIFont fontWithName:@"helvetica"  size:16],
                                              NSForegroundColorAttributeName: [UIColor grayColor]
                                              };
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:settingsTitleProperties forState:UIControlStateNormal];
    
    // Return status bar to default
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
}

@end
