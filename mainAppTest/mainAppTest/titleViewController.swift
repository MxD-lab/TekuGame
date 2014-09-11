//
//  titleViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/19.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class titleViewController: UIViewController {
    
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
        
        if (loggedin) {
            performSegueWithIdentifier("title_map", sender: self)
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