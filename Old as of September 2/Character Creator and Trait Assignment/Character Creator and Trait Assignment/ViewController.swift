//
//  ViewController.swift
//  Character Creator and Trait Assignment
//
//  Created by Maxwell Perlman on 8/26/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
                            
    @IBOutlet weak var HealthLabel: UILabel!
    @IBOutlet weak var StrengthLabel: UILabel!
    @IBOutlet weak var MagicLabel: UILabel!
    @IBOutlet weak var SpeedLabel: UILabel!
    @IBOutlet weak var PointsLabel: UILabel!
    
    class player
    {
        var health:Int;
        var strength:Int;
        var magic:Int;
        var speed:Int;
        var assignPoints:Int;
        init()
        {
            self.health = 0;
            self.strength = 0;
            self.magic = 0;
            self.speed = 0;
            self.assignPoints = 5;
        }
    }
    
    var p:player = player();
    var original:player = player();
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        p.health = 5;
        p.strength = 4;
        p.magic = 3;
        p.speed = 2;
        
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
        PointsLabel.text = "Remaining Points: \(p.assignPoints)";
    }
    
    @IBAction func Reset(sender: AnyObject)
    {
        p.health = original.health;
        p.strength = original.strength;
        p.magic = original.magic;
        p.speed = original.speed;
        p.assignPoints = original.assignPoints;
        updateLabels();
    }
    
    @IBAction func SubtractHealth(sender: AnyObject)
    {
        if(p.health > original.health)
        {
            p.health -= 1;
            p.assignPoints += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddHealth(sender: AnyObject)
    {
        if(p.assignPoints > 0)
        {
            p.health += 1;
            p.assignPoints -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractStrength(sender: AnyObject)
    {
        if(p.strength > original.strength)
        {
            p.strength -= 1;
            p.assignPoints += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddStrength(sender: AnyObject)
    {
        if(p.assignPoints > 0)
        {
            p.strength += 1;
            p.assignPoints -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractMagic(sender: AnyObject)
    {
        if(p.magic > original.magic)
        {
            p.magic -= 1;
            p.assignPoints += 1;
            updateLabels();
        }
    }

    
    @IBAction func AddMagic(sender: AnyObject)
    {
        if(p.assignPoints > 0)
        {
            p.magic += 1;
            p.assignPoints -= 1;
            updateLabels();
        }
    }
    
    @IBAction func SubtractSpeed(sender: AnyObject)
    {
        if(p.speed > original.speed)
        {
            p.speed -= 1;
            p.assignPoints += 1;
            updateLabels();
        }
    }
    
    @IBAction func AddSpeed(sender: AnyObject)
    {
        if(p.assignPoints > 0)
        {
            p.speed += 1;
            p.assignPoints -= 1;
            updateLabels();
        }
    }
}
