//
//  ViewController.swift
//  googleMapsTest
//
//  Created by ステファンアレクサンダー on 2014/08/30.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController { //, GMSMapViewDelegate {
    
    @IBOutlet var mainView:UIView!
    var mapView_:GMSMapView!
    var timer:NSTimer!
    var colors:[UIColor] = [UIColor.blackColor(), UIColor.whiteColor(), UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.cyanColor(), UIColor.yellowColor(), UIColor.magentaColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.brownColor(), UIColor.clearColor()]
    var counter:Int = 0
    
    @IBAction func currentLocationBtnPressed(sender: AnyObject) {
        gotoCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        positionMap(35.6896, long: 139.6917, zoom: 0)
        
        var marker = setMarker(35.6896, long: 139.6917, title: "Tokyo", text: "Japan", color: UIColor.blackColor())
        marker.map = mapView_
        
        setInterval("setRandomMarker", seconds: 0.01)
        
//        timer = setInterval("gotoCurrentLocation", seconds: 1)
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
    
    func setRandomMarker() {
        var lati:Float = (Float(arc4random_uniform(18000)) / 100) - 90
        var long:Float = (Float(arc4random_uniform(36000)) / 100) - 180
        var index:UInt32 = UInt32(colors.count)
        var randColor:Float = Float(arc4random_uniform(index))
        var color:UIColor = colors[Int(randColor)]
        counter += 1
        println(counter)
        var mark = setMarker(CLLocationDegrees(lati), long: CLLocationDegrees(long), title: "\(counter)", text: "", color: color)
        mark.appearAnimation = kGMSMarkerAnimationPop
        mark.map = mapView_
    }
    
    func positionMap(lat:CLLocationDegrees, long:CLLocationDegrees, zoom:Float) {
        var camera:GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(lat, longitude: long, zoom: zoom)
        mapView_ = GMSMapView(frame: mainView.bounds)
        mapView_.camera = camera
        mapView_.myLocationEnabled = true
        mainView.addSubview(mapView_)
    }
    
    func moveCameraToTarget(target:CLLocationCoordinate2D, zoom:Float) {
        var update:GMSCameraUpdate = GMSCameraUpdate.setTarget(target, zoom: zoom)
        mapView_.animateWithCameraUpdate(update)
    }
    
    func setMarker(lat:CLLocationDegrees, long:CLLocationDegrees, title:String, text:String, color:UIColor) -> GMSMarker {
        var marker:GMSMarker = GMSMarker(position: CLLocationCoordinate2DMake(lat, long))
        var tintedicon:UIImage = GMSMarker.markerImageWithColor(color)
        marker.title = title
        marker.snippet = text
        marker.icon = tintedicon
        return marker
    }
    
    // Calls the given function every n seconds.
    func setInterval(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

