//
//  Player.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

class player:Entity
{
    var points:Int;
    override init()
    {
        self.points = 0;
        super.init();
    }
    
    override func printAll() -> Void
    {
        println("\(self)");
        println("   Level:     \(self.level)");
        println("   Points to Assign:  \(self.points)");
        println("   Health:    \(self.health)");
        println("   Strength:  \(self.strength)");
        println("   Magic:     \(self.magic)");
        println("   Speed:     \(self.speed)");
        println("   Current Health:    \(self.currentHealth)");
        println("   Current Strength:  \(self.currentStrength)");
        println("   Current Magic:     \(self.currentMagic)");
        println("   Current Speed:     \(self.currentSpeed)");
    }
}
