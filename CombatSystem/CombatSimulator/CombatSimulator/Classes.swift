//
//  Classes.swift
//  CombatSimulator
//
//  Created by Maxwell Perlman on 8/19/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

enum Types:String, Printable
{
    case Humanoid = "Humanoid"
    case Insect = "Insect"
    case Alien = "Alien"
    case empty = "";
    static let allValues = [Types.Humanoid, Types.Insect, Types.Alien];
    
    var description:String
    {
        get
        {
            return self.toRaw();
        }
    }
    
    func typeToString() -> String
    {
        switch(self)
        {
            case Types.Humanoid:
                return "Humanoid";
            case Types.Insect:
                return "Insect";
            case Types.Alien:
                return "Alien";
            default:
                return "";
        }
    }
}

class enemy
{
    var level:Int;
    var health:Int;
    var strength:Int;
    var magic:Int;
    var speed:Int;
    var type:Types;
    
    init()
    {
        self.level = 1;
        self.health = 1;
        self.strength = 1;
        self.magic = 1;
        self.speed = 1;
        self.type = Types.empty;
    }
}

class player
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
}
