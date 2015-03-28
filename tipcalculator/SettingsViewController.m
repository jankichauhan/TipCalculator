//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Janki on 3/27/15.
//  Copyright (c) 2015 Janki. All rights reserved.
//
#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipAmount;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    self.title = @"Settings";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int intValue = [defaults integerForKey:@"Default Tip"];
    NSLog(@"Tip index %d", intValue);
    self.defaultTipAmount.selectedSegmentIndex = intValue;
    [self setTipControllerValue];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@" settings view will appear");
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@" settings view did appear");

    
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@" settings view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@" settings view did disappear");
}

- (void)didReceiveMemoryWarning {
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self setTipControllerValue];
}

-(void)setTipControllerValue{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.defaultTipAmount.selectedSegmentIndex forKey:@"Default Tip"];
    [defaults synchronize];
}

@end
