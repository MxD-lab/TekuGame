//
//  Utility.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/22/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation
import UIKit

func printText(display: UITextView,input:String) -> Void
{
    display.text = display.text + input + "\n";
    println("\(input)");
}

func printAll(e:Entity) -> Void
{
    println("Name: \(e.name)");
    if(e is Player)
    {
        println("ID: \((e as Player).ID)");
    }
    println("Level: \(e.level)");
    println("Health: \(e.health)");
    println("CurrentHealth: \(e.currentHealth)");
    println("Strength: \(e.strength)");
    println("Magic: \(e.magic)");
    println("Speed: \(e.speed)");
    if(e is Player)
    {
        println("StatPoints: \((e as Player).statPoints)");
    }
    if(e is Enemy)
    {
        println("Type: \((e as Enemy).type)");
    }
    if(e is Enemy)
    {
        println("Resistance: \((e as Enemy).resistance)");
    }
    if(e is Enemy)
    {
        println("ResistanceValue: \((e as Enemy).resistanceValue)");
    }
    if(e is Enemy)
    {
        println("Weakness: \((e as Enemy).weakness)");
    }
    if(e is Enemy)
    {
        println("WeaknessValue: \((e as Enemy).weaknessValue)");
    }
    println("\n");
}

