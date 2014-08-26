//
//  CharacterCreateViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/18.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class CharacterCreateViewController: UIViewController {
    
    var playerID:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "charcreate_map" && playerID != "") {
            
            var prefs = NSUserDefaults.standardUserDefaults()
            var accounts = NSMutableArray()
            if ((prefs.objectForKey("useraccounts")) != nil) {
                accounts = prefs.objectForKey("useraccounts") as NSMutableArray
            }
            var hasAccount = false
            for account in accounts {
                if (account as String == playerID) {
                    hasAccount = true
                }
            }
            
            if (!hasAccount) {
                accounts.addObject(playerID)
            }
            
            prefs.setObject(accounts, forKey: "useraccounts")
            var nextVC = segue.destinationViewController as MapViewController
            nextVC.playerID = playerID
        }
    }
}

