//
//  ViewController.swift
//  emunanaEX
//
//  Created by 若尾あすか on 2014/07/28.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.
//http://griffin-stewie.hatenablog.com/entry/2013/09/22/130002
//http://wonderpla.net/blog/engineer/iPhone5s_M7chip/

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet var steplabel: UILabel!
    var stepCount:Int!
    var prevSteps:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stepCount = 0
        getHistoricalSteps()
        updateSteps()
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateStepLabel"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getHistoricalSteps() {
        if(CMStepCounter.isStepCountingAvailable()){
            //StepCounterのインスタンス作成
            var stepCounter = CMStepCounter()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            var todate:NSDate! = NSDate()
            
            //歩数を取得
            stepCounter.queryStepCountStartingFrom(startDateOfToday(), to: todate, toQueue: mainQueue, withHandler: {numberOfSteps, error in
                println("Historical:\(numberOfSteps)")
                self.prevSteps = numberOfSteps
            })
        }
    }
    
    func updateSteps() {
        if(CMStepCounter.isStepCountingAvailable()){
            //StepCounterのインスタンス作成
            var stepCounter = CMStepCounter()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            var todate:NSDate! = NSDate()
            
            //歩数を取得
            stepCounter.startStepCountingUpdatesToQueue(mainQueue, updateOn: 1, withHandler: {numberOfSteps, timestamp, error in
                self.stepCount = numberOfSteps + self.prevSteps
                println("Update: \(numberOfSteps)")
            })
        }
    }
    
    func updateStepLabel() {
        steplabel.text = "\(stepCount)"
    }
    
    
    //今日の０時０分を取得
    func startDateOfToday() -> NSDate! {
        var calender = NSCalendar.currentCalendar()
        var components = calender.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
        return calender.dateFromComponents(components)
    }
}

