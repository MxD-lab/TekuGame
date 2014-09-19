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
    var enemiesDefeated:Int = 0
    var magicHourInt:Int = 0
    var currentHourInt:Int = 0
    var prevMagicSteps:Int = 0
    var magicSteps:Int = 0
    var magicGoal:Int = 0
    var enemiesGoal:Int = 0
    var enemyStepCount:Int = 0
    
    var labelTimer:NSTimer!
    var statusTimer:NSTimer!
    var postGetTimer:NSTimer!
    var encounterTimer:NSTimer!
    
    var prefs = NSUserDefaults.standardUserDefaults()
    var plStats:[String:[String:AnyObject]] = [:]
    
    // Google Maps things.
    @IBOutlet var mainView:UIView!
    var mapView_:GMSMapView!
    var timer:NSTimer!
    var mapShown:Bool! = false
    @IBOutlet weak var currentLocationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepCount = 0
        getHistoricalSteps()
        updateSteps()
        setButton()
        beaconSetup()
        if (isConnectedToInternet()) {
            initialMapSetup()
            getPlayerLocation()
            postPlayerStats()
            mapShown = true
        }
        else {
            netConnectionLabel.text = "No Internet"
            currentLocationBtn.hidden = true
            currentLocationBtn.enabled = false
        }
        
        plStats = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        speedFloat = plStats[playerID]!["speedProgress"]! as Float
        prevMagicSteps = plStats[playerID]!["magicSteps"]! as Int
        magicSteps = prevMagicSteps
        
        prefs.setObject(true, forKey: "loggedIn")

        if (isConnectedToInternet()) {
            clManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            clManager.startUpdatingLocation()
            clManager.delegate = self
        }
        
        var versionstr:NSString = UIDevice.currentDevice().systemVersion
        var versiondouble = versionstr.doubleValue
        
        if (versiondouble >= 8.0) {
            clManager.requestWhenInUseAuthorization()
        }
        
        labelTimer = setInterval("updateStepLabel", seconds: 1)
        statusTimer = setInterval("checkStatus", seconds: 2)
        postGetTimer = setInterval("postAndGet", seconds: 30)
        encounterTimer = setInterval("checkEncounter", seconds: 1)
    }
    
    func setButton() {
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
        mapView_.buildingsEnabled = false
        mapView_.indoorEnabled = false
        
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
            currentLocationBtn.hidden = true
            currentLocationBtn.enabled = false
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
            postPlayerLocation()
            postPlayerStats()
            getPlayerLocation()
        }
    }
    
    func postPlayerLocation() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
            lat = mapView_.myLocation.coordinate.latitude
            long = mapView_.myLocation.coordinate.longitude
            var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/form/index.php"
            var str = "phone=\(playerID!)&beacon=\(beaconID!)&longitude=\(long!)&latitude=\(lat!)&submit=submit"
            post(urlstring, str)
        }
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
        
        if (healthGoal == 0) {
            healthGoal = plStats[playerID]!["healthGoal"]! as Int
        }
        
        if (stepCount >= healthGoal) {
            healthGoal += 5000
            plStats[playerID]!["healthGoal"]! = healthGoal
            prefs.setObject(plStats, forKey: "playerStats")
            postLog("Walked \(stepCount) steps today, health incremented by 1.")
            updateLocalPlayerStats(1, 0, 0, 0, &plStats)
        }
    }
    
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
        }
    }
    
    func checkMagicHour() {
        magicHourInt = plStats[playerID]!["magicHour"]! as Int
        var magicDate = plStats[playerID]!["date"]! as String
        
        if (magicDate != returnDateString()) {
            magicSteps = 0
            magicHourInt = Int(arc4random_uniform(16)) + 8
            plStats[playerID]!["magicHour"]! = magicHourInt
            plStats[playerID]!["magicSteps"]! = 0
            plStats[playerID]!["date"]! = returnDateString()
            prefs.setObject(plStats, forKey: "playerStats")
        }

        magicHourLabel.text = "Magic Hour: \(magicHourInt):00"
        
        if (magicGoal == 0) {
            magicGoal = plStats[playerID]!["magicGoal"]! as Int
        }
        
        if (magicSteps >= magicGoal) {
            magicGoal += 1000
            plStats[playerID]!["magicGoal"]! = magicGoal
            prefs.setObject(plStats, forKey: "playerStats")
            postLog("Walked \(magicSteps) steps during magic hour (\(magicHourInt):00). Magic incremented by 1.")
            updateLocalPlayerStats(0, 0, 1, 0, &plStats)
        }
    }
    
    func checkEnemiesGoal() {
        
        if (enemiesDefeated == 0) {
            enemiesDefeated = plStats[playerID]!["enemiesDefeated"]! as Int
        }
        
        if (enemiesGoal == 0) {
            enemiesGoal = plStats[playerID]!["strengthGoal"]! as Int
        }
        
        if (enemiesDefeated >= enemiesGoal) {
            enemiesGoal += 3
            plStats[playerID]!["strengthGoal"]! = enemiesGoal
            prefs.setObject(plStats, forKey: "playerStats")
            postLog("Defeated \(enemiesDefeated) enemies. Strength incremented by 1.")
            updateLocalPlayerStats(0, 1, 0, 0, &plStats)
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
    
    // Simply updates the label for step count.
    func updateStepLabel() {
        steplabel.text = "Steps：\(stepCount) steps"

        if (confidencenum == Float(CMMotionActivityConfidence.High.toRaw()) || confidencenum == Float(CMMotionActivityConfidence.Medium.toRaw())) {
            activityLabel.text = activitystring
        }
        else {
            activityLabel.text = ""
        }
        magicStepsLabel.text = "Magic Steps: \(magicSteps) steps"
        plStats[playerID]!["speedProgress"]! = speedFloat
        plStats[playerID]!["magicSteps"]! = magicSteps
        prefs.setObject(plStats, forKey: "playerStats")
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
    
    func checkEncounter() {

        if (enemyStepCount == 0) {
            enemyStepCount = plStats[playerID]!["enemyStepCount"]! as Int
        }
        
        var encountDate = plStats[playerID]!["date"]! as String

        if (encountDate != returnDateString()) {
            updateEncounterStep(&enemyStepCount, stepCount)
            plStats[playerID]!["enemyStepCount"]! = enemyStepCount
            prefs.setObject(plStats, forKey: "playerStats")
        }
        else {
            if (enemyStepCount < stepCount) {
                updateEncounterStep(&enemyStepCount, stepCount)
                plStats[playerID]!["enemyStepCount"]! = enemyStepCount
                prefs.setObject(plStats, forKey: "playerStats")
                encount()
            }
        }
    }
    
    func encount() {
        var state = UIApplication.sharedApplication().applicationState
        if (state == UIApplicationState.Active) {
            postLog("Encountered enemy at \(stepCount).")
            performSegueWithIdentifier("map_game", sender: self)
            updateEncounterStep(&enemyStepCount, stepCount)
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
            var nextVC = segue.destinationViewController as statusViewController
            nextVC.stepCount = stepCount
        }
        
        if (mapShown == true) {
            var cam:[String:Double] = ["lat":mapView_.camera.target.latitude, "long":mapView_.camera.target.longitude, "zoom":Double(mapView_.camera.zoom)]
            prefs.setObject(cam, forKey: "camera")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        if (labelTimer != nil) {
            labelTimer.invalidate()
            labelTimer = nil
        }
        if (statusTimer != nil) {
            statusTimer.invalidate()
            statusTimer = nil
        }
        if (postGetTimer != nil) {
            postGetTimer.invalidate()
            postGetTimer = nil
        }
        if (encounterTimer != nil) {
            encounterTimer.invalidate()
            encounterTimer = nil
        }
    }
}
