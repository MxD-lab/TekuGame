//
//  Set Trait Values.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation
func setStats(e:enemy) -> enemy
{
    var newE:enemy = enemy(t: e.type);
    var vals:(Int,Int,Int) = (0,0,0);
    switch(e.type)
        {
    case Types.Humanoid:
        vals = setMedium(e);
        /*Health:   Linear - Medium*/
        newE.health = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Strength: Linear - Medium*/
        newE.strength = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Linear - Medium*/
        newE.magic = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Linear - Medium*/
        newE.speed = setLinear(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Insect:
        /*Health:   Linear - Very Low*/
        vals = setVeryLow(e);
        newE.health = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Strength: Linear - Low*/
        vals = setLow(e);
        newE.strength = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Exponential - Low*/
        vals = setLow(e);
        newE.magic = setExponential(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Logarithmic - Very High*/
        vals = setVeryHigh(e);
        newE.speed = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Alien:
        /*Health:   Logarithmic - Medium*/
        vals = setMedium(e);
        newE.health = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Strength: Logarithmic - Low*/
        vals = setLow(e);
        newE.strength = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Linear - Very High*/
        vals = setVeryHigh(e);
        newE.magic = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Exponential - Low*/
        vals = setLow(e);
        newE.speed = setExponential(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Beast:
        /*Health:   Exponential - Very High*/
        vals = setVeryHigh(e);
        newE.health = setExponential(e.level, vals.0, vals.1, vals.2);
        /*Strength: Exponential - High*/
        vals = setHigh(e);
        newE.strength = setExponential(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Logarithmic - Very Low*/
        vals = setVeryLow(e);
        newE.magic = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Exponential - Very Low*/
        vals = setVeryLow(e);
        newE.speed = setExponential(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Construct:
        /*Health:   Linear - Medium*/
        vals = setMedium(e);
        newE.health = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Strength: Linear - High*/
        vals = setHigh(e);
        newE.strength = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Logarithmic - High*/
        vals = setHigh(e);
        newE.magic = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Exponential - Very Low*/
        vals = setVeryLow(e);
        newE.speed = setExponential(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Undead:
        /*Health:   Logarithmic - High*/
        vals = setHigh(e);
        newE.health = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Strength: Exponential - Medium*/
        vals = setMedium(e);
        newE.strength = setExponential(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Linear - Low*/
        vals = setLow(e);
        newE.magic = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Linear - Very Low*/
        vals = setVeryLow(e);
        newE.speed = setLinear(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Elemental:
        /*Health:   Linear -  Low*/
        vals = setLow(e);
        newE.health = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Strength: Exponential - Very Low*/
        vals = setVeryLow(e);
        newE.strength = setExponential(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Linear - Very High*/
        vals = setVeryHigh(e);
        newE.magic = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Logarithmic - High*/
        vals = setHigh(e);
        newE.speed = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Slime:
        /*Health:   Logarithmic - Very Low*/
        vals = setVeryLow(e);
        newE.health = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Strength: Logarithmic - Very Low*/
        vals = setVeryLow(e);
        newE.strength = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Logarithmic - Very Low*/
        vals = setVeryLow(e);
        newE.magic = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Exponential - Very High*/
        vals = setVeryHigh(e);
        newE.speed = setExponential(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Demon:
        /*Health:   Exponential - Medium*/
        vals = setMedium(e);
        newE.health = setExponential(e.level, vals.0, vals.1, vals.2);
        /*Strength: Logarithmic - Very Low*/
        vals = setVeryLow(e);
        newE.strength = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Exponential - Very High*/
        vals = setVeryHigh(e);
        newE.magic = setExponential(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Linear - High*/
        vals = setHigh(e);
        newE.speed = setLinear(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Dragon:
        /*Health:   Exponential - Low*/
        vals = setLow(e);
        newE.health = setExponential(e.level, vals.0, vals.1, vals.2);
        /*Strength: Linear - High*/
        vals = setHigh(e);
        newE.strength = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Magic:    Linear - High*/
        vals = setHigh(e);
        newE.magic = setLinear(e.level, vals.0, vals.1, vals.2);
        /*Speed:    Logarithmic - Medium*/
        vals = setMedium(e);
        newE.speed = setLogarithmic(e.level, vals.0, vals.1, vals.2);
        return newE;
    default:
        println("Selected type does not exist");
        return e;
    }
}

func setVeryLow(e:enemy) -> (Int,Int,Int)
{
    return (Int(e.level / 2), (e.level - 1), (e.level));
}
func setLow(e:enemy) -> (Int,Int,Int)
{
    return ((e.level), (2 * e.level - 2), (2 * e.level));
}
func setMedium(e:enemy) -> (Int,Int,Int)
{
    return ((2 * e.level), (3 * e.level - 3), (3 * e.level));
}
func setHigh(e:enemy) -> (Int,Int,Int)
{
    return ((3 * e.level), (4 * e.level - 4), (4 * e.level));
}
func setVeryHigh(e:enemy) -> (Int,Int,Int)
{
    return ((4 * e.level), (5 * e.level - 5), (5 * e.level));
}
func setLogarithmic(level:Int, offset:Int, min:Int, max:Int) -> Int
{
    var val:Int = 0;
    var random:Int = Int(arc4random_uniform((max + 1 - min) as UInt32) + min);
    val = Int((Double(10 * log(Double(level) + 1))/log(10)) + (0.0414 * Double(level))) + offset + random - level;
    if(val <= 0){val = 1;}
    return val;
}
func setLinear(level:Int, offset:Int, min:Int, max:Int) -> Int
{
    var val:Int = 0;
    var random:Int = Int(arc4random_uniform((max + 1 - min) as UInt32) + min);
    val = level + offset + random;
    if(val <= 0){val = 1;}
    return val;
}
func setExponential(level:Int, offset:Int, min:Int, max:Int) -> Int
{
    var val:Int = 0;
    var random:Int = Int(arc4random_uniform((max + 1 - min) as UInt32) + min);
    val = ((level * level)/4 + offset + random)
    if(val <= 0){val = 1;}
    return val;
}