//
//  ViewController.swift
//  mapTest
//
//  Created by 若尾あすか on 2014/07/22.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.
//

// SwiftとMapKitで経路検索アプリを作成する
// http://qiita.com/oggata/items/18ce281d5818269c7281

import UIKit
import MapKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate{
    //formaps
    @IBOutlet var distance: UILabel!
    @IBOutlet var mapView: MKMapView!
    //for beacon
    @IBOutlet var playerIDLabel: UILabel!
    @IBOutlet var nearbeacon: UIProgressView!
    @IBOutlet var nearplayer: UILabel!
    //for steps
    @IBOutlet var steplabel: UILabel!

    //for steps
    var stepCount:Int!
    var prevSteps:Int!

    //for maps
    var playerID:String!
    var lat:NSNumber!
    var long:NSNumber!
    
    //arrays
    var players:[NSDictionary] = []
    var allPins:NSMutableArray = []
    var presetPins:NSMutableArray = []
    var near_beacon:NSMutableArray = []
    
    // For iBeacon
    let proximityUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-25556B57FE6D")
    var region  = CLBeaconRegion()
    var manager = CLLocationManager()
    var beaconID:String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        stepCount = 0
        getHistoricalSteps()
        updateSteps()
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateStepLabel"), userInfo: nil, repeats: true)
        
        
        playerIDLabel.text = "@\(playerID!)さんよっす。"
        nearbeacon.transform = CGAffineTransformMakeScale( 1.0, 3.0 ); // 横方向に1倍、縦方向に3倍して表示する

        mapView.showsUserLocation = true
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.982397, 135.964603)
        lat = 34.982397
        long = 135.964603
        let span = MKCoordinateSpanMake(0.003, 0.003) //小さい値であるほど近づく
        //任意の場所を表示する場合、MKCoordinateRegionを使って表示する -> (中心位置、表示領域)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        mapView.setRegion(centerPosition,animated:true)
        
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
        
        NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("postAndGet"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
        //CLBeaconRegionを生成
        region = CLBeaconRegion(proximityUUID:proximityUUID,identifier:"EstimoteRegion")
        
        //デリゲートの設定
        manager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            //iBeaconによる領域観測を開始する
            println("観測開始")
//            self.status.text = "Starting Monitor"
            self.manager.startRangingBeaconsInRegion(self.region)
        case .NotDetermined:
            println("許可承認")
//            self.status.text = "Starting Monitor"
            //デバイスに許可を促す
//            if(UIDevice.currentDevice().systemVersion.substringToIndex(1).toInt() >= 8){
//                //iOS8以降は許可をリクエストする関数をCallする
//                self.manager.requestAlwaysAuthorization()
//            }else{
//                self.manager.startRangingBeaconsInRegion(self.region)
//            }
            
            let position = 1
            let index = advance(UIDevice.currentDevice().systemVersion.startIndex, position)
            let numb = UIDevice.currentDevice().systemVersion[index]
            
            if(String(numb).toInt() >= 8){
                //iOS8以降は許可をリクエストする関数をCallする
                self.manager.requestAlwaysAuthorization()
            }else{
                self.manager.startRangingBeaconsInRegion(self.region)
            }
            
        case .Restricted, .Denied:
            //デバイスから拒否状態
            println("Restricted")
//            self.status.text = "Restricted Monitor"
        }

    }
//viewlodeおわり

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
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let route: MKPolyline = overlay as MKPolyline
        let routeRenderer = MKPolylineRenderer(polyline:route)
        routeRenderer.lineWidth = 5.0
        routeRenderer.strokeColor = UIColor.redColor()
        return routeRenderer
    }
    
    func postAndGet() {
        post()
        get()
    }
    
    func post() {
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/form/index.php"
        var str1 = "phone=\(playerID!)"
        var str2 = "&beacon=\(beaconID!)"
        var str3 = "&longitude=\(long!)"
        var str = "phone=\(playerID!)&beacon=\(beaconID!)&longitude=\(long!)&latitude=\(lat!)&submit=submit"
        println("ぽすとしてるやつ: \(str)")
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
    
    func get() {
        mapView.removeAnnotations(allPins)
        allPins = []
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/playerandlocation.json"
        var jsonData = NSData(contentsOfURL: NSURL(string: url))
        var error: NSError?
        var jsObj = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &error) as [NSDictionary]
        
        players = jsObj
        
        for pin in presetPins {
            self.mapView.addAnnotation(pin as MKAnnotation)
        }
        
        near_beacon = []
        
        for data in players {
            var pid = data["phoneid"] as String
            var bid = data["beaconid"] as String
            var lati = data["latitude"] as NSString
            var lon = data["longitude"] as NSString
            
            if (pid != playerID) {
                var plCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(lati.doubleValue, lon.doubleValue)
                createPin(plCoordinate, title: pid, subtitle: "Player")
                println(pid)
            }
            if (bid == beaconID){
                
                near_beacon.addObject(bid)
                nearplayer.text = "\(near_beacon.count)"

                nearbeacon.progress = Float(near_beacon.count / 10)
                
            }
            
        }
    }
    
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
//        self.status.text = "Scanning..."
    }
   
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion!) {
        if (state == .Inside) {
            //領域内にはいったときに距離測定を開始
            manager.startRangingBeaconsInRegion(region)
        }
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("monitoringDidFailForRegion \(error)")
//        self.status.text = "Error :("
    }
        func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
//        self.status.text = "Possible Match"
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: NSArray!, inRegion region: CLBeaconRegion!) {
        //println(beacons)
        
        if(beacons.count == 0) { return }
        //複数あった場合は一番先頭のものを処理する
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
        } else if (beacon.proximity == CLProximity.Immediate) {
            self.distance.text = "Immediate"
        } else if (beacon.proximity == CLProximity.Near) {
            self.distance.text = "Near"
        } else if (beacon.proximity == CLProximity.Far) {
            self.distance.text = "Far"
        }
    }
    
    
    func getHistoricalSteps() {
        if(CMStepCounter.isStepCountingAvailable()){
            //StepCounterのインスタンス作成
            var stepCounter = CMStepCounter()
            var mainQueue:NSOperationQueue! = NSOperationQueue()
            var todate:NSDate! = NSDate()
            
            //歩数を取得
            stepCounter.queryStepCountStartingFrom(startDateOfToday(), to: todate, toQueue: mainQueue, withHandler: {numberOfSteps, error in
                println("Historical:\(numberOfSteps)")
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
                println("Update: \(numberOfSteps)")
            })
        }
    }
    
    func updateStepLabel() {
        steplabel.text = "\(stepCount)"
    }
    
    //今日の０時０分を取得
    func startDateOfToday() -> NSDate! {
        var calender = NSCalendar.currentCalendar()
        var components = calender.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: NSDate())
        return calender.dateFromComponents(components)
    }
}

