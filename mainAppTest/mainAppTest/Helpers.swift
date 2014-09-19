//
//  Helpers.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/19.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import Foundation

// http://ios-blog.co.uk/tutorials/check-if-active-internet-connection-exists-on-ios-device/
func isConnectedToInternet() -> Bool {
    var url = NSURL.URLWithString("http://tekugame.mxd.media.ritsumei.ac.jp/json/playerandlocation.json")
    var error:NSErrorPointer = nil
    var data = NSData.dataWithContentsOfURL(url, options: NSDataReadingOptions.DataReadingUncached, error: error)
    if ((data) != nil) {
        return true
    }
    return false
}

// General posting function.
func post(urlstring:String!, querystring:String!) {
    var url = NSURL.URLWithString(urlstring) // URL object from URL string.
    var request = NSMutableURLRequest(URL: url) // Request.
    request.HTTPMethod = "POST" // Could be POST or GET.
    
    // Post has HTTPBody.
    var strData = querystring.dataUsingEncoding(NSUTF8StringEncoding)
    request.HTTPBody = strData
    request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
    request.setValue("gzip,deflate,sdch", forHTTPHeaderField: "Accept-Encoding")
    request.setValue("ja,en-US;q=0.8,en;q=0.6", forHTTPHeaderField: "Accept-Language")
    request.setValue("tekugame.mxd.media.ritsumei.ac.jp", forHTTPHeaderField: "Host")
    
    // Values returned from server.
    var response: NSURLResponse? = nil
    var error: NSError? = nil
    
    NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
}

func getJSON(urlstring:String!) -> [NSDictionary]? {
    var jsonData = NSData(contentsOfURL: NSURL(string: urlstring))
    var error: NSError?
    var jsObj = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &error) as [NSDictionary]?
    return jsObj
}

// For testing.
func returnTimeStampString() -> String! {
    var calendar = NSCalendar.currentCalendar()
    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond | .CalendarUnitTimeZone, fromDate: NSDate())
    var dtimestring = "\(components.year)-\(addZero(components.month))-\(addZero(components.day))T\(addZero(components.hour)):\(addZero(components.minute)):\(addZero(components.second))+09:00"
    return dtimestring
}

func returnDateString() -> String! {
    var calendar = NSCalendar.currentCalendar()
    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
    var datestring = "\(components.year)-\(addZero(components.month))-\(addZero(components.day))"
    return datestring
}

func addZero(num:Int!) -> String! {
    return (num < 10) ? "0\(num)" : "\(num)"
}

func postLog(message:String!) {
    if (isConnectedToInternet()) {
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playtestForm/"
        var timestamp = returnTimeStampString()
        var prefs = NSUserDefaults.standardUserDefaults()
        var currentuser = prefs.objectForKey("currentuser") as String!
        var query = "playerID=\(currentuser)&time=\(timestamp)&message=\(message)&submit=submit"
        post(urlstring, query)
    }
//    println(message)
}

func getPlayerStats() {
    var prefs = NSUserDefaults.standardUserDefaults()
    var currentuser = prefs.objectForKey("currentuser") as String
    var versionstr:NSString = UIDevice.currentDevice().systemVersion
    var versiondouble = versionstr.doubleValue
    
    if (versiondouble >= 8.0 || prefs.objectForKey("playerStats") == nil) {
        var jsObj = getJSON("http://tekugame.mxd.media.ritsumei.ac.jp/json/playerdata.json")
        if (jsObj != nil) {
            for data in jsObj! {
                var username = data["ID"] as String
                if (currentuser == username) {
                    var levelstr = data["level"] as NSString
                    var healthstr = data["health"] as NSString
                    var strengthstr = data["strength"] as NSString
                    var magicstr = data["magic"] as NSString
                    var speedstr = data["speed"] as NSString
                    var pointsstr = data["points"] as NSString
                    var experiencestr = data["experience"] as NSString
                    var speedProgressstr = data["speedProgress"] as NSString
                    var enemiesDefeatedstr = data["enemiesDefeated"] as NSString
                    var magicHourstr = data["magicHour"] as NSString
                    var magicStepsstr = data["magicSteps"] as NSString
                    var date = data["date"] as String
                    var healthGoalstr = data["healthGoal"] as NSString
                    var strengthGoalstr = data["strengthGoal"] as NSString
                    var magicGoalstr = data["magicGoal"] as NSString
                    var enemyStepCountstr = data["enemyStepCount"] as NSString
                    
                    var level:Int = Int(levelstr.doubleValue)
                    var health:Int = Int(healthstr.doubleValue)
                    var strength:Int = Int(strengthstr.doubleValue)
                    var magic:Int = Int(magicstr.doubleValue)
                    var speed:Int = Int(speedstr.doubleValue)
                    var points:Int = Int(pointsstr.doubleValue)
                    var experience:Int = Int(experiencestr.doubleValue)
                    var speedProgress:Float = Float(speedProgressstr.doubleValue)
                    var enemiesDefeated:Int = Int(enemiesDefeatedstr.doubleValue)
                    var magicHour:Int = Int(magicHourstr.doubleValue)
                    var magicSteps:Int = Int(magicStepsstr.doubleValue)
                    var healthGoal:Int = Int(healthGoalstr.doubleValue)
                    var strengthGoal:Int = Int(strengthGoalstr.doubleValue)
                    var magicGoal:Int = Int(magicGoalstr.doubleValue)
                    var enemyStepCount:Int = Int(enemyStepCountstr.doubleValue)
                    
                    var plStats:[String:[String:AnyObject]] = [:]
                    var stats = ["level": level, "health":health, "strength":strength, "magic":magic, "speed":speed, "assignpoints":points, "exp":experience, "speedProgress":speedProgress, "enemiesDefeated":enemiesDefeated, "magicHour":magicHour, "magicSteps":magicSteps, "date":date, "healthGoal":healthGoal, "strengthGoal":strengthGoal, "magicGoal":magicGoal, "enemyStepCount":enemyStepCount] as [String:AnyObject]
                    plStats[currentuser] = stats
                    prefs.setObject(plStats, forKey: "playerStats")
                    break
                }
            }
        }
        else {
            println("probably no internet")
        }
    }
}

