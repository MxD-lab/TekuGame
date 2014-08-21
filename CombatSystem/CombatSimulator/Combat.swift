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
    var turnPlayer:Bool = false;
    var isDead:Bool = false;
    
    turnPlayer = (p.speed > e.speed ? true : false);
    
    while(!isDead)
    {
        switch(turnPlayer)
        {
        case true:
            println("   Player's move...");
            doAction(p, e, Action.P_Punch);
            println("       Enemy Current Health: \(e.currentHealth)");
            break;
        default:
            println("   Enemy's move...");
            /*
            switch(e.type)
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
            }
            */
            doAction(e, p, Action.P_Punch);
            println("       Player Current Health: \(p.currentHealth)");
            break;
        }
        if(p.currentHealth <= 0)
        {
            isDead = true;
            println("       Player Died");
        }
        if(e.currentHealth <= 0)
        {
            isDead = true;
            println("       Enemy Died");
        }
        turnPlayer = !turnPlayer;
    }
}

func doAction(user:Entity, target:Entity, action:Action)
{
    switch(action)
    {
    case Action.P_Punch:
        var damage:Int = 5;
        if(user.strength > target.strength)
        {
            damage += (user.strength - target.strength)/2;
        }
        target.currentHealth -= damage;
        println("       Damage:\(damage)");
        break;
    case Action.E_EnergyBall:
        var damage:Int = 5;
        if(user.magic > target.magic)
        {
            damage += (user.magic - target.magic)/2;
        }
        target.currentHealth -= damage;
        println("       Damage:\(damage)");
        break;
    default:
        break;
    }
}