//
//  AppDelegate.swift
//  Errant
//
//  Created by Stefan Alexander (@stefafafan) on 2014/08/18.
//  Copyright 2014 Stefan Alexander (@stefafafan).
//  Last Modified 2014/10/01.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /* Appdelegate member variables. */
    
    // Magic related variables.
    var prevmagicsteps:Int! = -1
    var magicsteps:Int! = -1
    var magicHourInt:Int! = -1
    var currentHourInt:Int! = -1
    var magicGoal:Int = 0
    
    // Speed related variables.
    var activitystring:String! = ""
    var confidencenum:Float! = 0
    var speedFloat:Float = 0
    
    // Health related variables.
    var healthGoal:Int = 0
    
    // Player stats related variables.
    var playerID = ""
    var prefs = NSUserDefaults.standardUserDefaults()
    var plStats:[String:[String:AnyObject]] = [:]
    
    // Other variables.
    var window: UIWindow?
    var prevSteps:Int! = 0
    var stepCount:Int! = 0
    var encounterstep:Int! = 0
    var notified:Bool! = false
    var loop:NSTimer!
    var statusloop:NSTimer!
    
    /* Function definitions. */
    
    /* After application launch. */
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Provide API Key in order to use Google Maps SDK for iOS.
        GMSServices.provideAPIKey("AIzaSyDIKiPrsh793BEv91Ms6qREgeZS0pcDtw8")
        return true
    }
    
    /* Application is about to move from active to inactive state. */
    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    /* Application entered background. */
    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // Once application goes into background, get ready to notify player.
        notified = false
        
        // Get the historical number of steps of the day and store it to the local variable.
        getHistoricalSteps({numberOfSteps, error in self.prevSteps = numberOfSteps})
        
        // Handler used to update the number of steps/magic steps.
        var stepsHandler:(Int, NSDate!, NSError!) -> Void = { numberOfSteps, timestamp, error in
            self.stepCount = numberOfSteps + self.prevSteps
            self.magicsteps = self.prevmagicsteps
            if (self.currentHourInt == self.magicHourInt) {
                self.magicsteps = self.prevmagicsteps + numberOfSteps
            }
        }
        
        // Handler used to update activity string.
        var activityHandler:(CMMotionActivity!) -> Void = { activity in
            if (activityToString(activity) != "") {
                self.activitystring = activityToString(activity)
                self.confidencenum = Float(activity.confidence.toRaw())
            }
        }
        
        // Start updating steps with the handlers.
        updateSteps(stepsHandler, activityHandler)
        
        // Get the player stats from NSUserDefaults and store to a local variable.
        playerID = prefs.objectForKey("currentuser") as String
        plStats = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        
        // Start the loops for notifying the player and checking the player's status.
        UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
        loop = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("notifySteps"), userInfo: nil, repeats: true)
        statusloop = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("checkStatus"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(loop, forMode: NSRunLoopCommonModes)
        NSRunLoop.currentRunLoop().addTimer(statusloop, forMode: NSRunLoopCommonModes)
        
        // Post the player stats to the server for backup.
        postPlayerStats()
    }
    
    /* Transition from the background to the inactive state */
    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    /* Application became active. */
    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // When becoming active, stop the loops.
        if (loop != nil) {
            loop.invalidate()
            loop = nil
        }
        if (statusloop != nil) {
            statusloop.invalidate()
            statusloop = nil
        }
    }
    
    /* Before application terminates. */
    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // Post the player stats before the app terminates.
        postPlayerStats()
    }
    
    /* Check the different statuses of the player, called every two seconds by applicationDidEnterBackground. */
    func checkStatus() {
        checkRunningGoal()
        checkHealthGoal()
        checkMagicHour()
    }
    
    /* Checks whether or not the player met the health goal and increments corresponding values. */
    func checkHealthGoal() {
        
        // If the health goal is not set, retrieve the health goal from the player dictionary.
        if (healthGoal == 0) {
            healthGoal = plStats[playerID]!["healthGoal"]! as Int
        }
        
        // If the player's step count exceeds the health goal, update the health goal, increment the player's health values, and notify the user.
        if (stepCount >= healthGoal) {
            
            // Update health goal.
            healthGoal += 5000
            plStats[playerID]!["healthGoal"]! = healthGoal
            prefs.setObject(plStats, forKey: "playerStats")
            
            // Debug.
            postLog("Walked \(stepCount) steps today, health incremented by 1.(background)")
            
            // Update stats.
            updateLocalPlayerStats(1, 0, 0, 0, &plStats)
            
            // Notify the player from the background (dispatch needed when sending the notification).
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Health from walking \(self.stepCount) steps!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
        }
    }
    
    /* Checks whether or not the player met the speed goal and increments corresponding values. */
    func checkRunningGoal() {
        
        // Increment speed progress only when the Core Motion API says the activity is "Running" and the confidence is Medium~High.
        if (activitystring.rangeOfString("Running") != nil && (confidencenum == Float(CMMotionActivityConfidence.High.toRaw()) || confidencenum == Float(CMMotionActivityConfidence.Medium.toRaw()))) {
            speedFloat += 0.01
        }
        
        // If the player's speed progress exceeds the speed goal, update the speed goal, increment the player's speed values, and notify the user.
        if (speedFloat >= 1) {
            // Update speed goal.
            speedFloat = 0
            plStats[playerID]!["speedProgress"]! = speedFloat
            prefs.setObject(plStats, forKey: "playerStats")
            
            // Debug.
            postLog("Speed incremented by 1 from running.(background)")
            
            // Update stats.
            updateLocalPlayerStats(0, 0, 0, 1, &plStats)
            
            // Notify the player from the background (dispatch needed when sending the notification).
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Speed from running!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
        }
    }
    
    /* Checks whether or not the player met the magic goal and increments corresponding values. */
    func checkMagicHour() {
        
        // Retrieve the magic hour and the date corresponding to the magic hour.
        magicHourInt = plStats[playerID]!["magicHour"]! as Int
        var magicDate = plStats[playerID]!["date"]! as String
        
        // If the magic date is not equal to the current date, update the values that need to be updated for the next day.
        if (magicDate != returnDateString()) {
            
            // Magic steps will be reset to 0, a new random hour between 8~24 will be chosen for magic hour.
            magicsteps = 0
            magicHourInt = Int(arc4random_uniform(16)) + 8
            
            // The new magic values as well as the health goal and date will be stored to the NSUserDefaults.
            plStats[playerID]!["healthGoal"]! = 5000
            plStats[playerID]!["magicGoal"]! = 1000
            plStats[playerID]!["magicHour"]! = magicHourInt
            plStats[playerID]!["magicSteps"]! = 0
            plStats[playerID]!["date"]! = returnDateString()
            prefs.setObject(plStats, forKey: "playerStats")
        }
        
        // If the magic goal is not set, retrieve the magic goal from the player dictionary.
        if (magicGoal == 0) {
            magicGoal = plStats[playerID]!["magicGoal"]! as Int
        }
        
        // If the player's magic steps exceeds the magic goal, update the health goal, increment the player's health values, and notify the user.
        if (magicsteps >= magicGoal) {
            
            // Update the magic goal.
            magicGoal += 1000
            plStats[playerID]!["magicGoal"]! = magicGoal
            prefs.setObject(plStats, forKey: "playerStats")
            
            // Debug.
            postLog("Walked \(magicsteps) steps during magic hour (\(magicHourInt):00). Magic incremented by 1.(background)")
            
            // Update stats.
            updateLocalPlayerStats(0, 0, 1, 0, &plStats)
            
            // Notify the player from the background (dispatch needed when sending the notification).
            var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
            dispatch_async(lowQueue, { () -> Void in
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "+1 Magic from walking \(self.magicsteps) steps during magic hour!"
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            })
        }
    }
    
    /* Checks whether or not the player encountered a monster and notifies the player. Called every second by applicationDidEnterBackground. */
    func notifySteps() {
        
        // Notification needs to be done with dispatch.
        var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        
        dispatch_async(lowQueue, { () -> Void in
            
            // If not notified (to avoid multiple notifications), and encounter step is not 0 and the player passed the encounter step, notify.
            if (!self.notified && self.encounterstep != 0 && self.stepCount >= self.encounterstep) {
                var notification = UILocalNotification()
                notification.fireDate = NSDate()
                notification.alertBody = "You've encountered a monster."
                println("You've encountered a monster.")
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                self.notified = true
            }
        })
        
    }
}
