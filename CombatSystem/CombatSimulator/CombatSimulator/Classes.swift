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
    case Humanoid = "Humanoid";
    case Insect = "Insect";
    case Alien = "Alien";
    case Beast = "Beast";
    case Construct = "Construct";
    case Undead = "Undead";
    case Elemental = "Elemental";
    case Slime = "Slime";
    case Demon = "Demon";
    case Dragon = "Dragon";
    case empty = "";
    static let allValues = [Types.Humanoid, Types.Insect, Types.Alien, Types.Beast, Types.Construct, Types.Undead, Types.Elemental, Types.Slime, Types.Demon, Types.Dragon];
    
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
            case Types.Beast:
                return "Beast";
            case Types.Construct:
                return "Construct";
            case Types.Undead:
                return "Undead";
            case Types.Elemental:
                return "Elemental";
            case Types.Slime:
                return "Slime";
            case Types.Demon:
                return "Demon";
            case Types.Dragon:
                return "Dragon";
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
    var currentHealth:Int;
    var currentStrength:Int;
    var currentMagic:Int;
    var currentSpeed:Int;
    var type:Types;
    
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
    var points:Int;
    
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
        self.points = 0;
    }
}
