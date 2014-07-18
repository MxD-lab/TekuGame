//
//  Player.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/17/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

enum Jobs: String, Printable
{
    case none = "none"; /*THIS IS NOT AN ACTUAL CLASS, ONLY USED TO INDICATE A NO CLASS WEAKNESSES OR RESISTANCE FOR ENEMY*/
    case Adventurer = "Adventurer";
    case Warrior = "Warrior";
    case Mage = "Mage";
    case Ranger = "Ranger";
    static let allJobsValues = [none, Adventurer, Warrior, Mage, Ranger];
    var description : String
    {
        get
        {
            return self.toRaw();
        }
    }
}

class Player:Entity
{
    /*Traits of characters*/
    var ID:String;
    var job:Jobs;
    var statPoints:Int;
    
    init()
    {
        self.ID = "your id here";
        self.job = Jobs.Adventurer;
        self.statPoints = 0;
        super.init();
        self.setBaseValues();
    }
    
    func levelUp() -> Void
    {
        self.level = self.level + 1;
        self.statPoints += 5;
    }
    
    func setJob() -> Void
    {
        self.job = Jobs.Adventurer;
        self.setBaseValues();
    }
    
    func setJob(newJob:Jobs) -> Void
    {
        self.job = newJob;
        self.setBaseValues();
    }
    
    func setBaseValues() -> Void
    {
        switch self.job
        {
            case Jobs.Adventurer:
                self.health = 5;
                self.strength = 5;
                self.magic = 5;
                self.speed = 5;
            case Jobs.Warrior:
                self.health = 8;
                self.strength = 9;
                self.magic = 0;
                self.speed = 3;
            case Jobs.Mage:
                self.health = 5;
                self.strength = 0;
                self.magic = 9;
                self.speed = 6;
            case Jobs.Ranger:
                self.health = 4;
                self.strength = 7;
                self.magic = 0;
                self.speed = 9;
            default:
                self.health = 0;
                self.strength = 0;
                self.magic = 0;
                self.speed = 0;
        }
    }
    
    func assignStats(HEALTH:Int, STRENGTH:Int, MAGIC:Int, SPEED:Int) -> Void
    {
        println("--------------------------------");
        println("Operation on \(self.name)");
        if(HEALTH + STRENGTH + MAGIC + SPEED > self.statPoints)
        {
            println("ERROR: Attempted to assign too many skill points");
        }
        else
        {
            self.health += HEALTH;
                self.statPoints -= HEALTH;
                println("   Health:     \(self.health - HEALTH) + \(HEALTH) -> \(self.health)");
            self.strength += STRENGTH;
                self.statPoints -= STRENGTH;
                println("   Strength:   \(self.strength - STRENGTH) + \(STRENGTH) -> \(self.strength)");
            self.magic += MAGIC;
                self.statPoints -= MAGIC;
                println("   Magic:      \(self.magic - MAGIC) + \(MAGIC) -> \(self.magic)");
            self.speed += SPEED;
                self.statPoints -= SPEED;
                println("   Speed:      \(self.speed - SPEED) + \(SPEED) -> \(self.speed)");
        }
        println("--------------------------------");
    }
    
    func printAll() -> Void
    {
        println("-----------------------");
        println("Name:      \(self.name)");
        println("ID:        \(self.ID)");
        switch self.job
        {
            case Jobs.Adventurer:
                println("Job:       Adventurer");
            case Jobs.Warrior:
                println("Job        Warrior");
            case Jobs.Mage:
                println("Job:       Mage");
            case Jobs.Ranger:
                println("Job:       Ranger");
            default:
                println("Job:       Unasigned");
        }
        println("Level:     \(self.level)");
        println("Health:    \(self.health)");
        println("Strength:  \(self.strength)");
        println("Magic:     \(self.magic)");
        println("Speed:     \(self.speed)");
        println("StatPoints:\(self.statPoints)");
        println("------------------------");
    }
}