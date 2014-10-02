//
//  Helpers.swift
//  Errant
//
//  Created by Stefan Alexander (@stefafafan) on 2014/08/19.
//  Copyright 2014 Stefan Alexander (@stefafafan).
//  Last Modified 2014/10/02.
//

import CoreMotion

/* Returns a boolean on whether or not the phone has internet connection (using Apple's Reachability script). */
func isConnectedToInternet() -> Bool {
    var networkReachability:Reachability = Reachability.reachabilityForInternetConnection()
    var networkStatus:NetworkStatus = networkReachability.currentReachabilityStatus()
    
    return (networkStatus.value != NotReachable.value)
}

/* Function used to post to a certain url with a query string. */
func post(urlstring:String!, querystring:String!) {
    var url = NSURL.URLWithString(urlstring)
    var request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    
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
    
    // The actual request.
    NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
}

/* Gets a JSON object and returns it as a dictionary, when unsuccessful returns nil. */
func getJSON(urlstring:String!) -> [[String:AnyObject]]? {
    // Get data as NSData?
    var jsonData = NSData(contentsOfURL: NSURL(string: urlstring)) as NSData?
    if (jsonData != nil) {
        var error: NSError?
        // Return object from JSON.
        var jsObj = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as [[String:AnyObject]]?
        return jsObj
    }
    return nil
}

/* Returns the DateTimeString, used for debugging. */
func returnTimeStampString() -> String! {
    var calendar = NSCalendar.currentCalendar()
    var components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond | .CalendarUnitTimeZone, fromDate: NSDate())
    var dtimestring = "\(components.year)-\(addZero(components.month))-\(addZero(components.day))T\(addZero(components.hour)):\(addZero(components.minute)):\(addZero(components.second))"
    return dtimestring
}

/* Returns the DateString, used mainly for identifying the change in date. */
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

/* Adds a zero to a one digit number, used by returnTimeStampString and returnDateString. */
func addZero(num:Int!) -> String! {
    return (num < 10) ? "0\(num)" : "\(num)"
}

/* Returns a string that describes when the user last logged in as a difference between log in time and the current time in a readable format. */
func returnDateDifferenceString(datestring:String) -> String {
    
    // If the user never logged in.
    if (datestring == "0000-00-00 00:00:00") {
        return "Last logged in - ago."
    }
    
    // Set the format for the date.
    var format = NSDateFormatter()
    format.timeStyle = NSDateFormatterStyle.NoStyle
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    // Set the date object from string.
    var d = format.dateFromString(datestring)
    var calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
    
    // Get the difference of the given date and the current date and store as a date component.
    var components = calendar.components(NSCalendarUnit.YearCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit, fromDate: d!, toDate: NSDate(), options: NSCalendarOptions.allZeros)
    
    // Start forming the return string.
    var returnstring = "Last logged in "
    
    // If difference is greater or equal to a year, "Last logged in n years ago."
    if (components.year > 0) {
        returnstring += "\(components.year)" + ((components.year == 1) ? " year" : " years")
    }
    // If difference is greater or equal to a month, "Last logged in n months ago."
    else if (components.month > 0) {
        returnstring += "\(components.month)" + ((components.month == 1) ? " month" : " months")
    }
    // If difference is greater or equal to a day, "Last logged in n days ago."
    else if (components.day > 0) {
        returnstring += "\(components.day)" + ((components.day == 1) ? " day" : " days")
    }
    // If difference is greater or equal to a hour/minute, "Last logged in n hours and m minutes ago."
    else if (components.hour > 0 || components.minute > 0)  {
        returnstring += (components.hour > 0) ? "\(components.hour)" + ((components.hour == 1) ? " hour" : " hours") : ""
        returnstring += (components.hour > 0 && components.minute > 0) ? " and " : ""
        returnstring += (components.minute > 0) ? "\(components.minute)" + ((components.minute == 1) ? " minute" : " minutes") : ""
    }
    // Else, "Last logged in n seconds ago."
    else {
        returnstring += "\(components.second)" + ((components.second == 1) ? " second" : " seconds")
    }
    
    returnstring += " ago."
    return returnstring
}

/* Posts debug messages to server with playerID, timestamp, and message. */
func postLog(message:String!) {
    if (isConnectedToInternet()) {
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playtestForm/"
        var timestamp = returnTimeStampString()
        var prefs = NSUserDefaults.standardUserDefaults()
        var currentuser = prefs.objectForKey("currentuser") as String!
        var query = "playerID=\(currentuser)&time=\(timestamp)&message=\(message)&submit=submit"
        post(urlstring, query)
    }
}

