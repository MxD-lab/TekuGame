//
//  Entity.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation


class Entity
{
    var level:Int;
    var health:Int;
    var strength:Int;
    var magic:Int;
    var speed:Int;
    var currentHealth:Int;
    var currentStrength:Int;
    var currentMagic:Int;
    var currentSpeed:Int;
    
    init()
    {
        self.level = 1;
        self.health = 1;
        self.strength = 1;
        self.magic = 1;
        self.speed = 1;
        self.currentHealth = 1;
        self.currentStrength = 1;
        self.currentMagic = 1;
        self.currentSpeed = 1;
    }
    
    func printAll() -> Void
    {
        println("\(self)");
        println("   Level:     \(self.level)");
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