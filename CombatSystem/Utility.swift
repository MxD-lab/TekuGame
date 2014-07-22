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

func printAll(textArea: UITextView, e:Entity) -> Void
{
    printText(textArea, "Name: \(e.name)");
    if(e is Player)
    {
        printText(textArea,"ID: \((e as Player).ID)");
    }
    printText(textArea, "Level: \(e.level)");
    printText(textArea, "Health: \(e.health)");
    printText(textArea, "CurrentHealth: \(e.currentHealth)");
    printText(textArea, "Strength: \(e.strength)");
    printText(textArea, "Magic: \(e.magic)");
    printText(textArea, "Speed: \(e.speed)");
    if(e is Player)
    {
        printText(textArea, "StatPoints: \((e as Player).statPoints)");
    }
    if(e is Enemy)
    {
        printText(textArea, "Type: \((e as Enemy).type)");
    }
    if(e is Enemy)
    {
        printText(textArea, "Resistance: \((e as Enemy).resistance)");
    }
    if(e is Enemy)
    {
        printText(textArea, "ResistanceValue: \((e as Enemy).resistanceValue)");
    }
    if(e is Enemy)
    {
        printText(textArea, "Weakness: \((e as Enemy).weakness)");
    }
    if(e is Enemy)
    {
        printText(textArea, "WeaknessValue: \((e as Enemy).weaknessValue)");
    }
    printText(textArea, "\n");
}

