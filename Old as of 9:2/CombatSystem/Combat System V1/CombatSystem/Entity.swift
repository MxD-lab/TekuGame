//
//  Entity.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/18/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

class Entity
{
    var name:String;
    var level:Int;
    var health:Int;
    var currentHealth:Int;
    var strength:Int;
    var magic:Int;
    var speed:Int;
    var dead:Bool;
    init()
    {
        self.name = "";
        self.level = 0;
        self.health = 0;
        self.currentHealth = 0;
        self.strength = 0;
        self.magic = 0;
        self.speed = 0;
        self.dead = false;
    }
    init(name:String, level:Int, health:Int, strength:Int, magic:Int, speed:Int)
    {
        self.name = name;
        self.level = level;
        self.health = health;
        self.currentHealth = health;
        self.strength = strength;
        self.magic = magic;
        self.speed = speed;
        self.dead = false;
    }
}
