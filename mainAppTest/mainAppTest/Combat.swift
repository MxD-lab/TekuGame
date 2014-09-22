//
//  Combat.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

func doAction(user:Entity, target:Entity, action:Action) -> [String:String]
{
    println("User: \(user)");
    println("   Used Action: \(action.typeToStringE())");
    println("   Used Action: \(action.typeToStringJ())");
    var damage:Int = 0;
    switch(action)
        {
    /*PLAYER ACTIONS*/
    case Action.U_Examine:
        return ["damage" : "0", "message" : "Enemy: Health: \(target.currentHealth), Strength: \(target.currentStrength), Magic: \(target.currentMagic), Speed: \(target.currentSpeed)"];
    case Action.P_Uppercut:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.P_Charged_Strike:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : damage + Int(Float(damage * 7/20)));
        target.currentHealth -= damage;
        
        user.currentStrength -= user.strength * 1/10;
        user.currentStrength = ((user.currentStrength < 0) ? 0 : user.currentStrength);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your strength decreased"];
    case Action.P_Meditation:
        user.currentStrength += user.strength * 5/4;
        user.currentSpeed += user.speed * 5/4;
        return ["damage": "0", "message" : "Used \(action.typeToStringE()): your strength and speed increased"];
    case Action.P_Leg_Sweep:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 9/10)));
        target.currentHealth -= damage;
        
        target.currentStrength -= target.strength * 1/10;
        target.currentStrength = ((target.currentStrength < 0) ? 0 : target.currentStrength);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your enemy's strength decreased"];
    case Action.P_Turbo_Strike:
        damage = user.currentSpeed - (target.currentSpeed/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.P_Heart_Strike:
        damage = Int(Float(target.health * 1/10));
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.P_Muscle_Training:
        user.currentStrength += user.strength * 1/2;
        user.currentHealth -= user.health * 1/2;
        user.currentHealth = ((user.currentHealth <= 0) ? 0 : user.currentHealth);
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): your strength increased and your health decreased"];
    case Action.P_Stomp:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : damage);
        damage += target.health / 6;
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.P_Sacrificial_Strike:
        damage = user.currentHealth - 1;
        user.currentHealth = 1;
        damage += (user.currentStrength - (target.currentStrength/2));
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your health was lowered to 1"];
    case Action.P_Overpower:
        if((user.currentHealth + user.currentStrength) >= (target.currentHealth + target.currentStrength))
        {
            damage = user.health + user.strength;
            target.currentHealth -= damage;
            return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): you overpowered your enemy"];
        }
        else
        {
            damage = target.health + target.strength;
            user.currentHealth -= damage;
            return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your enemy overpowered you"];
        }
    case Action.E_EnergyBall:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.E_Icy_Wind:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 9/10)));
        target.currentHealth -= damage;
        
        target.currentMagic -= target.magic * 1/10;
        target.currentMagic = ((target.currentMagic < 0) ? 0 : target.currentMagic);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your enemy's magic power decreased"];
    case Action.E_Barrier:
        user.currentHealth += user.health * 1/4;
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): your health increased"];
    case Action.E_Fireball:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage + Int(Float(damage * 7/20)));
        target.currentHealth -= damage;
        
        user.currentMagic -= user.magic * 1/10;
        user.currentMagic = ((user.currentMagic < 0) ? 0 : user.currentMagic);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your magic power decreased"];
    case Action.E_Sharpen_Mind:
        user.currentMagic += user.magic * 7/20;
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): your magic power increased"];
    case Action.E_Curse:
        target.currentStrength -= target.strength * 1/4;
        target.currentStrength = ((target.currentStrength < 0) ? 0 : target.currentStrength);
        
        target.currentMagic -= target.magic * 1/4;
        target.currentMagic = ((target.currentMagic < 0) ? 0 : target.currentMagic);
        
        target.currentSpeed -= target.speed * 1/4;
        target.currentSpeed = ((target.currentSpeed < 0) ? 0 : target.currentSpeed);
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): your enemy's strength, magic power, and speed decreased"];
    case Action.E_Life_Drain:
        damage = (user.currentMagic - (target.currentMagic/2));
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        
        user.currentHealth += 3/4 * damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): you absorbed some of your opponents health"];
    case Action.E_Decay:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = Int(Float(damage * 7/10));
        
        target.currentStrength -= target.strength * 1/10;
        target.currentStrength = ((target.currentStrength < 0) ? 0 : target.currentStrength);
        
        target.currentMagic -= target.magic * 1/10;
        target.currentMagic = ((target.currentMagic < 0) ? 0 : target.currentMagic);
        
        target.currentSpeed -= target.speed * 1/10;
        target.currentSpeed = ((target.currentSpeed < 0) ? 0 : target.currentSpeed);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your enemy's strength, magic power, and speed decreased"];
    case Action.E_Full_Heal:
        user.currentHealth = user.health;
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): your health was fully restored"];
    case Action.E_Instant_Death:
        var rand:Int = Int(arc4random_uniform(5) + 1);
        damage = ((rand % 5 == 1) ? target.currentHealth : 0);
        target.currentHealth -= damage;
        var didKill:String = (damage > 0) ? "it was successful" : "it failed";
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): \(didKill)"];
        /*Enemy Abilities*/
    case Action.Punch:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.RapidFire:
        var rand:Int = 0;
        for(var i = 0; i < 10; i += 1)
        {
            rand = Int(arc4random_uniform(4) + 1);
            damage += (rand%4 == 1) ? ((user.currentSpeed - (target.currentSpeed/2)) * 3/20) : 0;
        }
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.Cleave:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 5/4)));
        target.currentHealth -= damage;
        
        user.currentStrength -= user.strength * 1/10;
        user.currentStrength = ((user.currentStrength < 0) ? 0 : user.currentStrength);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy strength decreased"];
    case Action.RecklessStrike:
        var rand:Int = Int(arc4random_uniform(5) + 1);
        damage = (rand == 5) ?  (user.currentStrength - (target.currentStrength/2)) * 2 : 0;
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        var didHit:String = (damage > 0) ? "it hit" : "it missed";
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): \(didHit)"];
    case Action.Bite:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.EatDirt:
        user.currentHealth += user.health * 3/20;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy health increased"];
    case Action.EightProngStab:
        var rand:Int = 0;
        for(var i = 0; i < 8; i += 1)
        {
            rand = Int(arc4random_uniform(8) + 1);
            damage += (rand%8 != 1) ? ((user.currentStrength - (target.currentStrength/2)) * 3/20) : 0;
        }
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.HornSmash:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 5/4)));
        target.currentHealth -= damage;
        user.currentHealth -= damage * 1/4;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy hurt itself slightly"];
    case Action.SprayAcid:
        damage = target.currentHealth * 1/4;
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.AetherialFangs:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.Horrify:
        damage = Int(Float(target.currentHealth * (15/100)));
        target.currentHealth -= damage;
        target.currentStrength = target.currentStrength * 85/100;
        target.currentStrength = ((target.currentStrength < 0) ? 0 : target.currentStrength);
        target.currentMagic = (target.currentMagic * 85) / 100;
        target.currentMagic = ((target.currentMagic < 0) ? 0 : target.currentMagic);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your health, strength, and magic decreased"];
    case Action.Meditate:
        user.currentHealth += user.currentHealth/2;
        user.currentStrength += user.currentStrength/2
        user.currentMagic += user.currentMagic/2
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): enemy health, strength, and magic increased"];
    case Action.MindInvasion:
        damage = user.currentMagic - (target.currentMagic/2);
        damage += Int(Float(((user.currentStrength - (target.currentStrength/2)) * 1/2)));
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        
        user.currentMagic = user.currentMagic/2;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy's magic power decreased"];
    case Action.AetherialDarts:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.Burrow:
        user.currentHealth += user.health * 7/20;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy health increased"];
    case Action.FocusEnergy:
        user.currentHealth = user.currentHealth * (85/100);
        user.currentHealth = ((user.currentHealth < 0) ? 0 : user.currentHealth);
        user.currentStrength *= 23/20;
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): enemy health decreased and strength increased"];
    case Action.Rushdown:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 5/4)));
        target.currentHealth -= damage;
        
        user.currentStrength = user.currentStrength  * (75/100);
        user.currentStrength = ((user.currentStrength < 0) ? 0 : user.currentStrength);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy strength decreased"];
    case Action.TriBite:
        var rand:Int = 0;
        var didHurtSelf:String = "";
        for(var i = 0; i < 8; i += 1)
        {
            rand = Int(arc4random_uniform(3) + 1);
            if(rand%3 == 1)
            {
                user.currentHealth -= ((user.currentStrength - (user.currentStrength/2)) * 1/3);
                didHurtSelf = ": enemy hurt itself";
            }
            else
            {
                damage += ((user.currentStrength - (target.currentStrength/2)) * 1/3);
            }
        }
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())\(didHurtSelf)"];
    case Action.UnforseenAttack:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 3/2)));
        target.currentHealth -= damage;
        
        user.currentHealth -= user.currentStrength - (user.currentStrength/2);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy hurt itself"];
    case Action.DefendCore:
        user.currentHealth += user.health * 1/4;
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): enemy health increased"];
    case Action.Enrage:
        user.currentStrength += user.strength * 1/4;
        user.currentMagic += user.magic * 1/4
        return ["damage": "0", "message" : "Used: \(action.typeToStringE()): enemy strength and magic increased"];
    case Action.Crush:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.HeadBash:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.LimbSwing:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 23/20)));
        target.currentHealth -= damage;
        
        user.currentHealth -= user.currentHealth * 3/20;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy hurt itself"];
    case Action.GlancingWing:
        var rand:Int = 0;
        for(var i = 0; i < 2; i += 1)
        {
            rand = Int(arc4random_uniform(3) + 1);
            damage += (rand%3 != 1) ? ((user.currentStrength - (target.currentStrength/2)) * 17/20) : 0;
        }
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.Club:
        var rand:Int = Int(arc4random_uniform(2) + 1);
        damage = (rand%2 == 1) ? user.currentStrength - (target.currentStrength/2): 0;
        damage = ((damage < 0) ? 1 : Int(Float(damage * 3/2)));
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.ScaldingConflagration:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.SuffocatingCurrent:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.SlicingGale:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.CrushingGaea:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.Drain:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 1/2)));
        target.currentHealth -= damage;
        
        user.currentHealth += damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy absorbed your health"];
    case Action.Confuse:
        damage = user.currentStrength - (user.currentStrength/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy caused you to hurt yourself"];
    case Action.Envelop:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 1/2)));
        target.currentHealth -= damage;
        
        target.currentStrength = target.currentStrength * (75/100);
        target.currentMagic = target.currentMagic * (75/100);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your strength and magic power decreased"];
    case Action.Blight:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 4/5)));
        target.currentHealth -= damage;
        
        target.currentStrength = target.currentStrength * (90/100);
        target.currentMagic = target.currentMagic * (90/100);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your strength and magic power decreased"];
    case Action.Smite:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.Engulf:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : damage);
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.TwilightStrike:
        damage = user.currentMagic - (target.currentMagic/2);
        damage += user.currentSpeed - (target.currentSpeed/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 1/2)));
        target.currentHealth -= damage;
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE())"];
    case Action.EradicatingLight:
        damage = user.currentMagic - (target.currentMagic/2);
        damage += user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 4/5)));
        target.currentHealth -= damage;
        
        user.currentHealth = user.currentHealth * (4/5);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): enemy's health decreased"];
    case Action.TailSwing:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 4/5)));
        target.currentHealth -= damage;
        
        target.currentStrength = target.currentMagic * (4/5);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your strength decreased"];
    case Action.Constrict:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 4/5)));
        target.currentHealth -= damage;
        
        target.currentMagic = target.currentMagic * (4/5);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your magic power decreased"];
    case Action.BreathOfIce:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 5/4)));
        target.currentHealth -= damage;
        
        user.currentMagic = user.currentMagic * (3/4);
        target.currentMagic = target.currentMagic * (9/10);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your magic power decreased, your enemy's magic power decreased"];
    case Action.CrushUnderFoot:
        damage = user.currentStrength - (target.currentStrength/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 9/10)));
        target.currentHealth -= damage;
        
        target.currentStrength = target.currentStrength * (9/10);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your strength decreased"];
    case Action.BreathOfFire:
        damage = user.currentMagic - (target.currentMagic/2);
        damage = ((damage < 0) ? 1 : Int(Float(damage * 5/4)));
        target.currentHealth -= damage;
        
        user.currentMagic = user.currentMagic * (9/10);
        target.currentStrength = target.currentSpeed * (9/10);
        return ["damage": "\(damage)", "message" : "Used: \(action.typeToStringE()): your magic power decreased, your enemy's magic power decreased"];
    default:
        return ["":"", "":""];
    }
}