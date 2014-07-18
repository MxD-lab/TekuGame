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
    var strength:Int;
    var magic:Int;
    var speed:Int;
    init()
    {
        self.name = "";
        self.level = 0;
        self.health = 0;
        self.strength = 0;
        self.magic = 0;
        self.speed = 0;
    }
}
