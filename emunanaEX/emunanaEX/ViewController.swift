//
//  ViewController.swift
//  emunanaEX
//
//  Created by 若尾あすか on 2014/07/28.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.


// CMStepCounter - number of steps
// CMMotionActivityManager - gets motion data (walking/running/vehicle/stationary)
// CMMotionManager - magnetic field, acceleration, gyro data (rotation rate), devicemotion (attitude, rotationrate, acceleration, magneticfield)
// CMPedometer (iOS 8.0) - number of steps, distance, floors (1 floor ~= 3 meters)
// CMAltimeter (iOS 8.0) - change in current altitude
// CMAttitude - rotation matrix/quaternion/euler angles of orientation

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var steplabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var confidenceBar: UIProgressView!
    @IBOutlet weak var xaccelLabel: UILabel!
    @IBOutlet weak var yaccelLabel: UILabel!
    @IBOutlet weak var zaccelLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    var stepCount:Int!
    var prevSteps:Int!
    var activitystring:String!
    var confidencenum:Float! = 0
    var altitudeNum:Float! = 0
    var vAcc:Float! = 0
    var speedNum:Double! = 0
    var motionManager = CMMotionManager()
    var clManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stepCount = 0
        getHistoricalSteps()
        updateSteps()
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateStepLabel"), userInfo: nil, repeats: true)
        //clManager.requestAlwaysAuthorization()
        clManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        clManager.startUpdatingLocation()
        clManager.delegate = self
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
            })
        }
        
        if (CMMotionActivityManager.isActivityAvailable()) {
            var activityManager = CMMotionActivityManager()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            
            activityManager.startActivityUpdatesToQueue(mainQueue, withHandler: { activity in
                if (self.activityToString(activity) != "") {
                    self.activitystring = self.activityToString(activity)
                    self.confidencenum = Float(activity.confidence.toRaw())
                }
            })
        }
        
        motionManager.accelerometerUpdateInterval = 0.1
        if (motionManager.accelerometerAvailable) {
            motionManager.startAccelerometerUpdates()
        }
    }
    
    func updateStepLabel() {
        steplabel.text = "\(stepCount)"
        activityLabel.text = activitystring
        confidenceBar.progress = confidencenum / 2
        var acc = motionManager.accelerometerData.acceleration
        xaccelLabel.text = NSString(format: "%.4f m/s^2", acc.x * 9.81)
        yaccelLabel.text = NSString(format: "%.4f m/s^2", acc.y * 9.81)
        zaccelLabel.text = NSString(format: "%.4f m/s^2", acc.z * 9.81)
        altitudeLabel.text = NSString(format: "%.2f m +/- %.2f", altitudeNum, vAcc)
        speedLabel.text = NSString(format: "%.2f m/s", speedNum)
        //println(clManager.location.altitude)
        
    }
    
    func activityToString(act:CMMotionActivity) -> String {
        var actionName = ""
        
        if (act.unknown) { actionName += "Unknown " }
        if (act.stationary) { actionName += "Stationary " }
        if (act.walking) { actionName += "Walking " }
        if (act.running) { actionName += "Running " }
        if (act.automotive) { actionName += "Automotive " }
        
        return actionName
    }
    
    //今日の０時０分を取得
    func startDateOfToday() -> NSDate! {
        var calender = NSCalendar.currentCalendar()
        var components = calender.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
        return calender.dateFromComponents(components)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var loc: AnyObject = locations[locations.count-1]
        altitudeNum = Float(loc.altitude)
        vAcc = Float(loc.verticalAccuracy)
        speedNum = loc.speed
        println(altitudeNum)
        println(speedNum)
    }
}

