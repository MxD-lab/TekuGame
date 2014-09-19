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
    
    var playerID = ""
    var prefs = NSUserDefaults.standardUserDefaults()
    var plStats:[String:[String:AnyObject]] = [:]
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyAcMAlCJrkf-u4GG1jB5iPXNGs1FTC2kac")
//        DeployGateSDK.sharedInstance().launchApplicationWithAuthor("stefafafan", key: "3bf3b368dca9edd3fcfbbc5a75248c22fe775d0e")
        return true
    }
    
    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        postLog("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        
        notified = false
        getHistoricalSteps()
        updateSteps()
        
        playerID = prefs.objectForKey("currentuser") as String
        plStats = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        
        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
        loop = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("notifySteps"), userInfo: nil, repeats: true)
        statusloop = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkStatus"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(loop, forMode: NSRunLoopCommonModes)
        NSRunLoop.currentRunLoop().addTimer(statusloop, forMode: NSRunLoopCommonModes)
        postPlayerStats()
        postLog("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        postLog("applicationWillEnterForeground")
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
        
//        prefs.setObject(healthGoal, forKey: "healthGoal")
//        prefs.synchronize()
        
        postLog("applicationDidBecomeActive")
    }
    
    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        postPlayerStats()
        postLog("applicationWillTerminate")
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
    // Change to:
    // func updateSteps(inout stepCount:Int, inout prevSteps:Int, inout magicsteps:Int, inout prevmagicsteps:Int, currentHourInt:Int, magicHourInt:Int, inout activitystring:String, inout confidencenum:Float) {
    // and move to Helpers.swift so that it could be used by both AppDelegate and MapViewController, maybe?
    // activityToString() will need to be in Helpers.swift as well.
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
    
//    func checkHealthGoal() {
//        if (prefs.objectForKey("healthGoal") == nil) {
//            healthGoal = 5000
//        }
//        
//        if (stepCount >= healthGoal) {
//            healthGoal += 5000
//
//            postLog("Walked \(stepCount) steps today, health incremented by 1.")
//            updateLocalPlayerStats(1, 0, 0, 0, &plStats)
//            
//            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
//            dispatch_async(lowQueue, { () -> Void in
//                var notification = UILocalNotification()
//                notification.fireDate = NSDate()
//                notification.alertBody = "+1 Health from walking \(self.stepCount) steps!"
//                UIApplication.sharedApplication().scheduleLocalNotification(notification)
//            })
//        }
//    }
    
    func checkHealthGoal() {
        
        if (healthGoal == 0) {
            healthGoal = plStats[playerID]!["healthGoal"]! as Int
        }
        
        if (stepCount >= healthGoal) {
            healthGoal += 5000
            plStats[playerID]!["healthGoal"]! = healthGoal
            prefs.setObject(plStats, forKey: "playerStats")
            postLog("Walked \(stepCount) steps today, health incremented by 1.")
            updateLocalPlayerStats(1, 0, 0, 0, &plStats)
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Health from walking \(self.stepCount) steps!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
        }
    }
    
//    func checkRunningGoal() {
//        if (activitystring.rangeOfString("Running") != nil && (confidencenum == Float(CMMotionActivityConfidence.High.toRaw()) || confidencenum == Float(CMMotionActivityConfidence.Medium.toRaw()))) {
//            speedFloat += 0.01
//            println("Speed Float: \(speedFloat)")
//        }
//        
//        if (speedFloat >= 1) {
//            println("SpeedFloat: \(speedFloat)")
//            speedFloat = 0
//            prefs.setObject(0, forKey: "speedFloat")
//            postLog("Speed incremented by 1 from running.")
//            updateLocalPlayerStats(0, 0, 0, 1, &plStats)
//            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
//            dispatch_async(lowQueue, { () -> Void in
//                var notification = UILocalNotification()
//                notification.fireDate = NSDate()
//                notification.alertBody = "+1 Speed from running!"
//                UIApplication.sharedApplication().scheduleLocalNotification(notification)
//            })
//        }
//    }
    
    func checkRunningGoal() {
        if (activitystring.rangeOfString("Running") != nil && (confidencenum == Float(CMMotionActivityConfidence.High.toRaw()) || confidencenum == Float(CMMotionActivityConfidence.Medium.toRaw()))) {
            speedFloat += 0.01
        }
        
        if (speedFloat >= 1) {
            speedFloat = 0
            plStats[playerID]!["speedProgress"]! = speedFloat
            prefs.setObject(plStats, forKey: "playerStats")
            postLog("Speed incremented by 1 from running.")
            updateLocalPlayerStats(0, 0, 0, 1, &plStats)
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Speed from running!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
        }
    }
    
