//
//  ViewController.m
//  emunana
//
//  Created by 若尾あすか on 2014/07/25.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.
//
#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@implementation ViewController



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateStepCount];
}

// 歩数の表示
- (void)updateStepCount
{
    if([CMStepCounter isStepCountingAvailable])
    {
        // StepCounterのインスタンス作成
        CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
        
        // 歩数を取得
        [stepCounter queryStepCountStartingFrom:[self startDateOfToday]
                                             to:[NSDate date]
                                        toQueue:[NSOperationQueue mainQueue]
                                    withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                        self.stepLabel.text = [NSString stringWithFormat:@"%ld", numberOfSteps];
                                    }];
    }
}

// 今日の0時0分を取得
- (NSDate *)startDateOfToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:[NSDate date]];
    
    return [calendar dateFromComponents:components];
}

@end
