//
//  PEVSpeedMeasurement.m
//  accelerate
//
//  Created by Евгений Прокофьев on 30.12.14.
//  Copyright (c) 2014 Евгений Прокофьев. All rights reserved.
//

#import "PEVSpeedMeasurement.h"
#define PRECISION 0.1

@implementation PEVSpeedMeasurement{
    BOOL firstReached;
    BOOL userIsMoving;
    CGFloat correction;
    CGFloat gpsSpeed;
    NSTimer *gpsTimer;
    NSInteger gpsCounter;
}

-(id)init{
    self = [super init];
    if (self) {
        self.SpeedMeasAccelerometr = [[CMMotionManager alloc] init];
        self.SpeedMeasLocationManager = [[CLLocationManager alloc] init];
        self.SpeedMeasLocationManager.delegate = self;
        
        if ([self.SpeedMeasLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [self.SpeedMeasLocationManager requestWhenInUseAuthorization];
        }
        firstReached = YES;
        userIsMoving = YES;
    }
    return self;
}

-(BOOL)isMeasureEnable{
    return [self.SpeedMeasAccelerometr isDeviceMotionActive];
}


-(void)startMeasure{
    [self.SpeedMeasLocationManager startUpdatingLocation];
    
    gpsTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(gpsTimerAlarm) userInfo:nil repeats:YES];
    [self.SpeedMeasAccelerometr setDeviceMotionUpdateInterval:PRECISION];
    if ([self.SpeedMeasAccelerometr isAccelerometerAvailable]) {
        NSLog(@"YES");
    }[self.SpeedMeasAccelerometr startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                                    withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                        
                                                        [self processSpeed:gpsSpeed accelerationX:motion.userAcceleration.x accY:motion.userAcceleration.y accZ:motion.userAcceleration.z];
                                                        [self movingDetect];
                                                        [self.delegate speedUpdate:self.currentSpeed valid:self.validData];
                                                        
                                                        if ((self.currentSpeed>=100)&(!firstReached)) {
                                                            [self.delegate speedThresholdReached:100];
                                                            firstReached = YES;
                                                        }
                                                    }];
}

-(void)gpsTimerAlarm{
    if ((gpsCounter<2)||(gpsSpeed<0.))
        self.validData = NO;
    else
        self.validData = YES;
    NSLog(@"GPS Counter %i",gpsCounter);
    gpsCounter = 0;
}

-(void)movingDetect{
    if (userIsMoving) {
        if ((self.currentSpeed < MOVING_THRESHOLD)&(self.currentAcceleration < MOVING_THRESHOLD/2.)) {
            userIsMoving = NO;
            [self.delegate movingStopped];
        }
    }
    else
    {
        if ((self.currentSpeed > MOVING_THRESHOLD)|(self.currentAcceleration > MOVING_THRESHOLD/4.)) {
            userIsMoving = YES;
            firstReached = NO;
            [self.delegate movingStarted];
        }
    }
}

-(void)processSpeed:(CGFloat)gpsSpd accelerationX:(CGFloat)accX accY:(CGFloat)accY accZ:(CGFloat)accZ{
    CGFloat acceleration2D = sqrt(pow(accX,2)+pow(accY,2));
    CGFloat acceleration3D = sqrt(pow(acceleration2D,2)+pow(accZ,2));
    self.currentSpeed = gpsSpeed;
    if (self.precision)
        self.currentSpeed += correction;
    if (gpsSpeed<0) {
        self.currentSpeed = 0;
    }
    correction += acceleration3D*PRECISION*3.6;
    self.currentAcceleration = acceleration3D;
}

-(void)stopMeasure{
    [self.SpeedMeasAccelerometr stopDeviceMotionUpdates];
    [self.SpeedMeasLocationManager stopUpdatingLocation];
    firstReached = YES;
    userIsMoving = YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *lastLocation = locations.lastObject;
    gpsSpeed = lastLocation.speed*3.6;
    NSLog(@"GPS update, correction is %f, speed is %f",correction,gpsSpeed);
    correction = 0;
    gpsCounter++;
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"New status: %d", status);
    NSLog(@"Is when in use? %d", [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

@end