//    func checkMagicHour() {
//        
//        var playerID = prefs.objectForKey("currentuser") as String
//        magicHourInt = plStats[playerID]!["magicHour"]! as Int
//        var magicDate = plStats[playerID]!["date"]! as String
//        
//        if (magicDate != returnDateString()) {
//            magicsteps = 0
//            magicHourInt = Int(arc4random_uniform(16)) + 8
//            plStats[playerID]!["magicHour"]! = magicHourInt
//            plStats[playerID]!["magicSteps"]! = 0
//            plStats[playerID]!["date"]! = returnDateString()
//            prefs.setObject(plStats, forKey: "playerStats")
//        }
//        
//        if (magicsteps > 1000 && prefs.objectForKey("magicGoal") != nil) {
//            magicGoal = prefs.objectForKey("magicGoal") as Int
//        }
//        else {
//            magicGoal = 1000
//            prefs.setObject(magicGoal, forKey: "magicGoal")
//        }
//        if (magicsteps >= magicGoal) {
//            
////            println("Magic Goal: \(magicGoal)")
//            
//            magicGoal += 1000
//            prefs.setObject(magicGoal, forKey: "magicGoal")
//            postLog("Walked \(magicsteps) steps during magic hour (\(magicHourInt):00). Magic incremented by 1.")
//            updateLocalPlayerStats(0, 0, 1, 0, &plStats)
//            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
//            dispatch_async(lowQueue, { () -> Void in
//                var notification = UILocalNotification()
//                notification.fireDate = NSDate()
//                notification.alertBody = "+1 Magic from walking \(self.magicsteps) steps during magic hour!"
//                UIApplication.sharedApplication().scheduleLocalNotification(notification)
//            })
//        }
//    }
    
    func checkMagicHour() {
        magicHourInt = plStats[playerID]!["magicHour"]! as Int
        var magicDate = plStats[playerID]!["date"]! as String
        
        if (magicDate != returnDateString()) {
            magicsteps = 0
            magicHourInt = Int(arc4random_uniform(16)) + 8
            plStats[playerID]!["magicHour"]! = magicHourInt
            plStats[playerID]!["magicSteps"]! = 0
            plStats[playerID]!["date"]! = returnDateString()
            prefs.setObject(plStats, forKey: "playerStats")
        }
        
        if (magicGoal == 0) {
            magicGoal = plStats[playerID]!["magicGoal"]! as Int
        }
        
        if (magicsteps >= magicGoal) {
            magicGoal += 1000
            plStats[playerID]!["magicGoal"]! = magicGoal
            prefs.setObject(plStats, forKey: "playerStats")
            postLog("Walked \(magicsteps) steps during magic hour (\(magicHourInt):00). Magic incremented by 1.")
            updateLocalPlayerStats(0, 0, 1, 0, &plStats)
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Magic from walking \(self.magicsteps) steps during magic hour!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
        }
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
    
    func notifySteps() {
        
        var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        
        dispatch_async(lowQueue, { () -> Void in
            if (self.magicHourInt != -1) {
                self.prefs.setObject(self.magicsteps, forKey: "magicSteps")
            }
            if (!self.notified && self.encounterstep != 0 && self.stepCount >= self.encounterstep) {
                self.notified = true
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "You've encountered a monster."
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
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