func postPlayerStats() {
    var prefs = NSUserDefaults.standardUserDefaults()
    if (prefs.objectForKey("currentuser") != nil) {
        var playerID = prefs.objectForKey("currentuser") as String
        var plStats = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        var level = plStats[playerID]!["level"]! as Int
        var health = plStats[playerID]!["health"]! as Int
        var strength = plStats[playerID]!["strength"]! as Int
        var magic = plStats[playerID]!["magic"]! as Int
        var speed = plStats[playerID]!["speed"]! as Int
        var points = plStats[playerID]!["assignpoints"]! as Int
        var exp = plStats[playerID]!["exp"]! as Int
        var speedProgress = plStats[playerID]!["speedProgress"]! as Float
        var enemiesDefeated = plStats[playerID]!["enemiesDefeated"]! as Int
        var magicHour = plStats[playerID]!["magicHour"]! as Int
        var magicSteps = plStats[playerID]!["magicSteps"]! as Int
        var date = plStats[playerID]!["date"]! as String
        var healthGoal = plStats[playerID]!["healthGoal"]! as Int
        var strengthGoal = plStats[playerID]!["strengthGoal"]! as Int
        var magicGoal = plStats[playerID]!["magicGoal"]! as Int
        var enemyStepCount = plStats[playerID]!["enemyStepCount"]! as Int
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playerdataForm/"
        var str = "ID=\(playerID)&level=\(level)&health=\(health)&strength=\(strength)&magic=\(magic)&speed=\(speed)&points=\(points)&experience=\(exp)&speedProgress=\(speedProgress)&enemiesDefeated=\(enemiesDefeated)&magicHour=\(magicHour)&magicSteps=\(magicSteps)&date=\(date)&healthGoal=\(healthGoal)&strengthGoal=\(strengthGoal)&magicGoal=\(magicGoal)&enemyStepCount=\(enemyStepCount)&submit=submit"
        post(urlstring, str)
    }
}

func updateEncounterStep(inout stepcount:Int, m7steps:Int) {
    var thousands = lroundf(Float(m7steps) / 1000.0) + 1
    stepcount = Int(thousands) * 1000 + Int(arc4random_uniform(200)) - 100
    var appdel:AppDelegate = (UIApplication.sharedApplication().delegate) as AppDelegate
    appdel.encounterstep = stepcount
}


func updateLocalPlayerStats(healthinc:Int, strengthinc:Int, magicinc:Int, speedinc:Int, inout stats:[String:[String:AnyObject]]) {
    
    var prefs = NSUserDefaults.standardUserDefaults()
    var playerID = prefs.objectForKey("currentuser") as String
    
    var health:Int = stats[playerID]!["health"]! as Int
    var strength:Int = stats[playerID]!["strength"]! as Int
    var magic:Int = stats[playerID]!["magic"]! as Int
    var speed:Int = stats[playerID]!["speed"]! as Int
    stats[playerID]!["health"]! = health+healthinc
    stats[playerID]!["strength"]! = strength+strengthinc
    stats[playerID]!["magic"]! = magic+magicinc
    stats[playerID]!["speed"]! = speed+speedinc
    
    prefs.setObject(stats, forKey: "playerStats")
    
    postLog("My current stats after updating are Health: \(health+healthinc), Strength: \(strength+strengthinc), Magic: \(magic+magicinc), Speed: \(speed+speedinc)")
}

