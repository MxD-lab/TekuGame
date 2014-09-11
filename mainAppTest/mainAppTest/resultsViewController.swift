//
//  resultsViewController.swift
//  mainAppTest
//
//  Created by Stefan Alexander on 2014/09/11.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class resultsViewController: UIViewController {
    
    var playerwin:Bool! = false
    var leveledUp:Bool! = false
    
    @IBOutlet weak var playerWinLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBAction func continuePressed(sender: AnyObject) {
        performSegueWithIdentifier("results_map", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var prefs = NSUserDefaults.standardUserDefaults()
        var plStats:[String:[String:Int]] = prefs.objectForKey("playerStats") as [String:[String:Int]]
        var currentuser = prefs.objectForKey("currentuser") as String
        var health:Int = plStats[currentuser]!["health"]!
        var strength:Int = plStats[currentuser]!["strength"]!
        var magic:Int = plStats[currentuser]!["magic"]!
        var speed:Int = plStats[currentuser]!["speed"]!
        var exp:Int = plStats[currentuser]!["exp"]!
        var level:Int = plStats[currentuser]!["level"]!
        
        detailsLabel.numberOfLines = 0
        detailsLabel.text = ""
        
        if (playerwin == true) {
            playerWinLabel.text = "You win!"
            if (leveledUp == true) {
                detailsLabel.text = "Level up! (\(level-1) → \(level))\n"
            }
            detailsLabel.text = detailsLabel.text! + "+1 enemies beaten.\n" + "+1 EXP\n"
        }
        else {
            playerWinLabel.text = "You lose."
            detailsLabel.text = detailsLabel.text! + "-1 EXP\n"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
}
