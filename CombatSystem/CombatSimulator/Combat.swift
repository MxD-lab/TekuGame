//
//  Combat.swift
//  CombatSimulator
//
//  Created by Maxwell Perlman on 8/20/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import UIKit
import Foundation

func encounter(p:player, e:enemy) -> Void
{
    var random = arc4random_uniform(2);
    var turnPlayer:Bool = false;
    var isDead:Bool = false;
    switch(random)
    {
    case 1:
        turnPlayer = true;
        break;
    default:
        turnPlayer = false;
        break;
    }
    while(!isDead)
    {
        switch(turnPlayer)
        {
        case true:
            println("   Player's move...");
            e.currentHealth -= 5;
            println("       Enemy Current Health: \(e.currentHealth)");
            break;
        default:
            println("   Enemy's move...");
            /*switch(e.type)
            {
            case Types.Humanoid:
                break;
            case Types.Insect:
                break;
            case Types.Alien:
                break;
            case Types.Beast:
                break;
            case Types.Construct:
                break;
            case Types.Undead:
                break;
            case Types.Elemental:
                break;
            case Types.Slime:
                break;
            case Types.Demon:
                break;
            case Types.Dragon:
                break;
            default:
                break;
            }*/
            p.currentHealth -= 5;
            println("       Player Current Health: \(p.currentHealth)");
            break;
        }
        if(p.currentHealth <= 0)
        {
            isDead = true;
            println("      Player Died");
        }
        if(e.currentHealth <= 0)
        {
            isDead = true;
            println("      Enemy Died");
        }
        turnPlayer = !turnPlayer;
    }
}