/* Gets the given user's stats from the database. */
func getPlayer(player:String) -> [String:AnyObject]? {
    
    // Get the JSON object.
    var jsObj = getJSON("http://tekugame.mxd.media.ritsumei.ac.jp/json/playerdata.json") as [[String:AnyObject]]?
    
    if (jsObj != nil) {
        
        // Iterate through each player.
        for data in jsObj! {
            var username:String = data["ID"] as NSString
            
            // Once the target player is found.
            if (player == username) {
                
                // Temporarily store each value as an NSString.
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
                
                // Convert to corresponding types.
                var level:Int = levelstr.integerValue
                var health:Int = healthstr.integerValue
                var strength:Int = strengthstr.integerValue
                var magic:Int = magicstr.integerValue
                var speed:Int = speedstr.integerValue
                var points:Int = pointsstr.integerValue
                var experience:Int = experiencestr.integerValue
                var speedProgress:Float = speedProgressstr.floatValue
                var enemiesDefeated:Int = enemiesDefeatedstr.integerValue
                var magicHour:Int = magicHourstr.integerValue
                var magicSteps:Int = magicStepsstr.integerValue
                var healthGoal:Int = healthGoalstr.integerValue
                var strengthGoal:Int = strengthGoalstr.integerValue
                var magicGoal:Int = magicGoalstr.integerValue
                var enemyStepCount:Int = enemyStepCountstr.integerValue
                
                // Store as a Dictionary and return.
                var stats = ["level": level, "health":health, "strength":strength, "magic":magic, "speed":speed, "assignpoints":points, "exp":experience, "speedProgress":speedProgress, "enemiesDefeated":enemiesDefeated, "magicHour":magicHour, "magicSteps":magicSteps, "date":date, "healthGoal":healthGoal, "strengthGoal":strengthGoal, "magicGoal":magicGoal, "enemyStepCount":enemyStepCount] as [String:AnyObject]
                return stats
            }
        }
    }
    return nil
}

/* Gets the player's stats. */
func getMyStats() -> [String:[String:AnyObject]]? {
    var prefs = NSUserDefaults.standardUserDefaults()
    var player = prefs.objectForKey("currentuser") as String
    var versionstr:NSString = UIDevice.currentDevice().systemVersion
    var versiondouble = versionstr.doubleValue
    
    // If iOS 8 or the playerStats is nil.
    if (versiondouble >= 8.0 || prefs.objectForKey("playerStats") == nil) {
        
        // Get the player stats and store it to NSUserDefaults.
        var stats = getPlayer(player)
        if (stats != nil) {
            var plStats:[String:[String:AnyObject]] = [:]
            plStats[player] = stats
            prefs.setObject(plStats, forKey: "playerStats")
            return plStats
        }
    }
    
    // Else if playerStats exists.
    else if (prefs.objectForKey("playerStats") != nil) {
        // Retrieve from NSUserDefaults and return it.
        var plStats:[String:[String:AnyObject]] = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        return plStats
    }
    return nil
}

/* Posts the players stats to the server. */
func postPlayerStats() {
    
    // Get the player's variables from NSUserDefaults.
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
        
        // Post the user's stats to the server.
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playerdataForm/"
        var str = "ID=\(playerID)&level=\(level)&health=\(health)&strength=\(strength)&magic=\(magic)&speed=\(speed)&points=\(points)&experience=\(exp)&speedProgress=\(speedProgress)&enemiesDefeated=\(enemiesDefeated)&magicHour=\(magicHour)&magicSteps=\(magicSteps)&date=\(date)&healthGoal=\(healthGoal)&strengthGoal=\(strengthGoal)&magicGoal=\(magicGoal)&enemyStepCount=\(enemyStepCount)&submit=submit"
        post(urlstring, str)
    }
}

/* Posts the player's location and time to the server. */
func postPlayerLocation(playerID:String!, beaconID:String!, myview:GMSMapView!) {
    
    // If location is enabled.
    if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
        
        // Get the required values.
        var lat = myview.myLocation.coordinate.latitude
        var long = myview.myLocation.coordinate.longitude
        var timestamp = returnTimeStampString()
        
        // Post.
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/form/index.php"
        var str = "phone=\(playerID!)&beacon=\(beaconID!)&longitude=\(long)&latitude=\(lat)&date=\(timestamp)&submit=submit"
        post(urlstring, str)
    }
}

/* Post the battle state to the server. */
func postToBattles(battleID:String!, enemAttack:String!, enemTarget:String!, playAttack:String!, turn:String!, currentPlayer:String!, status:String!) {
    var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/battleForm/index.php"
    var str = "ID=\(battleID)&lastEnemyAttack=\(enemAttack)&lastPlayerAttack=\(playAttack)&turnPlayerID=\(turn)&status=\(status)&enemyTargetID=\(enemTarget)&currentPlayerID=\(currentPlayer)&submit=submit"
    post(urlstring, str)
}

/* Post the players in battle to the server. */
func postPlayersInBattle(pid:String!, bid:String!) {
    var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playersinbattle/index.php"
    var str = "playerID=\(pid)&battleID=\(bid)&submit=submit"
    post(urlstring, str)
}

