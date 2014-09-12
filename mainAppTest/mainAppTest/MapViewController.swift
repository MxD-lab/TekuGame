//
//  MapViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/18.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion
import Darwin

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var encountLabel: UILabel!
    
    // MapKit, CoreLocation
    @IBOutlet weak var statusButton: UIButton!
//    @IBOutlet weak var speedLabel: UILabel!
//    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var magicStepsLabel: UILabel!
    @IBOutlet weak var magicHourLabel: UILabel!
//    @IBOutlet weak var beaconDistanceLabel: UILabel!
//    @IBOutlet weak var beaconPlayerCountLabel: UILabel!
    var clManager = CLLocationManager()
    var playerID:String!                    // Player's ID passed from the previous ViewController.
    var lat:NSNumber!                       // Player's GPS coordinates (latitude).
    var long:NSNumber!                      // Player's GPS coordinates (longitude).
    var altitudeNum:Float! = 0
    var vAcc:Float! = 0
    var speedNum:Double! = 0
//    var players:[NSDictionary] = []         // NSArray of NSDictionary, each element is a player entry. This comes from the server.
    var allPins:[GMSMarker] = []         // All of the pins set on the Map including preset pins and players.
    var presetPins:[GMSMarker] = []      // Array of only the preset pins.
    var near_beacon:NSMutableArray = []     // Array of players with the same nearby beacon.
    
    // Internet Connection.
    @IBOutlet weak var netConnectionLabel: UILabel!
    
    // Enemy encounter step count.
    var encountStepCount:Int! = 0
    
    // iBeacon
    let proximityUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-25556B57FE6D")   // UUID of iBeacon.
    var region  = CLBeaconRegion()                                                  // Region defined for iBeacons.
    var manager = CLLocationManager()                                               // Location manager for iBeacons.
    var beaconID:String! = ""                                                       // ID of the nearest beacon.
    
    // CoreMotion
    @IBOutlet var steplabel: UILabel!   // Label display number of counts of today's steps.
    var stepCount:Int! = 0                  // Number of steps.
    var prevSteps:Int! = 0                  // Number of steps since the start of the day until the application has launched.
    var activitystring:String! = ""
    var confidencenum:Float! = 0
    
    var healthGoal:Int = 0
    var speedFloat:Float = 0
    var magicHourInt:Int = 0
    var currentHourInt:Int = 0
    var prevMagicSteps:Int = 0
    var magicSteps:Int = 0
    var magicGoal:Int = 0
    var enemiesGoal:Int = 0
    
    var labelTimer:NSTimer!
    var statusTimer:NSTimer!
    var postGetTimer:NSTimer!
    var encounterTimer:NSTimer!
    
    // Google Maps things.
    @IBOutlet var mainView:UIView!
    var mapView_:GMSMapView!
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepCount = 0
        getHistoricalSteps()
        updateSteps()
        setButton()
        initialMapSetup()
        beaconSetup()
        if (isConnectedToInternet()) {
            getPlayerLocation()
        }
        else {
            netConnectionLabel.text = "インターネットの接続が切れています。"
        }
        
        var prefs = NSUserDefaults.standardUserDefaults()
        if (prefs.objectForKey("speedFloat") != nil) {
            speedFloat = prefs.objectForKey("speedFloat") as Float
        }
        else {
            speedFloat = 0
            prefs.setObject(0, forKey: "speedFloat")
        }
        
        if (prefs.objectForKey("magicSteps") != nil) {
            prevMagicSteps = prefs.objectForKey("magicSteps") as Int
            magicSteps = prevMagicSteps
        }
        
        prefs.setObject(true, forKey: "loggedIn")
        
