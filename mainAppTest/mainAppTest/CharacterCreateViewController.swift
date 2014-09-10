//
//  CharacterCreateViewController.swift
//  Character Creator and Trait Assignment
//
//  Created by Maxwell Perlman on 8/26/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import UIKit

class CharacterCreateViewController: UIViewController
{
    var playerID:String! = ""
                            
    @IBOutlet weak var HealthLabel: UILabel!
    @IBOutlet weak var StrengthLabel: UILabel!
    @IBOutlet weak var MagicLabel: UILabel!
    @IBOutlet weak var SpeedLabel: UILabel!
    @IBOutlet weak var PointsLabel: UILabel!
    
    var p:player = player();
    var original:player = player();
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        p.level = 1;
        p.health = 0;
        p.strength = 0;
        p.magic = 0;
        p.speed = 0;
        p.points = 35;
        
        original.health = p.health;
        original.strength = p.strength;
        original.magic = p.magic;
        original.speed = p.speed;
        updateLabels();
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() -> Void
    {
        HealthLabel.text = "\(p.health)";
        StrengthLabel.text = "\(p.strength)";
        MagicLabel.text = "\(p.magic)";
        SpeedLabel.text = "\(p.speed)";
        PointsLabel.text = "Remaining Points: \(p.points)";
    }
    
    @IBAction func Reset(sender: AnyObject)
    {
        p.health = original.health;
        p.strength = original.strength;
        p.magic = original.magic;
        p.speed = original.speed;
        p.points = original.points;
        updateLabels();
    }
    
    @IBAction func SubtractHealth(sender: AnyObject)
    {
        if(p.health > original.health)
        {
            p.health -= 1;
            p.points += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddHealth(sender: AnyObject)
    {
        if(p.points > 0)
        {
            p.health += 1;
            p.points -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractStrength(sender: AnyObject)
    {
        if(p.strength > original.strength)
        {
            p.strength -= 1;
            p.points += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddStrength(sender: AnyObject)
    {
        if(p.points > 0)
        {
            p.strength += 1;
            p.points -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractMagic(sender: AnyObject)
    {
        if(p.magic > original.magic)
        {
            p.magic -= 1;
            p.points += 1;
            updateLabels();
        }
    }

    
    @IBAction func AddMagic(sender: AnyObject)
    {
        if(p.points > 0)
        {
            p.magic += 1;
            p.points -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractSpeed(sender: AnyObject)
    {
        if(p.speed > original.speed)
        {
            p.speed -= 1;
            p.points += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddSpeed(sender: AnyObject)
    {
        if(p.points > 0)
        {
            p.speed += 1;
            p.points -= 1;
            updateLabels();
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
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
            
            var plStats:[String:[String:Int]] = [:]
            if (prefs.objectForKey("playerStats") != nil) {
                plStats = prefs.objectForKey("playerStats") as [String:[String:Int]]
            }
            var stats = ["level": p.level, "health":p.health, "magic":p.magic, "speed":p.speed, "strength":p.strength, "assignpoints":p.points]
            plStats[playerID] = stats
            
            prefs.removeObjectForKey("speedFloat")
            prefs.removeObjectForKey("magichour")
            prefs.removeObjectForKey("magicGoal")
            prefs.removeObjectForKey("magicSteps")
            prefs.removeObjectForKey("healthGoal")
            prefs.removeObjectForKey("encounterStep")
            prefs.removeObjectForKey("enemiesBeaten")
            prefs.removeObjectForKey("enemiesGoal")
            prefs.setObject(plStats, forKey: "playerStats")
            prefs.setObject(accounts, forKey: "useraccounts")
            
            postLog("My health is \(p.health)")
            
            var nextVC = segue.destinationViewController as MapViewController
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

