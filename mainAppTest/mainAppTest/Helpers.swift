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
    
    // Reply from server.
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

func addZero(num:Int!) -> String! {
    return (num < 10) ? "0\(num)" : "\(num)"
}

func postLog(message:String!) {
//    if (isConnectedToInternet()) {
//        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playtestForm/"
//        var timestamp = returnTimeStampString()
//        var prefs = NSUserDefaults.standardUserDefaults()
//        var currentuser = prefs.objectForKey("currentuser") as String!
//        var query = "playerID=\(currentuser)&time=\(timestamp)&message=\(message)&submit=submit"
//        post(urlstring, query)
//    }
    println(message)
}
