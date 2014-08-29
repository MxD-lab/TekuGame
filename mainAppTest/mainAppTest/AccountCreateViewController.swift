//
//  AccountCreateViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/18.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class AccountCreateViewController: UIViewController {
    
    var playerID:String! = ""
    @IBOutlet weak var playerIDLabel : UILabel!
    @IBOutlet weak var createCharacterBtn: UIButton!
    @IBOutlet weak var accountTypeLabel: UILabel!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (playerID != "") {
            var idonly = playerID.componentsSeparatedByString("(")[0]
            var acctype = playerID.componentsSeparatedByString("(")[1]
            acctype = acctype.componentsSeparatedByString(")")[0]
            playerIDLabel.text = "Logged in as @\(idonly)"
            accountTypeLabel.text = "Account Type: \(acctype)"
            createCharacterBtn.hidden = false
        }
        else {
            playerIDLabel.text = "Not logged in."
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "accreate_charcreate" && playerID != "") {
             var prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(playerID, forKey: "currentuser")
            var nextVC = segue.destinationViewController as CharacterCreateViewController
            nextVC.playerID = playerID
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
}
