//
//  Utility.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/21/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation


func printAll(e:Entity) -> Void
{
    printText("Name: \(e.name)");
    //printText("ID: \(e.ID)");
    if(e is Player)
    {
        
    }
    printText("Level: \(e.level)");
    printText("Health: \(e.health)");
    printText("Strength: \(e.strength)");
    printText("Magic: \(e.magic)");
    printText("Speed: \(e.speed)");
    //printText("StatPoints: \(e.statPoints)");
    printText("\n");
}