//
//  ViewController.swift
//  newServerBeaconProgram
//
//  Created by ステファンアレクサンダー on 2014/07/18.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit
import Accounts
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //UI for map
    @IBOutlet var long: UILabel
    @IBOutlet var lat: UILabel
    
    // UI for twitter login
    @IBOutlet var loginText: UILabel
    @IBOutlet var loginButton: UIButton
    // UI for HTTP request
    @IBOutlet var postButton: UIButton
    @IBOutlet var getButton: UIButton
    @IBOutlet var dataOutput: UITextView
    // UI for iBeacon
    @IBOutlet var status : UILabel
    @IBOutlet var uuid : UILabel
    @IBOutlet var major : UILabel
    @IBOutlet var minor : UILabel
    @IBOutlet var accuracy : UILabel
    @IBOutlet var rssi : UILabel
    @IBOutlet var distance : UILabel
    
    // For twitter login
    var accountStore = ACAccountStore()
    var username = String()
    // For HTTP requests
    var iphoneBeaconDictionary: [NSDictionary] = []
    var myBeaconId = "432"
    var closePhones: [(NSString, NSString)] = []
    // For iBeacon
    let proximityUUID = NSUUID(UUIDString:"B9407F30-F5F8-466E-AFF9-25556B57FE6D")
    var region  = CLBeaconRegion()
    var manager = CLLocationManager()
    var beaconID = String()
    
    //For map
    var toPasslat:NSNumber?
    var toPasslong:NSNumber?
    
    // When login pressed for twitter
    @IBAction func loginPressed(sender: AnyObject) {
        var accountType:ACAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        var haveAccess:Bool = false
        let handler: ACAccountStoreRequestAccessCompletionHandler =
        {
            granted, error in
            if(!granted) {
                println("ユーザーがアクセスを拒否しました。")
            } else {
                println("ユーザーがアクセスを許可しました。")
                haveAccess = true
            }
        }
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, handler)
        var twitterAccounts:NSArray = accountStore.accountsWithAccountType(accountType)
        if (twitterAccounts.count > 0) {
            username = twitterAccounts[0].username
            loginText.text = "Logged in as @\(username)"
            loginButton.enabled = false
            postButton.enabled = true
            getButton.enabled = true
        }
    }
    
    // When post pressed for HTTP Post to database
    @IBAction func postPressed(sender: AnyObject) {
        var url = "http://tekugame.mxd.media.ritsumei.ac.jp/form/index.php"
        var str = "phone="+username+"&beacon="+beaconID+"&longitude=\(toPasslong)&latitude=\(toPasslat)&submit=submit"
        println("Posting: \(str)")
        httpRequest(url, content: str)
    }
    
    // When get pressed for getting JSON data from server
    @IBAction func getPressed(sender: AnyObject) {
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/results.json"
        iphoneBeaconDictionary = updateDictionary(url)
        println(iphoneBeaconDictionary)
        dataOutput.text = ""
        
        for data in iphoneBeaconDictionary {
            println(data["phoneid"])
            println(data["beaconid"])
            println(data["latitude"])
            println(data["longitude"])
            println("\n")
            var pid = data["phoneid"] as String
            var bid = data["beaconid"] as String
            var lat = data["latitude"] as String
            var lon = data["longitude"] as String
            
            dataOutput.text = "\(dataOutput.text)\(pid)\n\(bid)\n\(lat)\n\(lon)\n\n"
        }
    }
    
    // Update the dictionary with the JSON file from the server.
    func updateDictionary(url:String) -> [NSDictionary] {
        var jsonData = NSData(contentsOfURL: NSURL(string: url))
        var error: NSError?
        var jsObj = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &error) as [NSDictionary]
        return jsObj
    }
    
    // Function for posting to the server.
    // http://qiita.com/mochizukikotaro/items/e2da2d3186ec24e291a6
    // http://www.brianjcoleman.com/tutorial-post-to-web-server-api-in-swift-using-nsurlconnection/
    func httpRequest(urlstring:String, content:String = "") {
        
        var url = NSURL.URLWithString(urlstring) // URL object from URL string.
        var request = NSMutableURLRequest(URL: url) // Request.
        request.HTTPMethod = "POST" // Could be POST or GET.
        
        // Post has HTTPBody.
        var strData = content.dataUsingEncoding(NSUTF8StringEncoding)
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
    
    // Hide keyboard when background touched.
    // http://ios-blog.co.uk/tutorials/developing-ios8-apps-using-swift-create-a-to-do-application/
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        long.text = "\(toPasslong)"
        lat.text = "\(toPasslat)"
        // Do any additional setup after loading the view, typically from a nib.
        //CLBeaconRegionを生成
        region = CLBeaconRegion(proximityUUID:proximityUUID,identifier:"EstimoteRegion")
        
        //デリゲートの設定
        manager.delegate = self
        
        /*
        位置情報サービスへの認証状態を取得する
        NotDetermined   --  アプリ起動後、位置情報サービスへのアクセスを許可するかまだ選択されていない状態
        Restricted      --  設定 > 一般 > 機能制限により位置情報サービスの利用が制限中
        Denied          --  ユーザーがこのアプリでの位置情報サービスへのアクセスを許可していない
        Authorized      --  位置情報サービスへのアクセスを許可している
        */
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            //iBeaconによる領域観測を開始する
            println("観測開始")
            self.status.text = "Starting Monitor"
            self.manager.startRangingBeaconsInRegion(self.region)
        case .NotDetermined:
            println("許可承認")
            self.status.text = "Starting Monitor"
            //デバイスに許可を促す
            if(UIDevice.currentDevice().systemVersion.substringToIndex(1).toInt() >= 8){
                //iOS8以降は許可をリクエストする関数をCallする
                self.manager.requestAlwaysAuthorization()
            }else{
                self.manager.startRangingBeaconsInRegion(self.region)
            }
        case .Restricted, .Denied:
            //デバイスから拒否状態
            println("Restricted")
            self.status.text = "Restricted Monitor"
        }
    }
    
    //以下 CCLocationManagerデリゲートの実装---------------------------------------------->
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
    Parameters
    manager : The location manager object reporting the event.
    region  : The region that is being monitored.
    */
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        manager.requestStateForRegion(region)
        self.status.text = "Scanning..."
    }
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
    Parameters
    manager :The location manager object reporting the event.
    state   :The state of the specified region. For a list of possible values, see the CLRegionState type.
    region  :The region whose state was determined.
    */
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion!) {
        if (state == .Inside) {
            //領域内にはいったときに距離測定を開始
            manager.startRangingBeaconsInRegion(region)
        }
    }
    
    /*
    リージョン監視失敗（bluetoosの設定を切り替えたりフライトモードを入切すると失敗するので１秒ほどのdelayを入れて、再トライするなど処理を入れること）
    - (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
    Parameters
    manager : The location manager object reporting the event.
    region  : The region for which the error occurred.
    error   : An error object containing the error code that indicates why region monitoring failed.
    */
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("monitoringDidFailForRegion \(error)")
        self.status.text = "Error :("
    }
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
    Parameters
    manager : The location manager object that was unable to retrieve the location.
    error   : The error object containing the reason the location or heading could not be retrieved.
    */
    //通信失敗
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
        self.status.text = "Possible Match"
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        reset()
    }
    
    /*
    beaconsを受信するデリゲートメソッド。複数あった場合はbeaconsに入る
    - (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
    Parameters
    manager : The location manager object reporting the event.
    beacons : An array of CLBeacon objects representing the beacons currently in range. You can use the information in these objects to determine the range of each beacon and its identifying information.
    region  : The region object containing the parameters that were used to locate the beacons
    */
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
        if (beacon.proximity == CLProximity.Unknown) {
            self.distance.text = "Unknown Proximity"
            reset()
            return
        } else if (beacon.proximity == CLProximity.Immediate) {
            self.distance.text = "Immediate"
        } else if (beacon.proximity == CLProximity.Near) {
            self.distance.text = "Near"
        } else if (beacon.proximity == CLProximity.Far) {
            self.distance.text = "Far"
        }
        self.status.text   = "OK"
        self.uuid.text     = beacon.proximityUUID.UUIDString
        self.major.text    = "\(beacon.major)"
        self.minor.text    = "\(beacon.minor)"
        self.accuracy.text = "\(beacon.accuracy)"
        self.rssi.text     = "\(beacon.rssi)"
        self.beaconID      = "\(beacon.major)\(beacon.minor)"
    }
    
    func reset(){
        self.status.text   = "none"
        self.uuid.text     = "none"
        self.major.text    = "none"
        self.minor.text    = "none"
        self.accuracy.text = "none"
        self.rssi.text     = "none"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

}

