//
//  secondViewController.swift
//  newServerBeaconProgram
//
//  Created by 若尾あすか on 2014/07/22.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import Foundation
import UIKit
import MapKit




class secondViewController: UIViewController, MKMapViewDelegate {
    
    var lat:NSNumber?
    var long:NSNumber?
    
    @IBOutlet var mapView: MKMapView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.showsUserLocation = true
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.982397, 135.964603)
        let span = MKCoordinateSpanMake(0.003, 0.003) //小さい値であるほど近づく
        //任意の場所を表示する場合、MKCoordinateRegionを使って表示する -> (中心位置、表示領域)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        mapView.setRegion(centerPosition,animated:true)
        
        var fromCoordinate :CLLocationCoordinate2D = CLLocationCoordinate2DMake(34.982397, 135.964603)
        var toCoordinate   :CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.003917, 135.947349)
        lat = 34.982397
        long = 135.964603
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
        directions.calculateDirectionsWithCompletionHandler({
            (response:MKDirectionsResponse!, error:NSError!) -> Void in
            if (error? || response.routes.isEmpty) {
                return
            }
            let route: MKRoute = response.routes[0] as MKRoute
            self.mapView.addOverlay(route.polyline!)
            })
        
        //アノテーションというピンを地図に刺すことができる
        //出発点：六本木　〜　目的地：渋谷　の２点に刺す
        var theRoppongiAnnotation = MKPointAnnotation()
        theRoppongiAnnotation.coordinate = fromCoordinate
        theRoppongiAnnotation.title = "BKC"
        theRoppongiAnnotation.subtitle = "stefafafanかっこいいです"
        self.mapView.addAnnotation(theRoppongiAnnotation)
        
        var theShibuyaAnnotation = MKPointAnnotation()
        theShibuyaAnnotation.coordinate = toCoordinate
        theShibuyaAnnotation.title = "南草津駅"
        theShibuyaAnnotation.subtitle = "はい"
        self.mapView.addAnnotation(theShibuyaAnnotation)
        
        //カメラの設定をしてみる（少し手前に傾けた状態）
        var camera:MKMapCamera = self.mapView.camera;
        //camera.altitude += 100
        //camera.heading += 15
        camera.pitch += 60
        self.mapView.setCamera(camera, animated: true)
    }
    
    @IBAction func updateLocation(sender: AnyObject) {
        var centerCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapView.userLocation.coordinate.latitude, mapView.userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.003, 0.003)
        var centerPosition = MKCoordinateRegionMake(centerCoordinate, span)
        mapView.setRegion(centerPosition,animated:true)
        
        lat = mapView.userLocation.coordinate.latitude
        long = mapView.userLocation.coordinate.longitude
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
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "next") {
             //pass data to next view
            
                        var vc = segue!.destinationViewController as ViewController
            
            
                        vc.toPasslat = lat
                        vc.toPasslong = long
            
        }
    }

}

