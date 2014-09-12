//
//  AppDelegate.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/18.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var prevSteps:Int! = 0
    var stepCount:Int! = 0
    var encounterstep:Int! = 0
    var notified:Bool! = false
    var loop:NSTimer!
    var statusloop:NSTimer!
    
    // Magic
    var prevmagicsteps:Int! = -1
    var magicsteps:Int! = -1
    var magicHourInt:Int! = -1
    var currentHourInt:Int! = -1
    var magicGoal:Int = 0
    
    
    // Speed
    var activitystring:String! = ""
    var confidencenum:Float! = 0
    var speedFloat:Float = 0
    
    // Health
    var healthGoal:Int = 0
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDFOvhUM0waJCJjdypGwPd7gNu4C42XwGg")
//        DeployGateSDK.sharedInstance().launchApplicationWithAuthor("stefafafan", key: "3bf3b368dca9edd3fcfbbc5a75248c22fe775d0e")
        return true
    }
    
    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        var prefs = NSUserDefaults.standardUserDefaults()
        
        var currDate = NSDate()
        var gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var dateComponents = gregorian.components(NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: currDate)
        currentHourInt = dateComponents.hour
        
        
//        if (prefs.objectForKey("magicSteps") != nil) {
//            prevmagicsteps = prefs.objectForKey("magicSteps") as Int
//            var magic = prefs.objectForKey("magichour") as [String:String]
//            magicHourInt = magic["hour"]!.toInt()!
//        }
        
        if (prefs.objectForKey("speedFloat") != nil) {
            speedFloat = prefs.objectForKey("speedFloat") as Float
        }
        else {
            speedFloat = 0
            prefs.setObject(0, forKey: "speedFloat")
        }
        
        if (prefs.objectForKey("magicSteps") != nil) {
            prevmagicsteps = prefs.objectForKey("magicSteps") as Int
            magicsteps = prevmagicsteps
        }
        
        notified = false
        getHistoricalSteps()
        updateSteps()
        
        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
        loop = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("notifySteps"), userInfo: nil, repeats: true)
        statusloop = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkStatus"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(loop, forMode: NSRunLoopCommonModes)
        NSRunLoop.currentRunLoop().addTimer(statusloop, forMode: NSRunLoopCommonModes)
    }
    
    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (loop != nil) {
            loop.invalidate()
            loop = nil
        }
        if (statusloop != nil) {
            statusloop.invalidate()
            statusloop = nil
        }
    }
    
    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Gets the number of steps taken from the start of the day to the current time.
    func getHistoricalSteps() {
        if(CMStepCounter.isStepCountingAvailable()){
            var stepCounter = CMStepCounter()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            var todate:NSDate! = NSDate()
            
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            
            dispatch_async(lowQueue, { () -> Void in
                stepCounter.queryStepCountStartingFrom(self.startDateOfToday(), to: todate, toQueue: mainQueue, withHandler: {numberOfSteps, error in
                    self.prevSteps = numberOfSteps
                })
            })
        }
    }
    
    // Starts counting the number of steps.
    func updateSteps() {
        
        if(CMStepCounter.isStepCountingAvailable()){
            var stepCounter = CMStepCounter()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            var todate:NSDate! = NSDate()
            
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            
            dispatch_async(lowQueue, { () -> Void in
                stepCounter.startStepCountingUpdatesToQueue(mainQueue, updateOn: 1, withHandler: {numberOfSteps, timestamp, error in
                    self.stepCount = numberOfSteps + self.prevSteps
                    self.magicsteps = self.prevmagicsteps
                    if (self.currentHourInt == self.magicHourInt) {
                        self.magicsteps = self.prevmagicsteps + numberOfSteps
                    }
                })
            })
        }
        
        if (CMMotionActivityManager.isActivityAvailable()) {
            var activityManager = CMMotionActivityManager()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            
            dispatch_async(lowQueue, { () -> Void in
                activityManager.startActivityUpdatesToQueue(mainQueue, withHandler: { activity in
                    if (self.activityToString(activity) != "") {
                        self.activitystring = self.activityToString(activity)
                        self.confidencenum = Float(activity.confidence.toRaw())
                    }
                })
            })
        }
    }
    
    func checkStatus() {
        checkRunningGoal()
        checkHealthGoal()
        checkMagicHour()
    }
    
    func checkHealthGoal() {
        var prefs = NSUserDefaults.standardUserDefaults()
        if (stepCount >= 5000 && prefs.objectForKey("healthGoal") != nil) {
            healthGoal = prefs.objectForKey("healthGoal") as Int
        }
        else {
            healthGoal = 5000
            prefs.setObject(healthGoal, forKey: "healthGoal")
        }
        
        if (stepCount >= healthGoal) {
            healthGoal += 5000
            prefs.setObject(healthGoal, forKey: "healthGoal")
            println("StepCount: \(stepCount), healthGoal: \(healthGoal)")
            postLog("Walked \(stepCount) steps today, health incremented by 1.")
            updateLocalPlayerStats(1, strengthinc: 0, magicinc: 0, speedinc: 0)
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Health from walking \(self.stepCount) steps!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
//            notifyMessage("+1 Health from walking \(self.stepCount) steps!")
        }
    }
    
    func checkRunningGoal() {
        if (activitystring.rangeOfString("Running") != nil && (confidencenum == Float(CMMotionActivityConfidence.High.toRaw()) || confidencenum == Float(CMMotionActivityConfidence.Medium.toRaw()))) {
            speedFloat += 0.01
        }
        
        if (speedFloat >= 1) {
            speedFloat = 0
            var prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(0, forKey: "speedFloat")
            postLog("Speed incremented by 1 from running.")
            updateLocalPlayerStats(0, strengthinc: 0, magicinc: 0, speedinc: 1)
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Speed from running!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
//            notifyMessage("+1 Speed from running!")
        }
    }
    
    func checkMagicHour() {
        var prefs = NSUserDefaults.standardUserDefaults()
        var currDate = NSDate()
        var gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var dateComponents = gregorian.components(NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.YearCalendarUnit, fromDate: currDate)
        currentHourInt = dateComponents.hour
        
        if (prefs.objectForKey("magichour") != nil) {
            var magichour = prefs.objectForKey("magichour") as [String:String]
            if (magichour["date"]  == "\(dateComponents.month) / \(dateComponents.day) / \(dateComponents.year)") {
                var hour = magichour["hour"]!
                magicHourInt = hour.toInt()!
            }
            else {
                magichour["date"] = "\(dateComponents.month) / \(dateComponents.day) / \(dateComponents.year)"
                magichour["hour"] = "\(Int(arc4random_uniform(16)) + 8)"
                var hour = magichour["hour"]!
                magicHourInt = hour.toInt()!
                prefs.setObject(magichour, forKey: "magichour")
            }
        }
        else {
            var magichour:[String:String] = [:]
            magichour["date"] = "\(dateComponents.month) / \(dateComponents.day) / \(dateComponents.year)"
            magichour["hour"] = "\(Int(arc4random_uniform(16)) + 8)"
            var hour = magichour["hour"]!
            magicHourInt = hour.toInt()!
            prefs.setObject(magichour, forKey: "magichour")
        }
        
        if (magicsteps > 1000 && prefs.objectForKey("magicGoal") != nil) {
            magicGoal = prefs.objectForKey("magicGoal") as Int
        }
        else {
            magicGoal = 1000
            prefs.setObject(magicGoal, forKey: "magicGoal")
        }
        if (magicsteps >= magicGoal) {
            magicGoal += 1000
            prefs.setObject(magicGoal, forKey: "magicGoal")
            postLog("Walked \(magicsteps) steps during magic hour (\(magicHourInt):00). Magic incremented by 1.")
            updateLocalPlayerStats(0, strengthinc: 0, magicinc: 1, speedinc: 0)
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Magic from walking \(self.magicsteps) steps during magic hour!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
//            notifyMessage("+1 Magic from walking \(self.magicsteps) steps during magic hour!")
        }
    }
    
