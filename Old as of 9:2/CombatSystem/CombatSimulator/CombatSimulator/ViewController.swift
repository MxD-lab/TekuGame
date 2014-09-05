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
        var newP:player = player();
        
        var iteration:Int = 1;
        
        for t in Types.allValues
        {
            for(var i:Int = 1; i <= 10; i += 1)
            {
                println("-----------------------------");
                println("Enemy Type: \(t) number \(i)");
                e.type = t;
                e.level = i;
                newE = setStats(e);
                newE.level = i;
                newE.type = t;
                newE.currentHealth = newE.health;
                newE.currentStrength = newE.strength;
                newE.currentMagic = newE.magic;
                newE.currentSpeed = newE.speed;
                println("   \(newE.type) : \(newE.level)");
                println("       Health:     \(newE.health)");
                println("       Strength:   \(newE.strength)");
                println("       Magic:      \(newE.magic)");
                println("       Speed:      \(newE.speed)");
                println("       Current Health:     \(newE.currentHealth)");
                println("       Current Strength:   \(newE.currentStrength)");
                println("       Current Magic:      \(newE.currentMagic)");
                println("       Current Speed:      \(newE.currentSpeed)");
                
                for(var j:Int = 0; j < 11; j += 1)
                {
                    println("Case \(j)");
                    var h:Double = 0.0;
                    var st:Double = 0.0;
                    var m:Double = 0.0;
                    var sp:Double = 0.0;
                    p.level = i;
                    switch(j)
                    {
                    case 0:
                        h = 0.52;
                        st = 0.16;
                        m = 0.16;
                        sp = 0.16;
                        break;
                    case 1:
                        h = 0.16;
                        st = 0.52;
                        m = 0.16;
                        sp = 0.16;
                        break;
                    case 2:
                        h = 0.16;
                        st = 0.16;
                        m = 0.52;
                        sp = 0.16;
                        break;
                    case 3:
                        h = 0.16;
                        st = 0.16;
                        m = 0.16;
                        sp = 0.52;
                        break;
                    case 4:
                        h = 0.33;
                        st = 0.33;
                        m = 0.17;
                        sp = 0.17;
                        break;
                    case 5:
                        h = 0.33;
                        st = 0.17;
                        m = 0.33;
                        sp = 0.17;
                        break;
                    case 6:
                        h = 0.33;
                        st = 0.17;
                        m = 0.17;
                        sp = 0.33;
                        break;
                    case 7:
                        h = 0.17;
                        st = 0.33;
                        m = 0.33;
                        sp = 0.17;
                        break;
                    case 8:
                        h = 0.17;
                        st = 0.33;
                        m = 0.17;
                        sp = 0.33;
                        break;
                    case 9:
                        h = 0.17;
                        st = 0.17;
                        m = 0.33;
                        sp = 0.33;
                        break;
                    default:
                        h = 1/4;
                        st = 1/4;
                        m = 1/4;
                        sp = 1/4;
                        break;
                    }
                    var k:Int = 0;
                    k = (newE.type != Types.Elemental) ? 3 : 4;
                    for(var l:Int = 0; l < k; l += 1)
                    {
                        println("Iteration Number \(iteration)");
                        newE.subType = l;
                        
                        newP = setStats(p, h, st, m, sp);
                        newP.level = p.level;
                        newP.currentHealth = newP.health;
                        newP.currentStrength = newP.strength;
                        newP.currentMagic = newP.magic;
                        newP.currentSpeed = newP.speed;
                        println("   New Player:");
                        println("       Level:     \(newP.level)");
                        println("       Health:     \(newP.health)");
                        println("       Strength:   \(newP.strength)");
                        println("       Magic:      \(newP.magic)");
                        println("       Speed:      \(newP.speed)");
                        println("       Current Health:     \(newP.currentHealth)");
                        println("       Current Strength:   \(newP.currentStrength)");
                        println("       Current Magic:      \(newP.currentMagic)");
                        println("       Current Speed:      \(newP.currentSpeed)");
                        println(" ");
                        encounter(newP, newE);
                        iteration += 1;
                        newE.currentHealth = newE.health;
                        newE.currentStrength = newE.strength;
                        newE.currentMagic = newE.magic;
                        newE.currentSpeed = newE.speed;
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning()
    {   super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}