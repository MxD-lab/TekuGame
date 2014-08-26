//
//  Combat.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

func doAction(user:Entity, target:Entity, action:Action)
{
    println();
    println("Used Action: \(action.typeToStringE())");
    println("Used Action: \(action.typeToStringJ())");
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