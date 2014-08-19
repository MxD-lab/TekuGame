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
    if (data) {
        return true
    }
    return false
}
