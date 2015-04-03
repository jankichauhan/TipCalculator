//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Janki on 3/27/15.
//  Copyright (c) 2015 Janki. All rights reserved.
//
#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *themeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (nonatomic) BOOL themeDark;
@property (nonatomic) UIColor *darkBackground;

@property (weak, nonatomic) IBOutlet UILabel *defaultTipText;
@property (weak, nonatomic) IBOutlet UILabel *tipText;
@property (weak, nonatomic) IBOutlet UILabel *themeText;

@end

@implementation SettingsViewController

- (IBAction)themeChange:(id)sender {
    
    if([sender isOn]){
        self.themeDark = YES;
        [self setDarkMode];
    }
    else{
        self.themeDark = NO;
        [self setLightMode];
    }
    
    [self setTipControllerValue];

}

- (void)viewDidLoad {
    self.title = @"Settings";
    self.darkBackground = [UIColor colorWithRed: 85.0/255.0 green:107.0/255.0 blue:47.0/255.0 alpha:1.0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //int intValue = [defaults integerForKey:@"Default Tip"];
    float tipValue = [defaults floatForKey:@"Default Tip"];
    BOOL themeSwitch  = [defaults boolForKey:@"Theme Set"];
    self.tipSlider.value = tipValue;
    self.tip.text = [NSString stringWithFormat:@"%0.1f", self.tipSlider.value];
    self.themeSwitch.on = themeSwitch;
    
    if(themeSwitch){
        [self setDarkMode];
    }
    else{
        [self setLightMode];
    }
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
    [defaults setBool:self.themeDark forKey:@"Theme Set"];
    [defaults synchronize];
}

-(void)setDarkMode{
    
    self.view.backgroundColor = self.darkBackground;
    self.tip.backgroundColor = self.darkBackground;
    self.tip.textColor = [UIColor whiteColor];
    self.defaultTipText.textColor = [UIColor whiteColor];
    self.tipText.textColor = [UIColor whiteColor];
    self.themeText.textColor = [UIColor whiteColor];
    
}

-(void)setLightMode{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tip.backgroundColor = [UIColor whiteColor];
    self.tip.textColor = [UIColor grayColor];
    self.defaultTipText.textColor = [UIColor grayColor];
    self.tipText.textColor = [UIColor grayColor];
    self.themeText.textColor = [UIColor grayColor];
    
}

@end
