//
//  ViewController.h
//  accelerate
//
//  Created by Евгений Прокофьев on 27.12.14.
//  Copyright (c) 2014 Евгений Прокофьев. All rights reserved.
//
#import "PEVSpeedMeasurement.h"
#import "PEVStopWatch.h"
#import "PEVSpeedCircle.h"

@interface ViewController : UIViewController <PEVSpeedMeasurementDelegate, PEVStopWatchDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblSpeed;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *backgrounView;
@property (strong, nonatomic) PEVSpeedMeasurement *speedMeas;
@property (strong, nonatomic) PEVStopWatch *timeMeas;
@property (weak, nonatomic) IBOutlet PEVSpeedCircle *speedCircle;
@property (weak, nonatomic) IBOutlet UISwitch *measureSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *measurePrecisionSwitch;

@end