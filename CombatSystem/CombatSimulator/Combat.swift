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
    
    var movesDone:Int = 0;
    turnPlayer = (p.speed > e.speed ? true : false);
    
    while(!isDead)
    {
        switch(turnPlayer)
        {
        case true:
            println("   Player's move...");
            (p.currentStrength >= p.currentMagic) ? doAction(p, e, Action.P_Uppercut) : doAction(p, e, Action.E_EnergyBall);
            movesDone += 1;
            break;
        default:
            println("   Enemy's move...");
            switch(e.type)
            {
            case Types.Humanoid:
                doAction(e, p, Action.P_Uppercut);
                break;
            case Types.Insect:
                doAction(e, p, Action.P_Uppercut);
                break;
            case Types.Alien:
                doAction(e, p, Action.E_EnergyBall);
                break;
            case Types.Beast:
                doAction(e, p, Action.P_Uppercut);
                break;
            case Types.Construct:
                doAction(e, p, Action.P_Uppercut);
                break;
            case Types.Undead:
                doAction(e, p, Action.P_Uppercut);
                break;
            case Types.Elemental:
                doAction(e, p, Action.E_EnergyBall);
                break;
            case Types.Slime:
                doAction(e, p, Action.E_EnergyBall);
                break;
            case Types.Demon:
                doAction(e, p, Action.E_EnergyBall);
                break;
            case Types.Dragon:
                (e.currentStrength >= e.currentMagic) ? doAction(e, p, Action.P_Uppercut) : doAction(e, p, Action.E_EnergyBall);
                break;
            default:
                break;
            }
            movesDone += 1;
            break;
        }
        if(p.currentHealth <= 0)
        {
            isDead = true;
            println("       Moves Taken: \(movesDone) ");
            println("       Player Died");
        }
        if(e.currentHealth <= 0)
        {
            isDead = true;
            println("       Moves Taken: \(movesDone) ");
            println("       Enemy Died");
        }
        turnPlayer = !turnPlayer;
    }
}

func doAction(user:Entity, target:Entity, action:Action)
{
    println("       Used Action: \(action.typeToStringE())");
    println("       Used Action: \(action.typeToStringJ())");
    var damage:Int = 0;
    switch(action)
    {
    /*PLAYER ACTIONS*/
    case Action.U_Examine:
        break;
    case Action.P_Uppercut:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.P_Charged_Strike:
        damage = (user.currentStrength - (target.currentStrength/2)) * 1.35;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentStrength -= user.strength * 0.1;
        user.currentStrength = ((user.currentStrength < 0) ? 0 : user.currentStrength);
        break;
    case Action.P_Meditation:
        user.currentStrength += user.strength * 1.25;
        user.currentSpeed += user.speed * 1.25;
        break;
    case Action.P_Leg_Sweep:
        damage = (user.currentStrength - (target.currentStrength/2)) * 0.9;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        target.currentStrength -= target.strength * 0.1;
        target.currentStrength = ((target.currentStrength < 0) ? 0 : target.currentStrength);
        break;
    case Action.P_Turbo_Strike:
        damage = user.currentSpeed - (target.currentSpeed/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.P_Heart_Strike:
        damage = target.health * 0.1;
        target.currentHealth -= damage;
        break;
    case Action.P_Muscle_Training:
        user.currentStrength += user.strength * 0.5;
        user.currentHealth -= user.health * 0.5;
        user.currentHealth = ((user.currentHealth <= 0) ? 0 : user.currentHealth);
        break;
    case Action.P_Stomp:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 0 : damage);
        damage += target.health / 6;
        target.currentHealth -= damage;
        break;
    case Action.P_Sacrificial_Strike:
        damage = user.currentHealth - 1;
        user.currentHealth = 1;
        damage += (user.currentStrength - (target.currentStrength/2));
        target.currentHealth -= damage;
        break;
    case Action.P_Overpower:
        if((user.currentHealth + user.currentStrength + user.currentSpeed) >= (target.currentHealth + target.currentStrength + target.currentSpeed))
        {
            damage = user.health + user.strength;
            target.currentHealth -= damage;
        }
        else
        {
            damage = target.health + target.strength;
            user.currentHealth -= damage;
        }
        break;
    case Action.E_EnergyBall:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.E_Icy_Wind:
        damage = (user.currentMagic - (target.currentMagic/2) * 0.9);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        target.currentMagic -= target.magic * 0.1;
        target.currentMagic = ((target.currentMagic < 0) ? 0 : target.currentMagic);
        break;
    case Action.E_Barrier:
        user.currentHealth += user.health * 0.25;
        break;
    case Action.E_Fireball:
        damage = (user.currentMagic - (target.currentMagic/2)) * 1.35;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentMagic -= user.magic * 0.1;
        user.currentMagic = ((user.currentMagic < 0) ? 0 : user.currentMagic);
        break;
    case Action.E_Sharpen_Mind:
        user.currentMagic += user.magic * 0.35;
        break;
    case Action.E_Curse:
        target.currentStrength -= target.strength * 0.75;
        target.currentStrength = ((target.currentStrength < 0) ? 0 : target.currentStrength);
        
        target.currentMagic -= target.magic * 0.75;
        target.currentMagic = ((target.currentMagic < 0) ? 0 : target.currentMagic);
        
        target.currentSpeed -= target.speed * 0.75;
        target.currentSpeed = ((target.currentSpeed < 0) ? 0 : target.currentSpeed);
        break;
    case Action.E_Life_Drain:
        damage = (user.currentMagic - (target.currentMagic/2));
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentHealth += 0.75 * damage;
        break;
    case Action.E_Decay:
        damage = (user.currentMagic - (target.currentMagic/2)) * 0.7;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;

        target.currentStrength -= target.strength * 0.1;
        target.currentStrength = ((target.currentStrength < 0) ? 0 : target.currentStrength);
        
        target.currentMagic -= target.magic * 0.1;
        target.currentMagic = ((target.currentMagic < 0) ? 0 : target.currentMagic);
        
        target.currentSpeed -= target.speed * 0.1;
        target.currentSpeed = ((target.currentSpeed < 0) ? 0 : target.currentSpeed);
        break;
    case Action.E_Full_Heal:
        user.currentHealth = user.health;
        break;
    case Action.E_Instant_Death:
        var rand:Int = Int(arc4random_uniform(5) + 1);
        target.currentHealth = ((rand % 5 == 0) ? 0 : target.currentHealth);
        break;
    default:
        break;
    }
}