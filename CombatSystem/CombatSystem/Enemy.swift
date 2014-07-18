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
            return self.toRaw();
        }
    }
}

class Enemy: Entity
{
    var type:Types;
    var weakness:Jobs;
    var weaknessValue:Int;
    var resistance:Jobs;
    var resistnaceValue:Int;
    
    init()
    {
        self.type = Types.empty;
        self.weakness = Jobs.none;
        self.weaknessValue = 0;
        self.resistance = Jobs.none;
        self.resistnaceValue = 0;
        super.init();
    }
    
    func setType() -> Void
    {
        self.type = Types.empty;
        self.setWeaknessResistanceValues();
    }
    
    func setType(newType:Types) -> Void
    {
        self.type = newType;
        self.setWeaknessResistanceValues();
    }
    
    func setWeaknessResistanceValues()
    {
        var filePath = NSBundle.mainBundle().pathForResource("enemies", ofType: "json");
        var nsMutData = NSData(contentsOfFile: filePath);
        let jsonObject:AnyObject! = NSJSONSerialization.JSONObjectWithData(nsMutData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        //println(jsonObject)
        if let ar = jsonObject as? NSDictionary{
            if let enem = ar["enemies"] as? NSArray {
                //println("enemcount: \(enem.count)")
                for enemies in enem {
                    println("------------------");
                    if let enemtype = enemies as? NSDictionary {
                        println("Type:");
                        println(enemtype["type"]);
                        println("Resistance:");
                        println(enemtype["resistance"]);
                        println("ResistanceVal:");
                        println(enemtype["resistanceVal"]);
                        println("Weakness:");
                        println(enemtype["weakness"]);
                        println("WeaknessVal:");
                        println(enemtype["weaknessVal"]);
                    }
                }
                println("------------------");
            }
        }
        println("SELF.WEAKNESS: \(self.weakness)");
        
        
    }
}