//
//  Helpers.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/19.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import Foundation
import CoreMotion

func isConnectedToInternet() -> Bool {
    var networkReachability:Reachability = Reachability.reachabilityForInternetConnection()
    var networkStatus:NetworkStatus = networkReachability.currentReachabilityStatus()
    
    return (networkStatus.value != NotReachable.value)
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

func getJSON(urlstring:String!) -> [[String:AnyObject]]? {
    var jsonData = NSData(contentsOfURL: NSURL(string: urlstring)) as NSData?
    if (jsonData != nil) {
        var error: NSError?
        var jsObj = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as [[String:AnyObject]]?
        return jsObj
    }
    return nil
}

// For testing.
func returnTimeStampString() -> String! {
    var calendar = NSCalendar.currentCalendar()
    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond | .CalendarUnitTimeZone, fromDate: NSDate())
    var dtimestring = "\(components.year)-\(addZero(components.month))-\(addZero(components.day))T\(addZero(components.hour)):\(addZero(components.minute)):\(addZero(components.second))"
    return dtimestring
}

func returnDateString() -> String! {
    var calendar = NSCalendar.currentCalendar()
    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
    var datestring = "\(components.year)-\(addZero(components.month))-\(addZero(components.day))"
    return datestring
}

// Returns an NSDate object of the beginning of the day.
func startDateOfToday() -> NSDate! {
    var calender = NSCalendar.currentCalendar()
    var components = calender.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
    return calender.dateFromComponents(components)
}

func addZero(num:Int!) -> String! {
    return (num < 10) ? "0\(num)" : "\(num)"
}

func returnDateDifferenceString(datestring:String) -> String {
    
    if (datestring == "0000-00-00 00:00:00") {
        return "Last logged in - ago."
    }
    
    var format = NSDateFormatter()
    format.timeStyle = NSDateFormatterStyle.NoStyle
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var d = format.dateFromString(datestring)
    var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
    var components = calendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate: d!, toDate: NSDate(), options: NSCalendarOptions.allZeros)
    
    var returnstring = "Last logged in "
    
    if (components.year > 0) {
        returnstring += "\(components.year)" + ((components.year == 1) ? " year" : " years")
    }
    else if (components.month > 0) {
        returnstring += "\(components.month)" + ((components.month == 1) ? " month" : " months")
    }
    else if (components.day > 0) {
        returnstring += "\(components.day)" + ((components.day == 1) ? " day" : " days")
    }
    else if (components.hour > 0 || components.minute > 0)  {
        returnstring += (components.hour > 0) ? "\(components.hour)" + ((components.hour == 1) ? " hour" : " hours") : ""
        returnstring += (components.hour > 0 && components.minute > 0) ? " and " : ""
        returnstring += (components.minute > 0) ? "\(components.minute)" + ((components.minute == 1) ? " minute" : " minutes") : ""
    }
    else {
        returnstring += "\(components.second)" + ((components.second == 1) ? " second" : " seconds")
    }
    
    returnstring += " ago."
    
    return returnstring
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

func getPlayerStats() -> [String:[String:AnyObject]]? {
    var prefs = NSUserDefaults.standardUserDefaults()
    var currentuser = prefs.objectForKey("currentuser") as String
    var versionstr:NSString = UIDevice.currentDevice().systemVersion
    var versiondouble = versionstr.doubleValue
    
    if (versiondouble >= 8.0 || prefs.objectForKey("playerStats") == nil) {
        var jsObj = getJSON("http://tekugame.mxd.media.ritsumei.ac.jp/json/playerdata.json") as [[String:AnyObject]]?
        if (jsObj != nil) {
            for data in jsObj! {
                var username:String = data["ID"] as NSString
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
                    var date = data["date"] as NSString
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
                    return plStats
                }
            }
        }
    }
    else if (prefs.objectForKey("playerStats") != nil) {
        var plStats:[String:[String:AnyObject]] = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        return plStats
    }
    return nil
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

func postPlayerLocation(playerID:String!, beaconID:String!, myview:GMSMapView!) {
    if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
        var lat = myview.myLocation.coordinate.latitude
        var long = myview.myLocation.coordinate.longitude
        var timestamp = returnTimeStampString()
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/form/index.php"
        var str = "phone=\(playerID!)&beacon=\(beaconID!)&longitude=\(long)&latitude=\(lat)&date=\(timestamp)&submit=submit"
        post(urlstring, str)
    }
}

func postToBattles(battleID:String!, enemAttack:String!, enemTarget:String!, playAttack:String!, turn:String!, currentPlayer:String!, status:String!) {
    
    var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/battleForm/index.php"
    var str = "ID=\(battleID)&lastEnemyAttack=\(enemAttack)&lastPlayerAttack=\(playAttack)&turnPlayerID=\(turn)&status=\(status)&enemyTargetID=\(enemTarget)&currentPlayerID=\(currentPlayer)&submit=submit"
    post(urlstring, str)
}

func postPlayersInBattle(pid:String!, bid:String!) {
    var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playersinbattle/index.php"
    var str = "playerID=\(pid)&battleID=\(bid)&submit=submit"
    post(urlstring, str)
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

func positionMap(inout mainview:UIView!, inout myview:GMSMapView!, lat:CLLocationDegrees, long:CLLocationDegrees, zoom:Float) {
    var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: zoom)
    myview = GMSMapView(frame: mainview.bounds)
    myview.camera = camera
    myview.myLocationEnabled = true
    myview.buildingsEnabled = false
    myview.indoorEnabled = false
    
    mainview.addSubview(myview)
}

func setMarker(inout myview:GMSMapView!, lat:CLLocationDegrees, long:CLLocationDegrees, title:String, text:String, color:UIColor) -> GMSMarker {
    var marker:GMSMarker = GMSMarker(position: CLLocationCoordinate2DMake(lat, long))
    var tintedicon:UIImage = GMSMarker.markerImageWithColor(color)
    marker.title = title
    marker.snippet = text
    marker.icon = tintedicon
    marker.map = myview
    return marker
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

// Gets the number of steps taken from the start of the day to the current time.
func getHistoricalSteps(handler:(Int, NSError!) -> Void) {
    if(CMStepCounter.isStepCountingAvailable()){
        var stepCounter = CMStepCounter()
        var mainQueue:NSOperationQueue! = NSOperationQueue()
        var todate:NSDate! = NSDate()
        var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        
        dispatch_async(lowQueue, { () -> Void in
            stepCounter.queryStepCountStartingFrom(startDateOfToday(), to: todate, toQueue: mainQueue, withHandler: handler)
        })
    }
}

//     Starts counting the number of steps.
func updateSteps(stepHandler:(Int, NSDate!, NSError!) -> Void, activityHandler: (CMMotionActivity!) -> Void) {
    var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    var mainQueue:NSOperationQueue! = NSOperationQueue()
    
    if(CMStepCounter.isStepCountingAvailable()){
        var stepCounter = CMStepCounter()
        var todate:NSDate! = NSDate()
        
        dispatch_async(lowQueue, { () -> Void in
          stepCounter.startStepCountingUpdatesToQueue(mainQueue, updateOn: 1, withHandler: stepHandler)
        })
    }
    
    if (CMMotionActivityManager.isActivityAvailable()) {
        var activityManager = CMMotionActivityManager()
        
        dispatch_async(lowQueue, { () -> Void in
            activityManager.startActivityUpdatesToQueue(mainQueue, withHandler: activityHandler)
        })
    }
}
