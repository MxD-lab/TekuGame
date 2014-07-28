//
//  Player.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/17/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation
import UIKit

class Player:Entity
{
    /*Traits of characters*/
    var ID:String;
    var statPoints:Int;
    
    init()
    {
        self.ID = "your id here";
        self.statPoints = 0;
        super.init();
        self.assignBaseStats();
    }
    
    func levelUp() -> Void
    {
        self.level = self.level + 1;
        self.statPoints += 5;
    }
    
    func assignBaseStats() -> Void
    {
        var values = [Int(arc4random_uniform(7)+3), Int(arc4random_uniform(7)+3), Int(arc4random_uniform(7)+3), Int(arc4random_uniform(7)+3)];
        //printText("Generate Values:");
        self.health = values[0];
        self.currentHealth = self.health;
        self.strength = values[1];
        self.magic = values[2];
        self.speed = values[3];
    }
    
    func assignStats(display: UITextView, HEALTH:Int, STRENGTH:Int, MAGIC:Int, SPEED:Int) -> Void
    {
        println("---------------------------------------------------");
        println("Stat Assignment on \(self.name)");
        if(HEALTH + STRENGTH + MAGIC + SPEED > self.statPoints)
        {
            println("ERROR: Attempted to assign too many skill points...");
        }
        else
        {
            self.health += HEALTH;
            self.statPoints -= HEALTH;
            println("   Health:     \(self.health - HEALTH) + \(HEALTH) -> \(self.health)");
            self.currentHealth = self.health;
            self.strength += STRENGTH;
            self.statPoints -= STRENGTH;
            println("   Strength:   \(self.strength - STRENGTH) + \(STRENGTH) -> \(self.strength)");
            self.magic += MAGIC;
            self.statPoints -= MAGIC;
            println("   Magic:      \(self.magic - MAGIC) + \(MAGIC) -> \(self.magic)");
            self.speed += SPEED;
            self.statPoints -= SPEED;
            println("   Speed:      \(self.speed - SPEED) + \(SPEED) -> \(self.speed)");
        }
        println("---------------------------------------------------");
    }
}