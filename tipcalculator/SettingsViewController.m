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
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@end

@implementation SettingsViewController



- (void)viewDidLoad {
    self.title = @"Settings";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //int intValue = [defaults integerForKey:@"Default Tip"];
    float tipValue = [defaults floatForKey:@"Default Tip"];
    NSLog(@"Tip value %f", tipValue);
   // self.defaultTipAmount.selectedSegmentIndex = intValue;
    self.tipSlider.value = tipValue;
    self.tip.text = [NSString stringWithFormat:@"%0.1f", self.tipSlider.value];
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

- (IBAction)sliderValueChange:(id)sender {
    NSLog(@"Tip Percentage %f", self.tipSlider.value);
    self.tip.text = [NSString stringWithFormat:@"%0.1f", self.tipSlider.value];
    [self setTipControllerValue];
}

-(void)setTipControllerValue{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:self.tipSlider.value forKey:@"Default Tip"];
    [defaults synchronize];
}

@end
