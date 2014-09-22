//
//  assignPointsViewController.swift
//  mainAppTest
//
//  Created by Stefan Alexander on 2014/09/11.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class assignPointsViewController: UIViewController
{
    @IBOutlet weak var HealthLabel: UILabel!
    @IBOutlet weak var StrengthLabel: UILabel!
    @IBOutlet weak var MagicLabel: UILabel!
    @IBOutlet weak var SpeedLabel: UILabel!
    @IBOutlet weak var PointsLabel: UILabel!

    var original:player = player();
    
    var health = 0
    var strength = 0
    var magic = 0
    var speed = 0
    var assignpoints = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var prefs = NSUserDefaults.standardUserDefaults()
        var plStats:[String:[String:AnyObject]] = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        var currentuser = prefs.objectForKey("currentuser") as String
        health = plStats[currentuser]!["health"]! as Int
        strength = plStats[currentuser]!["strength"]! as Int
        magic = plStats[currentuser]!["magic"]! as Int
        speed = plStats[currentuser]!["speed"]! as Int
        assignpoints = plStats[currentuser]!["assignpoints"]! as Int
        
        original.health = health
        original.strength = strength
        original.magic = magic
        original.speed = speed
        original.points = assignpoints
        updateLabels();
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() -> Void
    {
        HealthLabel.text = "\(health)";
        StrengthLabel.text = "\(strength)";
        MagicLabel.text = "\(magic)";
        SpeedLabel.text = "\(speed)";
        PointsLabel.text = "Remaining Points: \(assignpoints)";
    }
    
    @IBAction func Reset(sender: AnyObject)
    {
        health = original.health;
        strength = original.strength;
        magic = original.magic;
        speed = original.speed;
        assignpoints = original.points;
        updateLabels();
    }
    
    @IBAction func SubtractHealth(sender: AnyObject)
    {
        if(health > original.health)
        {
            health -= 1;
            assignpoints += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddHealth(sender: AnyObject)
    {
        if(assignpoints > 0)
        {
            health += 1;
            assignpoints -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractStrength(sender: AnyObject)
    {
        if(strength > original.strength)
        {
            strength -= 1;
            assignpoints += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddStrength(sender: AnyObject)
    {
        if(assignpoints > 0)
        {
            strength += 1;
            assignpoints -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractMagic(sender: AnyObject)
    {
        if(magic > original.magic)
        {
            magic -= 1;
            assignpoints += 1;
            updateLabels();
        }
    }
    
    
    @IBAction func AddMagic(sender: AnyObject)
    {
        if(assignpoints > 0)
        {
            magic += 1;
            assignpoints -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractSpeed(sender: AnyObject)
    {
        if(speed > original.speed)
        {
            speed -= 1;
            assignpoints += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddSpeed(sender: AnyObject)
    {
        if(assignpoints > 0)
        {
            speed += 1;
            assignpoints -= 1;
            updateLabels();
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "assign_map") {
            
            var prefs = NSUserDefaults.standardUserDefaults()
            var currentuser = prefs.objectForKey("currentuser") as String
            
            var plStats = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
            plStats[currentuser]!["health"]! = health
            plStats[currentuser]!["strength"]! = strength
            plStats[currentuser]!["magic"]! = magic
            plStats[currentuser]!["speed"]! = speed
            plStats[currentuser]!["assignpoints"]! = assignpoints
            
            postLog("Finished assigning points. Health: \(health), Strength: \(strength), Magic: \(magic), Speed: \(speed), Remaining points: \(assignpoints)")

            prefs.setObject(plStats, forKey: "playerStats")
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
}

