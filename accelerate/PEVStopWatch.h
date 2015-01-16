//
//  PEVStopWatch.h
//  accelerate
//
//  Created by Евгений Прокофьев on 30.12.14.
//  Copyright (c) 2014 Евгений Прокофьев. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PEVStopWatchDelegate;

@interface PEVStopWatch : NSObject
@property(assign, nonatomic) NSInteger milliSeconds;
@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) NSDate *date;

@property (weak, nonatomic) id <PEVStopWatchDelegate> delegate;

-(id)init;

-(void)startTimer;
-(void)stopTimer;

@end


#pragma mark - PEVStopWatchProtocol
@protocol PEVStopWatchDelegate <NSObject>
@optional

-(void)timeUpdate:(NSString*)milliseconds;

@end
