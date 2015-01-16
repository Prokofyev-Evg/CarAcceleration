//
//  PEVSpeedMeasurement.h
//  accelerate
//
//  Created by Евгений Прокофьев on 30.12.14.
//  Copyright (c) 2014 Евгений Прокофьев. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
#include <CoreLocation/CoreLocation.h>
@protocol PEVSpeedMeasurementDelegate;

@interface PEVSpeedMeasurement : NSObject <CLLocationManagerDelegate>

#define MOVING_THRESHOLD 1

@property(strong, nonatomic) CLLocationManager *SpeedMeasLocationManager;
@property(strong, nonatomic) CMMotionManager *SpeedMeasAccelerometr;
@property(assign, nonatomic) CGFloat currentSpeed;
@property(assign, nonatomic) CGFloat currentAcceleration;
@property(assign, nonatomic) BOOL precision;
@property(assign, nonatomic) BOOL validData;

@property (weak, nonatomic) id <PEVSpeedMeasurementDelegate> delegate;


-(id)init;

-(void)startMeasure;
-(void)stopMeasure;
-(BOOL)isMeasureEnable;

@end

#pragma mark - PEVSpeedMeasurementProtocol

@protocol PEVSpeedMeasurementDelegate <NSObject>
@optional

-(void)speedThresholdReached:(NSInteger) speedThreshold;
-(void)speedUpdate:(CGFloat)speed valid:(BOOL)validData;
-(void)movingStarted;
-(void)movingStopped;

@end

