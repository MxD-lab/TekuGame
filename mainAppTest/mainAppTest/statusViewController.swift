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
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var magicLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
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
        
        healthLabel.text = "\(health)"
        strengthLabel.text = "\(strength)"
        magicLabel.text = "\(magic)"
        speedLabel.text = "\(speed)"
        
        healthProgressBar.progress = Float(stepCount % 10000) / 10000
        speedProgressBar.progress = prefs.objectForKey("speedFloat") as Float
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