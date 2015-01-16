//
//  PEVStopWatch.m
//  accelerate
//
//  Created by Евгений Прокофьев on 30.12.14.
//  Copyright (c) 2014 Евгений Прокофьев. All rights reserved.
//

#import "PEVStopWatch.h"

@implementation PEVStopWatch{
    NSDate *startDate;
    NSCalendar *gregorianCalendar;
}

-(id)init{
    self = [super init];
    if (self) {
        self.milliSeconds = 0;
        self.date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        
        gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    return self;
}

-(void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAlarm) userInfo:nil repeats:YES];
    startDate = [NSDate date];
}

-(void)stopTimer{
    self.milliSeconds = 0;
    [self.timer invalidate];
    self.timer = nil;
}

-(void)timerAlarm{
    //self.milliSeconds++;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components = [gregorianCalendar components:NSCalendarUnitNanosecond|NSCalendarUnitSecond|NSCalendarUnitMinute fromDate:startDate toDate:[NSDate date] options:0];
    NSString *timeString = [NSString stringWithFormat:@"%.2li:%.2li,%.3i",(long)components.minute,(long)components.second,components.nanosecond/1000000];
    [self.delegate timeUpdate:timeString];
}

@end
