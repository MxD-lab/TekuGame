//
//  titleViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/19.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class titleViewController: UIViewController {
    
    var currentuser = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continuePressed(sender: AnyObject) {
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        var prefs = NSUserDefaults.standardUserDefaults()
        var loggedin = false
        if (prefs.objectForKey("loggedIn") != nil) {
            loggedin = prefs.objectForKey("loggedIn") as Bool
        }
        
        if (prefs.objectForKey("currentuser") != nil) {
            currentuser = prefs.objectForKey("currentuser") as String
        }
        
        var versionstr:NSString = UIDevice.currentDevice().systemVersion
        var versiondouble = versionstr.doubleValue
        
        if (loggedin && currentuser != "") {
            if (isConnectedToInternet()) {
                var stats = getPlayerStats()
                if (stats != nil) {
                    performSegueWithIdentifier("title_map", sender: self)
                }
                else {
                    if (versiondouble >= 8.0) {
                        UIAlertView(title: "Error", message: "Please check your internet connection.", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                    else {
                        performSegueWithIdentifier("title_map", sender: self)
                    }
                }
            }
            else {
                if (versiondouble >= 8.0) {
                    UIAlertView(title: "Error", message: "Please check your internet connection.", delegate: nil, cancelButtonTitle: "OK").show()
                }
                else {
                    performSegueWithIdentifier("title_map", sender: self)
                }
            }
        }
        else {
            performSegueWithIdentifier("title_acselect", sender: self)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
}
