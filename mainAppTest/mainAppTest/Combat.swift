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
    println("User: \(user)");
    println("   Used Action: \(action.typeToStringE())");
    println("   Used Action: \(action.typeToStringJ())");
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
        if((user.currentHealth + user.currentStrength) >= (target.currentHealth + target.currentStrength))
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
        target.currentHealth = ((rand % 5 == 1) ? 0 : target.currentHealth);
        break;
    /*Enemy Abilities*/
    case Action.Punch:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.RapidFire:
        var rand:Int = 0;
        for(var i = 0; i < 10; i += 1)
        {
            rand = Int(arc4random_uniform(4) + 1);
            damage += (rand%4 == 1) ? ((user.currentSpeed - (target.currentSpeed/2)) * 0.15) : 0;
        }
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.Cleave:
        damage = (user.currentStrength - (target.currentStrength/2)) * 1.25;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentStrength -= user.strength * 0.9;
        user.currentStrength = ((user.currentStrength < 0) ? 0 : user.currentStrength);
        break;
    case Action.RecklessStrike:
        var rand:Int = Int(arc4random_uniform(5) + 1);
        damage = (rand == 5) ?  (user.currentStrength - (target.currentStrength/2)) * 2 : 0;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.Bite:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.EatDirt:
        user.currentHealth += user.health * 0.1;
        user.currentHealth = (user.currentHealth > user.health) ? user.health : 0;
        break;
    case Action.EightProngStab:
        var rand:Int = 0;
        for(var i = 0; i < 8; i += 1)
        {
            rand = Int(arc4random_uniform(8) + 1);
            damage += (rand%8 != 1) ? ((user.currentStrength - (target.currentStrength/2)) * 0.15) : 0;
        }
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.HornSmash:
        damage = (user.currentStrength - (target.currentStrength/2)) * 1.25;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        user.currentHealth -= damage * 0.25;
        break;
    case Action.SprayAcid:
        damage = target.currentHealth * 0.25;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.AetherialFangs:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.Horrify:
        target.currentHealth *= 0.85;
        target.currentStrength *= 0.85;
        target.currentStrength = ((target.currentStrength < 0) ? 0 : target.currentStrength);
        target.currentMagic *= 0.85;
        target.currentMagic = ((target.currentMagic < 0) ? 0 : target.currentMagic);
        break;
    case Action.Meditate:
        user.currentHealth *= 1.05;
        user.currentStrength *= 1.05;
        user.currentMagic *= 1.05;
        break;
    case Action.MindInvasion:
        damage = user.currentMagic - (target.currentMagic/2);
        damage += ((user.currentStrength - (target.currentStrength/2)) * 0.5);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentMagic *= 0.5;
        break;
    case Action.AetherialDarts:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.Burrow:
        user.currentHealth += user.health * 0.35;
        break;
    case Action.FocusEnergy:
        user.currentHealth *= 0.85;
        user.currentHealth = ((user.currentHealth < 0) ? 0 : user.currentHealth);
        user.currentStrength *= 1.15;
        break;
    case Action.Rushdown:
        damage = ((user.currentStrength - (target.currentStrength/2)) * 1.25);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentStrength *= 0.75;
        user.currentStrength = ((user.currentStrength < 0) ? 0 : user.currentStrength);
        break;
    case Action.TriBite:
        var rand:Int = 0;
        for(var i = 0; i < 8; i += 1)
        {
            rand = Int(arc4random_uniform(3) + 1);
            if(rand%3 == 1)
            {
                user.currentHealth -= ((user.currentStrength - (user.currentStrength/2)) * 0.33);
            }
            else
            {
                damage += ((user.currentStrength - (target.currentStrength/2)) * 0.33);
            }
        }
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.UnforseenAttack:
        damage = (user.currentStrength - (target.currentStrength/2)) * 1.5;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentHealth -= user.currentStrength - (user.currentStrength/2);
        break;
    case Action.DefendCore:
        user.currentHealth += user.health * 0.25;
        break;
    case Action.Enrage:
        user.currentStrength += user.strength * 0.25;
        user.currentMagic += user.magic * 0.25
        break;
    case Action.Crush:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.HeadBash:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.LimbSwing:
        damage = (user.currentStrength - (target.currentStrength/2)) * 1.15;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentHealth -= user.currentHealth * 0.15;
        break;
    case Action.GlancingWing:
        var rand:Int = 0;
        for(var i = 0; i < 2; i += 1)
        {
            rand = Int(arc4random_uniform(3) + 1);
            damage += (rand%3 != 1) ? ((user.currentStrength - (target.currentStrength/2)) * 0.85) : 0;
        }
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.Club:
        var rand:Int = Int(arc4random_uniform(2) + 1);
        damage = (rand%2 == 1) ? (user.currentStrength - (target.currentStrength/2)) * 1.5 : 0;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.ScaldingConflagration:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.SuffocatingCurrent:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.SlicingGale:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.CrushingGaea:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.Drain:
        damage = (user.currentMagic - (target.currentMagic/2)) * 0.25;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentHealth += damage;
        break;
    case Action.Confuse:
        var temp:[Int] = [target.currentHealth, target.currentStrength, target.currentMagic];
        user.currentHealth = temp[1];
        user.currentStrength = temp[2]
        user.currentMagic = temp[0];
        break;
    case Action.Envelop:
        damage = (user.currentStrength - (target.currentStrength/2) * 0.5);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        target.currentStrength *= 0.75;
        target.currentMagic *= 0.75;
        break;
    case Action.Blight:
        damage = (user.currentMagic - (target.currentMagic/2) * 0.8);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        target.currentStrength *= 0.9;
        target.currentMagic *= 0.9;
        break;
    case Action.Smite:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.Engulf:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.TwilightStrike:
        damage = (user.currentMagic - (target.currentMagic/2)) * 0.5;
        damage += (user.currentSpeed - (target.currentSpeed/2)) * 0.5;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        break;
    case Action.EradicatingLight:
        damage = (user.currentMagic - (target.currentMagic/2)) * 0.8;
        damage += (user.currentStrength - (target.currentStrength/2)) * 0.8;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentHealth *= 0.8;
        break;
    case Action.TailSwing:
        damage = (user.currentStrength - (target.currentStrength/2)) * 0.8;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        target.currentStrength *= 0.8;
        break;
    case Action.Constrict:
        damage = (user.currentStrength - (target.currentStrength/2)) * 0.8;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        target.currentMagic *= 0.8;
        break;
    case Action.BreathOfIce:
        damage = (user.currentMagic - (target.currentMagic/2)) * 1.25;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentMagic *= 0.75;
        target.currentMagic *= 0.9
        break;
    case Action.CrushUnderFoot:
        damage = (user.currentStrength - (target.currentStrength/2)) * 0.9;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        target.currentStrength *= 0.9;
        break;
    case Action.BreathOfFire:
        damage = (user.currentMagic - (target.currentMagic/2)) * 1.25;
        damage = ((damage < 0) ? 0 : damage);
        target.currentHealth -= damage;
        
        user.currentMagic *= 0.75;
        target.currentStrength *= 0.9
        break;
    default:
        break;
    }
    
    user.printAll();
    target.printAll();
}