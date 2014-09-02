//
//  Combat.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/22/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation
import SpriteKit

func doAction(move:Move, user: Entity, target:Entity) -> Void
{
    
    println("Action:");
    println("   User: \(user.name)");
    println("   Target: \(target.name)");
    println("   Move: \(move.toRaw())");
    if(target.dead == true)
    {
        println("\(target.name) is dead, you gain nothing from attacking it ...");
    }
    else
    {
        switch(move)
        {
            case Move.empty:
                break;
        /*Physical Moves*/
            case Move.P_Punch:
                var damage = 0;
                damage = user.strength;
                println("   Damage: \(user.strength) - 0 -> \(damage)");
                println("   \(target.name)'s Current Health: \(target.currentHealth) - \(damage) -> \(target.currentHealth - damage)");
                target.currentHealth -= damage;
                break;
            case Move.P_SweepLeg:
                var damage = 0;
                damage = user.strength - target.strength / 2;
                println("   Damage: (\(user.strength) - \(target.strength) / 2) -> \(damage)");
                println("   \(target.name)'s Current Health: \(target.currentHealth) - \(damage) -> \(target.currentHealth - damage)");
                println("   \(target.name)'s Current Strength: \(target.strength) - \(target.strength/2) -> \(target.strength/2)");
                target.strength /= 2;
                target.currentHealth -= damage;
                break;
        /*Magical Moves*/
            case Move.M_EnergyBall:
                var damage = 0;
                damage = user.magic - target.magic;
                println("   Damage: \(damage)");
                println("   \(target.name)'s Current Health: \(target.currentHealth) - \(damage) -> \(target.currentHealth - damage)");
                target.currentHealth -= damage;
                break;
            default:
                break;
        }
        if(target.currentHealth <= 0)
        {
            target.dead = true;
            println("\(target.name) was defeated ...");
        }
    }
}

func setCombatOrder(enemy:Enemy, players:Player ...) -> [Entity]
{
    var player:Player;
    println("Enemy encountered: Type: \(enemy.type) : Name: \(enemy.name)");
    var sortedArray = [Entity]();
    sortedArray.append(enemy);
    for player in players
    {
        sortedArray.append(player);
    }
    sortedArray.sort({$0.speed > $1.speed});
    var greatestFactor:Int = 0;
    var leastFactor = sortedArray[sortedArray.endIndex-1].speed;
    var entityFactors: [(Entity, Int)] = [];
    for e in sortedArray
    {
        var factor: Double = floor(Double(e.speed / leastFactor));
        factor = floor(factor);
        entityFactors.append(e, Int(factor))
        println("Entity: \(e.name), Factor \(factor)");
        if(Int(factor) > greatestFactor)
        {
            greatestFactor = Int(factor);
        }
    }
    var finalList = [Entity]();
    for var n = greatestFactor; n > 0; n -= 1
    {
        for e in sortedArray
        {
            if(entityFactors.filter({$0.0.name == e.name})[0].0.name == e.name && entityFactors.filter({$0.0.name == e.name})[0].1 >= n)
            {
                println("INSERT: \(entityFactors.filter({$0.0.name == e.name})[0].0.name)");
                finalList.append(entityFactors.filter({$0.0.name == e.name})[0].0);
            }
        }
    }
    return finalList;
}
func loadEnemyGFX(enemy:Enemy) -> (SKTexture, SKTexture)
{
    var img1:SKTexture;
    var img2:SKTexture;
    switch(enemy.type)
    {
        case Types.Slime:
            img1 = SKTexture(imageNamed: "slime1.png");
            img2 = SKTexture(imageNamed: "slime2.png");
            break;
        default:
            img1 = SKTexture(imageNamed: "noEnemyFound.png");
            img2 = SKTexture(imageNamed: "noEnemyFound.png");
            break;
    }
    return (img1, img2);
}