// Playground - noun: a place where people can play

import UIKit

enum Types:String, Printable
{
    case Humanoid = "Humanoid"
    case Insect = "Insect"
    case empty = "";
    static let allValues = [Types.Humanoid, Types.Insect];
    
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
    var type:Types;
    
    init()
    {
        self.level = 1;
        self.health = 1;
        self.strength = 1;
        self.magic = 1;
        self.speed = 1;
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
    val = Int(10 * log(level + 1)/log(10) - 0.0414 * level) + offset + random - level;
    return val;
}
func setLinear(level:Int, offset:Int, min:Int, max:Int) -> Int
{
    var val:Int = 0;
    var random:Int = Int(arc4random_uniform((max + 1 - min) as UInt32) + min);
    val = level + offset + random;
    return val;
}
func setExponential(level:Int, offset:Int, min:Int, max:Int) -> Int
{
    var val:Int = 0;
    var random:Int = Int(arc4random_uniform((max + 1 - min) as UInt32) + min);
    val = Int(0.25 * level^2) + offset + random;
    return val;
}

func setStats(e:enemy) -> (enemy)
{
    var newE:enemy = enemy();
    var vals:(Int,Int,Int) = (0,0,0);
    switch(e.type)
    {
    case Types.Humanoid:
        /*Health:   Linear - Medium*/
        /*Strength: Linear - Medium*/
        /*Magic:    Linear - Medium*/
        /*Speed:    Linear - Medium*/
        vals = setMedium(e);
        newE.health = setLinear(e.level, vals.0, vals.1, vals.2);
        newE.strength = setLinear(e.level, vals.0, vals.1, vals.2);
        newE.magic = setLinear(e.level, vals.0, vals.1, vals.2);
        newE.speed = setLinear(e.level, vals.0, vals.1, vals.2);
        return newE;
    case Types.Insect:
        /*Health:   Linear - VeryLow*/
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
    default:
        println("Selected type does not exist");
        return e;
    }
}

var p = player();
println(p);

var e = enemy();
println(e);

var newE:enemy = enemy();

for t in Types.allValues
{
    for(var i:Int = 1; i <= 10; i += 1)
    {
        e.type = t;
        e.level = i;
        newE = setStats(e);
        newE.level = i;
        newE.type = t;
    }
}