/* Update the value at when the player will next encounter an enemy. */
func updateEncounterStep(inout stepcount:Int, m7steps:Int) {
    
    // Get the approximation of how many thousand steps the player is currently at.
    var thousands = lroundf(Float(m7steps) / 1000.0) + 1
    // Set the next stepcount to be approximately 1000 later.
    stepcount = Int(thousands) * 1000 + Int(arc4random_uniform(200)) - 100
    
    // Synch the value in the app delegate as well.
    var appdel:AppDelegate = (UIApplication.sharedApplication().delegate) as AppDelegate
    appdel.encounterstep = stepcount
}

/* Increments and updates the player's stats stored in NSUserDefaults. */
func updateLocalPlayerStats(healthinc:Int, strengthinc:Int, magicinc:Int, speedinc:Int, inout stats:[String:[String:AnyObject]]) {
    
    // Get the player's current stats.
    var prefs = NSUserDefaults.standardUserDefaults()
    var playerID = prefs.objectForKey("currentuser") as String
    var health:Int = stats[playerID]!["health"]! as Int
    var strength:Int = stats[playerID]!["strength"]! as Int
    var magic:Int = stats[playerID]!["magic"]! as Int
    var speed:Int = stats[playerID]!["speed"]! as Int
    
    // Increment the stats.
    stats[playerID]!["health"]! = health+healthinc
    stats[playerID]!["strength"]! = strength+strengthinc
    stats[playerID]!["magic"]! = magic+magicinc
    stats[playerID]!["speed"]! = speed+speedinc
    
    // Update NSUserDefaults value.
    prefs.setObject(stats, forKey: "playerStats")
    
    // Debug.
    postLog("My current stats after updating are Health: \(health+healthinc), Strength: \(strength+strengthinc), Magic: \(magic+magicinc), Speed: \(speed+speedinc)")
}

/* Position the map to the given coordinates and zoom value. */
func positionMap(inout mainview:UIView!, inout myview:GMSMapView!, lat:CLLocationDegrees, long:CLLocationDegrees, zoom:Float) {
    
    // Set camera to the values.
    var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: zoom)
    
    // Set initial properties of GMSMapView.
    myview = GMSMapView(frame: mainview.bounds)
    myview.camera = camera
    myview.myLocationEnabled = true
    myview.buildingsEnabled = false
    myview.indoorEnabled = false
    
    // Add the map view to the ui view.
    mainview.addSubview(myview)
}

/* Set a GMSMarker at the given coordinates with a title, text, and color. */
func setMarker(inout myview:GMSMapView!, lat:CLLocationDegrees, long:CLLocationDegrees, title:String, text:String, color:UIColor) -> GMSMarker {
    var marker:GMSMarker = GMSMarker(position: CLLocationCoordinate2DMake(lat, long))
    var tintedicon:UIImage = GMSMarker.markerImageWithColor(color)
    marker.title = title
    marker.snippet = text
    marker.icon = tintedicon
    marker.map = myview
    return marker
}

/* Return a string representing the given CMMotionActivity. */
func activityToString(act:CMMotionActivity) -> String {
    var actionName = ""
    
    if (act.unknown) { actionName += "Unknown " }
    if (act.stationary) { actionName += "Stationary " }
    if (act.walking) { actionName += "Walking " }
    if (act.running) { actionName += "Running " }
    if (act.automotive) { actionName += "Automotive " }
    
    return actionName
}

/* Get the historical step count from the start of the day until now. */
func getHistoricalSteps(handler:(Int, NSError!) -> Void) {
    
    // When step counting is available.
    if(CMStepCounter.isStepCountingAvailable()){
        
        var stepCounter = CMStepCounter()
        var mainQueue:NSOperationQueue! = NSOperationQueue()
        var todate:NSDate! = NSDate()
        var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        
        // Get the historical step count with handler.
        dispatch_async(lowQueue, { () -> Void in
            stepCounter.queryStepCountStartingFrom(startDateOfToday(), to: todate, toQueue: mainQueue, withHandler: handler)
        })
    }
}

/* Update step related things with handlers. */
func updateSteps(stepHandler:(Int, NSDate!, NSError!) -> Void, activityHandler: (CMMotionActivity!) -> Void) {
    var lowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    var mainQueue:NSOperationQueue! = NSOperationQueue()
    
    // If step counting is available.
    if(CMStepCounter.isStepCountingAvailable()){
        var stepCounter = CMStepCounter()
        
        // Start step count updating with the step handler.
        dispatch_async(lowQueue, { () -> Void in
          stepCounter.startStepCountingUpdatesToQueue(mainQueue, updateOn: 1, withHandler: stepHandler)
        })
    }
    
    // If activity is available.
    if (CMMotionActivityManager.isActivityAvailable()) {
        var activityManager = CMMotionActivityManager()
        
        // Start activity updates with the activity handler.
        dispatch_async(lowQueue, { () -> Void in
            activityManager.startActivityUpdatesToQueue(mainQueue, withHandler: activityHandler)
        })
    }
}
