//
//  ViewController.swift
//  mapTest
//
//  Created by 若尾あすか on 2014/07/22.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.

import UIKit
import MapKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    // MapKit, CoreLocation
    @IBOutlet var distance: UILabel!        // Label that shows distance from iBeacon.
    @IBOutlet var mapView: MKMapView!       // iOS Map.
    var playerID:String!                    // Player's ID passed from the previous ViewController.
    var lat:NSNumber!                       // Player's GPS coordinates (latitude).
    var long:NSNumber!                      // Player's GPS coordinates (longitude).
    var players:[NSDictionary] = []         // NSArray of NSDictionary, each element is a player entry. This comes from the server.
    var allPins:NSMutableArray = []         // All of the pins set on the Map including preset pins and players.
    var presetPins:NSMutableArray = []      // Array of only the preset pins.
    var near_beacon:NSMutableArray = []     // Array of players with the same nearby beacon.
    
    // iBeacon
    @IBOutlet var playerIDLabel: UILabel!                                           // Label showing player's ID.
    @IBOutlet var nearbeacon: UIProgressView!                                       // Progress bar showing the number of people near the same beacon.
    @IBOutlet var nearplayer: UILabel!                                              // Label that shows number of people near beacon.
    let proximityUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-25556B57FE6D")   // UUID of iBeacon.
    var region  = CLBeaconRegion()                                                  // Region defined for iBeacons.
    var manager = CLLocationManager()                                               // Location manager for iBeacons.
    var beaconID:String! = ""                                                       // ID of the nearest beacon.
    
    // CoreMotion
    @IBOutlet var steplabel: UILabel!   // Label display number of counts of today's steps.
    var stepCount:Int!                  // Number of steps.
    var prevSteps:Int!                  // Number of steps since the start of the day until the application has launched.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepCount = 0
        getHistoricalSteps()
        updateSteps()
        playerIDLabel.text = "@\(playerID!)さんよっす。"
        initialMapSetup()
        beaconSetup()
        get()

        setInterval("updateStepLabel", seconds: 1)
        setInterval("postAndGet", seconds: 5)
    }
    
    // Calls the given function every n seconds.
    func setInterval(functionname:String, seconds:NSNumber) {
        NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: true)
    }
    
    // Initial setup for map.
    func initialMapSetup() {
        
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.982397, 135.964603)
        lat = 34.982397
        long = 135.964603
        
        mapView.showsUserLocation = true
        
        let span = MKCoordinateSpanMake(0.003, 0.003) //小さい値であるほど近づく
        //任意の場所を表示する場合、MKCoordinateRegionを使って表示する -> (中心位置、表示領域)
        
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        mapView.setRegion(centerPosition, animated:true)
        
        var fromCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.982397, 135.964603)
        var toCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.003917, 135.947349)
        var fromPlacemark = MKPlacemark(coordinate:fromCoordinate, addressDictionary:nil)
        var toPlacemark = MKPlacemark(coordinate:toCoordinate, addressDictionary:nil)
        var fromItem = MKMapItem(placemark:fromPlacemark);
        var toItem = MKMapItem(placemark:toPlacemark);
        let request = MKDirectionsRequest()
        request.setSource(fromItem)
        request.setDestination(toItem)
        request.requestsAlternateRoutes = true; //複数経路
        request.transportType = MKDirectionsTransportType.Walking //移動手段 Walking:徒歩/Automobile:車
        
        let directions = MKDirections(request:request)
        directions.calculateDirectionsWithCompletionHandler({ (response:MKDirectionsResponse!, error:NSError!) -> Void in
            if (error? || response.routes.isEmpty) {
                return
            }
            let route: MKRoute = response.routes[0] as MKRoute
            self.mapView.addOverlay(route.polyline!)
        })
        
        presetPins.addObject(createPin(fromCoordinate, title: "BKC", subtitle: "すてにゃん"))
        presetPins.addObject(createPin(toCoordinate, title: "南草津駅", subtitle: "せやな"))
        
        //カメラの設定をしてみる（少し手前に傾けた状態）
        var camera:MKMapCamera = self.mapView.camera;
        //camera.altitude += 100
        //camera.heading += 15
        camera.pitch += 60
        self.mapView.setCamera(camera, animated: true)
    }
    
    // Setup for beacon.
    func beaconSetup() {
        nearbeacon.transform = CGAffineTransformMakeScale( 1.0, 3.0 ); // 横方向に1倍、縦方向に3倍して表示する
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
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.003, 0.003)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        mapView.setRegion(centerPosition,animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // For drawing a route on the MapKit.
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let route: MKPolyline = overlay as MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.redColor()
        return routeRenderer
    }
    
    // Simply posts and gets.
    func postAndGet() {
        post()
        get()
    }
    
    // Makes an HTTP POST request for the player's ID, beacon, and GPS coordinates.
    func post() {
        
        lat = mapView.userLocation.coordinate.latitude
        long = mapView.userLocation.coordinate.longitude
        
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/form/index.php"
        var str = "phone=\(playerID!)&beacon=\(beaconID!)&longitude=\(long!)&latitude=\(lat!)&submit=submit"
        var url = NSURL.URLWithString(urlstring) // URL object from URL string.
        var request = NSMutableURLRequest(URL: url) // Request.
        request.HTTPMethod = "POST" // Could be POST or GET.
        
        // Post has HTTPBody.
        var strData = str.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = strData
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.setValue("gzip,deflate,sdch", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("ja,en-US;q=0.8,en;q=0.6", forHTTPHeaderField: "Accept-Language")
        request.setValue("tekugame.mxd.media.ritsumei.ac.jp", forHTTPHeaderField: "Host")
        
        // Values returned from server.
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        
        // Reply from server.
        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
        let results = NSString(data:reply, encoding:NSUTF8StringEncoding) // Encoded results.
    }
    
    // Gets JSON data from the server and updates corresponding fields such as pins on the map and number of nearby players.
    func get() {
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/playerandlocation.json"
        var jsonData = NSData(contentsOfURL: NSURL(string: url))
        var error: NSError?
        var jsObj = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &error) as [NSDictionary]
        
        players = jsObj
        near_beacon = []
        
        resetPins()
        
        for data in players {
            var pid = data["phoneid"] as String
            var bid = data["beaconid"] as String
            var lati = data["latitude"] as NSString
            var lon = data["longitude"] as NSString
            
            if (pid != playerID) {
                var plCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(lati.doubleValue, lon.doubleValue)
                createPin(plCoordinate, title: pid, subtitle: "Player")
            }
            if (bid == beaconID) {
                near_beacon.addObject(data)
                nearplayer.text = "\(near_beacon.count)"
                nearbeacon.progress = Float(near_beacon.count / 10)
            }
        }
    }
    
    // Resets the pins on the map.
    func resetPins() {
        mapView.removeAnnotations(allPins)
        allPins = []
        for pin in presetPins {
            self.mapView.addAnnotation(pin as MKAnnotation)
            allPins.addObject(pin as MKAnnotation)
        }
    }
    
    // Creates a pin at a coordinate with a certain title and subtitle.
    func createPin(coordinate:CLLocationCoordinate2D, title:String, subtitle:String) -> MKAnnotation {
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        self.mapView.addAnnotation(annotation)
        allPins.addObject(annotation)
        return annotation
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
            self.distance.text = "Unknown Proximity"
            return
        }
        else if (beacon.proximity == CLProximity.Immediate) {
            self.distance.text = "Immediate"
        }
        else if (beacon.proximity == CLProximity.Near) {
            self.distance.text = "Near"
        }
        else if (beacon.proximity == CLProximity.Far) {
            self.distance.text = "Far"
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
            })
        }
    }
    
    // Simply updates the label for step count.
    func updateStepLabel() {
        steplabel.text = "\(stepCount)"
    }
    
    // Returns an NSDate object of the beginning of the day.
    func startDateOfToday() -> NSDate! {
        var calender = NSCalendar.currentCalendar()
        var components = calender.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
        return calender.dateFromComponents(components)
    }
}
