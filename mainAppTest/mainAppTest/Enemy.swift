//
//  Enemy.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

class enemy:Entity
{
    var type:Types;
    var subType:Int;
     override init()
    {
        self.type = Types.empty;
        self.subType = 0;
        super.init();
    }
    init(t:Types)
    {
        self.type = t;
        self.subType = 0;
        super.init();
    }
    init(s:Int)
    {
        self.type = Types.empty;
        self.subType = s;
        super.init();
    }
    init(t:Types, s:Int)
    {
        self.type = t;
        self.subType = s;
        super.init();
    }
    override func printAll() -> Void
    {
        println("\(self)");
        println("   Level:     \(self.level)");
        println("   Type:      \(self.type.typeToStringE())");
        println("   Type:      \(self.type.typeToStringJ())");
        println("   SubType:   \(self.subType)");
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