//    func notifyMessage(message:String) {
//        var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
//        dispatch_async(lowQueue, { () -> Void in
//            var notification = UILocalNotification()
//            notification.fireDate = NSDate()
//            notification.alertBody = message
//            UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        })
//    }
    
    func activityToString(act:CMMotionActivity) -> String {
        var actionName = ""
        
        if (act.unknown) { actionName += "Unknown " }
        if (act.stationary) { actionName += "Stationary " }
        if (act.walking) { actionName += "Walking " }
        if (act.running) { actionName += "Running " }
        if (act.automotive) { actionName += "Automotive " }
        
        return actionName
    }
    
    func updateLocalPlayerStats(healthinc:Int, strengthinc:Int, magicinc:Int, speedinc:Int) {
        
        var prefs = NSUserDefaults.standardUserDefaults()
        
        var plStats:[String:[String:Int]] = prefs.objectForKey("playerStats") as [String:[String:Int]]
        var playerID = prefs.objectForKey("currentuser") as String
        var health:Int = plStats[playerID]!["health"]!
        var strength:Int = plStats[playerID]!["strength"]!
        var magic:Int = plStats[playerID]!["magic"]!
        var speed:Int = plStats[playerID]!["speed"]!
        var assignpoints:Int = plStats[playerID]!["assignpoints"]!
        plStats[playerID]!["health"]! = health+healthinc
        plStats[playerID]!["strength"]! = strength+strengthinc
        plStats[playerID]!["magic"]! = magic+magicinc
        plStats[playerID]!["speed"]! = speed+speedinc
        
        prefs.setObject(plStats, forKey: "playerStats")
        
        postLog("My current stats after updating are Health: \(health), Strength: \(strength), Magic: \(magic), Speed: \(speed)")
    }
    
    func notifySteps() {
        
        var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        var prefs = NSUserDefaults.standardUserDefaults()
        
        dispatch_async(lowQueue, { () -> Void in
            if (self.magicHourInt != -1) {
                prefs.setObject(self.magicsteps, forKey: "magicSteps")
            }
            if (!self.notified && self.encounterstep != 0 && self.stepCount >= self.encounterstep) {
                self.notified = true
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "You've encountered a monster."
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
//                self.notifyMessage("You've encountered a monster.")
            }
        })
    }
    
    // Returns an NSDate object of the beginning of the day.
    func startDateOfToday() -> NSDate! {
        var calender = NSCalendar.currentCalendar()
        var components = calender.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
        return calender.dateFromComponents(components)
    }
    
}


