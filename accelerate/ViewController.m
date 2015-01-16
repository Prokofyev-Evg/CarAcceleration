//
//  ViewController.m
//  accelerate
//
//  Created by Евгений Прокофьев on 27.12.14.
//  Copyright (c) 2014 Евгений Прокофьев. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.speedMeas = [[PEVSpeedMeasurement alloc] init];
    self.timeMeas = [[PEVStopWatch alloc] init];
    
    self.speedMeas.delegate = self;
    self.timeMeas.delegate = self;
    
    self.speedCircle.percent = 0;
    [self speedUpdate:0. valid:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnPressed:(id)sender {
    if (!self.measureSwitch.on)
    {
        [self.speedMeas stopMeasure];
        [self.timeMeas stopTimer];
    }
    else
    {
        [self.speedMeas startMeasure];
    }
}
- (IBAction)precisionSet:(id)sender {
    self.speedMeas.precision = self.measurePrecisionSwitch.on;
}

-(void)movingStarted{
    [self.timeMeas startTimer];
    //NSLog(@"Moving start");
}

-(void)movingStopped{
    [self.timeMeas stopTimer];
    [self.lblResult setTextColor:[UIColor blackColor]];
    //NSLog(@"Moving stopped");
}

-(void)speedUpdate:(CGFloat)speed valid:(BOOL)validData{;
    CGFloat tempSpeed = (speed>=0) ? speed : 0;
    CGFloat normalizeSpeed = (tempSpeed<=100.) ? tempSpeed : 100;
    if (validData) {
        self.speedCircle.percent = normalizeSpeed;
        self.speedCircle.circleColor = [UIColor colorWithHue:normalizeSpeed/100. saturation:1. brightness:1. alpha:1.];
        self.backgrounView.backgroundColor = [UIColor colorWithHue:normalizeSpeed/500. saturation:.1 brightness:1. alpha:1.];
        [self.lblSpeed setText:[NSString stringWithFormat: @"%.1f км/ч",tempSpeed]];
    }
    else{
        self.speedCircle.percent = 0;
        self.speedCircle.circleColor = [UIColor colorWithHue:0. saturation:1. brightness:1. alpha:1.];
        self.backgrounView.backgroundColor = [UIColor colorWithHue:0. saturation:.1 brightness:1. alpha:1.];
        [self.lblSpeed setText:[NSString stringWithFormat: @"-- км/ч"]];
    }
}

-(void)timeUpdate:(NSString*)milliseconds{
    [self.lblTime setText:[NSString stringWithFormat: @"%@",milliseconds]];
}

-(void)speedThresholdReached:(NSInteger)speedThreshold{
    [self.lblResult setText:[self.lblTime text]];
    [self.lblResult setTextColor:[UIColor colorWithRed:0. green:.5 blue:0. alpha:1.]];
}



@end
