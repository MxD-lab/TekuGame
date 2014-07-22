//
//  Combat.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/22/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation
import UIKit

func encounter(textArea: UITextView, enemy:Enemy, players:Player ...) -> Void
{
    var player:Player;
    printText(textArea, "Enemy encountered: Type: \(enemy.type) : Name: \(enemy.name)");
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
        printText(textArea, "Entity: \(e.name), Factor \(factor)");
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
                printText(textArea, "INSERT: \(entityFactors.filter({$0.0.name == e.name})[0].0.name)");
                finalList.append(entityFactors.filter({$0.0.name == e.name})[0].0);
            }
        }
    }
}

func doAction(display: UITextView, move:Move, user: Entity, target:Entity) -> Void
{
    
    printText(display, "Action:");
    printText(display, "   User: \(user.name)");
    printText(display, "   Target: \(target.name)");
    printText(display, "   Move: \(move.toRaw())");
    switch(move)
    {
        case Move.empty:
            break;
    /*Physical Moves*/
        case Move.P_Punch:
            var damage = 0;
            damage = user.strength;
            printText(display, "   Damage: \(user.strength) -> \(damage)");
            printText(display, "   \(target.name)'s Current Health: \(target.currentHealth) - \(damage) -> \(target.currentHealth - damage)");
            target.currentHealth -= damage;
            break;
        case Move.P_SweepLeg:
            var damage = 0;
            damage = user.strength - target.strength / 2;
            printText(display, "   Damage: (\(user.strength) - \(target.strength) / 2) -> \(damage)");
            printText(display, "   \(target.name)'s Current Health: \(target.currentHealth) - \(damage) -> \(target.currentHealth - damage)");
            printText(display, "   \(target.name)'s Current Strength: \(target.strength) - \(target.strength/2) -> \(target.strength/2)");
            target.strength /= 2;
            break;
    /*Magical Moves*/
        case Move.M_EnergyBall:
            var damage = 0;
            damage = user.magic - target.magic;
            printText(display, "   Damage: \(damage)");
            printText(display, "   \(target.name)'s Current Health: \(target.currentHealth) - \(damage) -> \(target.currentHealth - damage)");
            target.currentHealth -= damage;
            break;
        default:
            break;
    }
}