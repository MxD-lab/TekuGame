//
//  Enemy.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/18/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

enum Types: String, Printable
{
    case empty = "empty";
    case Slime = "Slime";
    case Tree = "Tree";
    case Ghost = "Ghost";
    case Bird = "Bird";
    static let allTypeValues = [empty, Slime, Tree, Ghost, Bird];
    var description : String
    {
        get
        {
            switch(self)
            {
                case empty:
                    return "empty";
                case Slime:
                    return "Slime";
                case Tree:
                    return "Tree";
                case Ghost:
                    return "Ghost";
                case Bird:
                    return "Bird";
                default:
                    return "";
            }
        }
    }
}

class Enemy: Entity
{
    var type:Types;
    var weakness:String;
    var weaknessValue:Int;
    var resistance:String;
    var resistanceValue:Int;
    
    init()
    {
        self.type = Types.empty;
        self.weakness = "";
        self.weaknessValue = 0;
        self.resistance = "";
        self.resistanceValue = 0;
        super.init();
    }
    
    func setType() -> Void
    {
        self.type = Types.empty;
    }
    
    func setType(newType:Types) -> Void
    {
        self.type = newType;
    }
    
    func setStats(level:Int, health:Int, strength:Int, magic:Int, speed:Int) -> Void
    {
        self.level = level;
        self.health = health;
        self.currentHealth = health;
        self.strength = strength;
        self.magic = magic;
        self.speed = speed;
    }
}