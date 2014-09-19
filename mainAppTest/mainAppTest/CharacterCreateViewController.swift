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
        p.health = 10;
        p.strength = 5;
        p.magic = 5;
        p.speed = 5;
        p.points = 20;
        
        original.health = p.health;
        original.strength = p.strength;
        original.magic = p.magic;
        original.speed = p.speed;
        original.points = p.points;
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
            
            var plStats:[String:[String:AnyObject]] = [:]
            if (prefs.objectForKey("playerStats") != nil) {
                plStats = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
            }
            
            var magicHour = Int(arc4random_uniform(16)) + 8
            var enemyStepCount = 0
            updateEncounterStep(&enemyStepCount, 0)
            
            var stats = ["level": p.level, "health":p.health, "strength":p.strength, "magic":p.magic, "speed":p.speed, "assignpoints":p.points, "exp":p.exp, "speedProgress":0, "enemiesDefeated":0, "magicHour":magicHour, "magicSteps":0, "date":returnDateString(), "healthGoal":5000, "strengthGoal":3, "magicGoal":1000, "enemyStepCount":enemyStepCount] as [String:AnyObject]
            
            plStats[playerID] = stats
            
            prefs.setObject(plStats, forKey: "playerStats")
            prefs.setObject(accounts, forKey: "useraccounts")
            prefs.setObject(playerID, forKey: "currentuser")
            
            postLog("Created character. Health: \(p.health), magic: \(p.magic), speed: \(p.speed), strength: \(p.strength), remaining points: \(p.points)")
            
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

