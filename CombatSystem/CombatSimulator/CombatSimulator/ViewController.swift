//
//  ViewController.swift
//  CombatSimulator
//
//  Created by Maxwell Perlman on 8/19/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
                            
    override func viewDidLoad()
    {   super.viewDidLoad()
        
        var p = player();
        var e = enemy();
        
        var newE:enemy = enemy();
        
        for t in Types.allValues
        {
            for(var i:Int = 1; i <= 10; i += 1)
            {
                e.type = t;
                e.level = i;
                newE.level = i;
                newE = setStats(e);
                newE.type = t;
                println("\(newE.type) : \(newE.level)");
                println("   Health:     \(newE.health)");
                println("   Strength:   \(newE.strength)");
                println("   Magic:      \(newE.magic)");
                println("   Speed:      \(newE.speed)");
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