//        clManager.requestAlwaysAuthorization() iOS 8.0
        clManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        clManager.startUpdatingLocation()
        clManager.delegate = self
        labelTimer = setInterval("updateStepLabel", seconds: 1)
        statusTimer = setInterval("checkStatus", seconds: 2)
        postGetTimer = setInterval("postAndGet", seconds: 15)
        encounterTimer = setInterval("checkEncounter", seconds: 1)
    }
    
    func setButton() {
        var prefs = NSUserDefaults.standardUserDefaults()
        var currentuser = prefs.objectForKey("currentuser") as String
        playerID = currentuser
        var idonly = playerID.componentsSeparatedByString("(")[0]
        statusButton.setTitle("@\(idonly)", forState: UIControlState.Normal)
    }
    
    // Calls the given function every n seconds.
    func setInterval(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: true)
    }
    
    // Initial setup for map.
    func initialMapSetup() {
        var prefs = NSUserDefaults.standardUserDefaults()
        
        var initlat:CLLocationDegrees = 35.6896
        var initlong:CLLocationDegrees = 139.6917
        var initzoom:Float = 0
        
        if (prefs.objectForKey("camera") != nil) {
            var cam = prefs.objectForKey("camera") as [String:Double]
            initlat = cam["lat"]!
            initlong = cam["long"]!
            initzoom = Float(cam["zoom"]!)
            positionMap(initlat, long: initlong, zoom: initzoom)
        }
        else {
            positionMap(initlat, long: initlong, zoom: initzoom)
            // Wait until current location is found to zoom to that place.
            timer = setInterval("gotoCurrentLocation", seconds: 1)
        }
        
        // Preset markers.
//        var marker_bkc = setMarker(34.982397, long: 135.964603, title: "BKC", text: "すてにゃん", color: UIColor.blueColor())
//        var marker_minamikusatsu = setMarker(35.003917, long: 135.947349, title: "南草津駅", text: "せやな", color: UIColor.blueColor())
//        
//        presetPins.append(marker_bkc)
//        presetPins.append(marker_minamikusatsu)
//        allPins.append(marker_bkc)
//        allPins.append(marker_minamikusatsu)
    }
    
    func positionMap(lat:CLLocationDegrees, long:CLLocationDegrees, zoom:Float) {
        var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: zoom)
        mapView_ = GMSMapView(frame: mainView.bounds)
        mapView_.camera = camera
        mapView_.myLocationEnabled = true
        mainView.addSubview(mapView_)
    }
    
    func setMarker(lat:CLLocationDegrees, long:CLLocationDegrees, title:String, text:String, color:UIColor) -> GMSMarker {
        var marker:GMSMarker = GMSMarker(position: CLLocationCoordinate2DMake(lat, long))
        var tintedicon:UIImage = GMSMarker.markerImageWithColor(color)
        marker.title = title
        marker.snippet = text
        marker.icon = tintedicon
        marker.map = mapView_
        return marker
    }
    
    func gotoCurrentLocation() {
        if (mapView_.myLocation != nil) {
            moveCameraToTarget(mapView_.myLocation.coordinate, zoom: 15)
            if (timer != nil) {
                timer.invalidate()
                timer = nil
            }
        }
    }
    
    func moveCameraToTarget(target:CLLocationCoordinate2D, zoom:Float) {
        var update:GMSCameraUpdate = GMSCameraUpdate.setTarget(target, zoom: zoom)
        mapView_.animateWithCameraUpdate(update)
    }
    
    // Setup for beacon.
    func beaconSetup() {
        region = CLBeaconRegion(proximityUUID:proximityUUID,identifier:"EstimoteRegion")
        manager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            self.manager.startRangingBeaconsInRegion(self.region)
        case .NotDetermined:
            let position = 1
            let index = advance(UIDevice.currentDevice().systemVersion.startIndex, position)
            let numb = UIDevice.currentDevice().systemVersion[index]
            
            if(String(numb).toInt() >= 8) {
                //iOS8以降は許可をリクエストする関数をCallする
                self.manager.requestAlwaysAuthorization()
            }
            else {
                self.manager.startRangingBeaconsInRegion(self.region)
            }
        case .Restricted, .Denied:
            println("Restricted")
        }
    }
    
    // Move to the user's current location.
    @IBAction func updateLocation(sender: AnyObject) {
        gotoCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Simply posts and gets.
    func postAndGet() {
        if (isConnectedToInternet()) {
            netConnectionLabel.text = ""
//            post()
            postPlayerLocation()
            getPlayerLocation()
        }
        else {
            netConnectionLabel.text = "インターネットの接続が切れています。"
        }
    }
    
    func postPlayerLocation() {
        lat = mapView_.myLocation.coordinate.latitude
        long = mapView_.myLocation.coordinate.longitude
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/form/index.php"
        var str = "phone=\(playerID!)&beacon=\(beaconID!)&longitude=\(long!)&latitude=\(lat!)&submit=submit"
        post(urlstring, str)
    }
    
    
    
    // Gets JSON data from the server and updates corresponding fields such as pins on the map and number of nearby players.
    func getPlayerLocation() {
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/playerandlocation.json"
        var jsObj = getJSON(url)
        
        if (jsObj != nil) {
            near_beacon = []
            
            resetPins()
            
            for data in jsObj! {
                var pid = data["phoneid"] as String
                var bid = data["beaconid"] as String
                var lati = data["latitude"] as NSString
                var lon = data["longitude"] as NSString
                
                if (pid != playerID) {
                    var plCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(lati.doubleValue, lon.doubleValue)
                    var pl = setMarker(lati.doubleValue, long: lon.doubleValue, title: pid, text: "player", color: UIColor.redColor())
                    allPins.append(pl)
                }
                if (bid == beaconID) {
                    near_beacon.addObject(data)
//                    beaconPlayerCountLabel.text = "\(near_beacon.count)"
                }
            }
        }
    }
    
    // Resets the pins on the map.
    func resetPins() {
        
        for pin in allPins {
            // If not a preset pin, then it is a player pin so delete it.
            if (find(presetPins, pin) == nil) {
                pin.map = nil
            }
        }
        
        var temparr:[GMSMarker] = []
        
        for pin in allPins {
            if (pin.map != nil) {
                temparr.append(pin)
            }
        }
        allPins = temparr
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        manager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion!) {
        if (state == .Inside) {
            manager.startRangingBeaconsInRegion(region)
        }
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("monitoringDidFailForRegion \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: NSArray!, inRegion region: CLBeaconRegion!) {
        
        if(beacons.count == 0) { return }
        
        var beacon = beacons[0] as CLBeacon
        
        /*
        beaconから取得できるデータ
        proximityUUID   :   regionの識別子
        major           :   識別子１
        minor           :   識別子２
        proximity       :   相対距離
        accuracy        :   精度
        rssi            :   電波強度
        */
        self.beaconID = "\(beacon.major)\(beacon.minor)"
        
        if (beacon.proximity == CLProximity.Unknown) {
//            beaconDistanceLabel.text = "Unknown Proximity"
            return
        }
        else if (beacon.proximity == CLProximity.Immediate) {
//            beaconDistanceLabel.text = "Immediate"
        }
        else if (beacon.proximity == CLProximity.Near) {
//            beaconDistanceLabel.text = "Near"
        }
        else if (beacon.proximity == CLProximity.Far) {
//            beaconDistanceLabel.text = "Far"
        }
    }
    
    // Gets the number of steps taken from the start of the day to the current time.
    func getHistoricalSteps() {
        if(CMStepCounter.isStepCountingAvailable()){
            var stepCounter = CMStepCounter()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            var todate:NSDate! = NSDate()
            
            stepCounter.queryStepCountStartingFrom(startDateOfToday(), to: todate, toQueue: mainQueue, withHandler: {numberOfSteps, error in
                self.prevSteps = numberOfSteps
            })
        }
    }
    
    // Starts counting the number of steps.
    func updateSteps() {
        if(CMStepCounter.isStepCountingAvailable()){
            var stepCounter = CMStepCounter()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            var todate:NSDate! = NSDate()
            
            stepCounter.startStepCountingUpdatesToQueue(mainQueue, updateOn: 1, withHandler: {numberOfSteps, timestamp, error in
                self.stepCount = numberOfSteps + self.prevSteps
                self.magicSteps = self.prevMagicSteps
                if (self.currentHourInt == self.magicHourInt) {
                    self.magicSteps = self.prevMagicSteps + numberOfSteps
                }
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
    }
    
    func checkHealthGoal() {
        var prefs = NSUserDefaults.standardUserDefaults()
        if (stepCount >= 10000 && prefs.objectForKey("healthGoal") != nil) {
            healthGoal = prefs.objectForKey("healthGoal") as Int
        }
        else {
            healthGoal = 10000
            prefs.setObject(healthGoal, forKey: "healthGoal")
        }
        
        if (stepCount >= healthGoal) {
            healthGoal += 10000
            prefs.setObject(healthGoal, forKey: "healthGoal")
            println("StepCount: \(stepCount), healthGoal: \(healthGoal)")
            updateLocalPlayerStats(1, strengthinc: 0, magicinc: 0, speedinc: 0)
            postLog("Walked \(stepCount) steps today, health incremented by 1.")
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
            updateLocalPlayerStats(0, strengthinc: 0, magicinc: 0, speedinc: 1)
            postLog("Speed incremented by 1 from running.")
        }
    }
    
    func checkMagicHour() {
        var prefs = NSUserDefaults.standardUserDefaults()
        var currDate = NSDate()
        var gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        var dateComponents = gregorian.components(NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: currDate)
        currentHourInt = dateComponents.hour
        
        if (prefs.objectForKey("magichour") != nil) {
            var magichour = prefs.objectForKey("magichour") as [String:String]
            if (magichour["date"]  == "\(dateComponents.month) / \(dateComponents.day)") {
                var hour = magichour["hour"]!
                magicHourInt = hour.toInt()!
            }
            else {
                magichour["date"] = "\(dateComponents.month) / \(dateComponents.day)"
                magichour["hour"] = "\(Int(arc4random_uniform(16)) + 8)"
                var hour = magichour["hour"]!
                magicHourInt = hour.toInt()!
                prefs.setObject(magichour, forKey: "magichour")
            }
        }
        else {
            var magichour:[String:String] = [:]
            magichour["date"] = "\(dateComponents.month) / \(dateComponents.day)"
            magichour["hour"] = "\(Int(arc4random_uniform(16)) + 8)"
            var hour = magichour["hour"]!
            magicHourInt = hour.toInt()!
            prefs.setObject(magichour, forKey: "magichour")
        }
        
        magicHourLabel.text = "Magic Hour: \(magicHourInt):00"
        
        if (magicSteps > 1000 && prefs.objectForKey("magicGoal") != nil) {
            magicGoal = prefs.objectForKey("magicGoal") as Int
        }
        else {
            magicGoal = 1000
            prefs.setObject(magicGoal, forKey: "magicGoal")
        }
        if (magicSteps >= magicGoal) {
            magicGoal += 1000
            prefs.setObject(magicGoal, forKey: "magicGoal")
            updateLocalPlayerStats(0, strengthinc: 0, magicinc: 1, speedinc: 0)
            postLog("Walked \(magicSteps) steps during magic hour (\(magicHourInt):00). Magic incremented by 1.")
        }
    }
    
    func checkEnemiesGoal() {
        
        var prefs = NSUserDefaults.standardUserDefaults()
        var enemiesBeaten = 0
        if (prefs.objectForKey("enemiesBeaten") == nil) {
            prefs.setObject(enemiesBeaten, forKey: "enemiesBeaten")
        }
        else {
            enemiesBeaten = prefs.objectForKey("enemiesBeaten") as Int
        }
        
        if (enemiesBeaten >= 25 && prefs.objectForKey("enemiesGoal") != nil) {
            enemiesGoal = prefs.objectForKey("enemiesGoal") as Int
        }
        else {
            enemiesGoal = 25
            prefs.setObject(enemiesGoal, forKey: "enemiesGoal")
        }
        
        if (enemiesBeaten >= enemiesGoal) {
            prefs.setObject(enemiesGoal+25, forKey: "enemiesGoal")
            updateLocalPlayerStats(0, strengthinc: 3, magicinc: 0, speedinc: 0)
            postLog("Defeated \(enemiesBeaten) enemies. Strength incremented by 3.")
        }
    }
    
    func updateLocalPlayerStats(healthinc:Int, strengthinc:Int, magicinc:Int, speedinc:Int) {
        
        var prefs = NSUserDefaults.standardUserDefaults()
        
        var plStats:[String:[String:Int]] = prefs.objectForKey("playerStats") as [String:[String:Int]]
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
    
    func activityToString(act:CMMotionActivity) -> String {
        var actionName = ""
        
        if (act.unknown) { actionName += "Unknown " }
        if (act.stationary) { actionName += "Stationary " }
        if (act.walking) { actionName += "Walking " }
        if (act.running) { actionName += "Running " }
        if (act.automotive) { actionName += "Automotive " }
        
        return actionName
    }
    
    // Simply updates the label for step count.
    func updateStepLabel() {
        steplabel.text = "Steps：\(stepCount) steps"
//        altitudeLabel.text = NSString(format: "Altitude: %.2f m +/- %.2f", altitudeNum, vAcc)
        if (speedNum > 0) {
//            speedLabel.text = NSString(format: "Speed: %.2f m/s", speedNum)
            println(speedNum)
        }
        
        
        if (confidencenum == Float(CMMotionActivityConfidence.High.toRaw()) || confidencenum == Float(CMMotionActivityConfidence.Medium.toRaw())) {
            activityLabel.text = activitystring
        }
        else {
            activityLabel.text = "Not sure."
        }
        magicStepsLabel.text = "Magic Steps: \(magicSteps) steps"
    }
    
    func checkStatus() {
        checkHealthGoal()
        checkRunningGoal()
        checkMagicHour()
        checkEnemiesGoal()
    }
    
    // Returns an NSDate object of the beginning of the day.
    func startDateOfToday() -> NSDate! {
        var calender = NSCalendar.currentCalendar()
        var components = calender.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
        return calender.dateFromComponents(components)
    }
    
    // CoreLocation updates.
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var loc: CLLocation = locations[locations.count-1] as CLLocation
        altitudeNum = Float(loc.altitude)
        vAcc = Float(loc.verticalAccuracy)
        speedNum = loc.speed
    }
    
    func checkEncounter() {
        if (encountStepCount < stepCount) {
            if (encountStepCount != 0) {
                encount()
            }
        }
        if (encountStepCount == 0) {
            var prefs = NSUserDefaults.standardUserDefaults()
            if (prefs.objectForKey("encounterStep") != nil) {
                encountStepCount = prefs.objectForKey("encounterStep") as Int
                encountLabel.text = "Next encount: \(encountStepCount)"
                var appdel:AppDelegate = (UIApplication.sharedApplication().delegate) as AppDelegate
                appdel.encounterstep = encountStepCount
            }
            else {
                updateEncounterStep()
                prefs.setObject(encountStepCount, forKey: "encounterStep")
            }
        }
    }
    
    func updateEncounterStep() {
        
        var thousands = lroundf(Float(stepCount) / 1000.0) + 1
        encountStepCount = Int(thousands) * 1000 + Int(arc4random_uniform(200)) - 100
        encountLabel.text = "Next encount: \(encountStepCount)"
        var appdel:AppDelegate = (UIApplication.sharedApplication().delegate) as AppDelegate
        appdel.encounterstep = encountStepCount
    }
    
    func encount() {
        var state = UIApplication.sharedApplication().applicationState
        if (state == UIApplicationState.Active) {
            postLog("Encountered enemy at \(stepCount).")
            performSegueWithIdentifier("map_game", sender: self)
            updateEncounterStep()
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "map_status") {
            var prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(speedFloat, forKey: "speedFloat")
            prefs.setObject(magicSteps, forKey: "magicSteps")
            var nextVC = segue.destinationViewController as statusViewController
            nextVC.stepCount = stepCount
        }
        var prefs = NSUserDefaults.standardUserDefaults()
        var cam:[String:Double] = ["lat":mapView_.camera.target.latitude, "long":mapView_.camera.target.longitude, "zoom":Double(mapView_.camera.zoom)]
        prefs.setObject(cam, forKey: "camera")
    }
    
    override func viewDidDisappear(animated: Bool) {
        labelTimer.invalidate()
        statusTimer.invalidate()
        postGetTimer.invalidate()
        encounterTimer.invalidate()
        labelTimer = nil
        statusTimer = nil
        postGetTimer = nil
        encounterTimer = nil
    }
}
