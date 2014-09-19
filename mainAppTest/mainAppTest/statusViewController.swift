//
//  statusViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/19.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class statusViewController: UIViewController {
    
    // External
    var stepCount:Int!
    
    @IBOutlet weak var healthProgressBar: UIProgressView!
    @IBOutlet weak var strengthProgressBar: UIProgressView!
    @IBOutlet weak var magicProgressBar: UIProgressView!
    @IBOutlet weak var speedProgressBar: UIProgressView!
    @IBOutlet weak var expProgressBar: UIProgressView!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var magicLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var nameLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var prefs = NSUserDefaults.standardUserDefaults()
        var plStats:[String:[String:AnyObject]] = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        var currentuser = prefs.objectForKey("currentuser") as String

        var level = plStats[currentuser]!["level"]! as Int
        var health = plStats[currentuser]!["health"]! as Int
        var strength = plStats[currentuser]!["strength"]! as Int
        var magic = plStats[currentuser]!["magic"]! as Int
        var speed = plStats[currentuser]!["speed"]! as Int
        var points = plStats[currentuser]!["assignpoints"]! as Int
        var exp = plStats[currentuser]!["exp"]! as Int
        var speedProgress = plStats[currentuser]!["speedProgress"]! as Float
        var enemiesDefeated = plStats[currentuser]!["enemiesDefeated"]! as Int
        var magicHour = plStats[currentuser]!["magicHour"]! as Int
        var magicSteps = plStats[currentuser]!["magicSteps"]! as Int
        var date = plStats[currentuser]!["date"]! as String
        
        healthLabel.text = "\(health)"
        strengthLabel.text = "\(strength)"
        magicLabel.text = "\(magic)"
        speedLabel.text = "\(speed)"
        expLabel.text = "\(exp)"
        var useridonly = currentuser.componentsSeparatedByString("(")[0]
        nameLevelLabel.text = "@\(useridonly) Level \(level)"
        
        healthProgressBar.progress = Float(stepCount % 5000) / 5000
        speedProgressBar.progress = speedProgress
        magicProgressBar.progress = Float(magicSteps % 1000) / 1000
        strengthProgressBar.progress = Float(enemiesDefeated % 3) / 3
        expProgressBar.progress = Float(Float(exp)/Float((level * 10)))
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "status_title") {
            var prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(false, forKey: "loggedIn")
        }
    }
}