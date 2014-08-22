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
            //doAction(p, e, Action.P_Punch);
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
            //doAction(e, p, Action.P_Punch);
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
    println("Used Action: \(action.typeToStringE())");
    println("Used Action: \(action.typeToStringJ())");
    switch(action)
    {
    case Action.U_Examine:
        break;
    case Action.P_Uppercut:
        break;
    case Action.P_Charged_Strike:
        break;
    case Action.P_Meditation:
        break;
    case Action.P_Leg_Sweep:
        break;
    case Action.P_Turbo_Strike:
        break;
    case Action.P_Heart_Strike:
        break;
    case Action.P_Muscle_Training:
        break;
    case Action.P_Bide_Time:
        break;
    case Action.P_Sacrificial_Strike:
        break;
    case Action.P_Overpower:
        break;
    case Action.E_EnergyBall:
        break;
    case Action.E_Icy_Wind:
        break;
    case Action.E_Barrier:
        break;
    case Action.E_Fireball:
        break;
    case Action.E_Sharpen_Mind:
        break;
    case Action.E_Curse:
        break;
    case Action.E_Life_Drain:
        break;
    case Action.E_Decay:
        break;
    case Action.E_Full_Heal:
        break;
    case Action.E_Instant_Death:
        break;
    default:
        break;
    }
}