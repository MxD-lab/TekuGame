//
//  PlayerValues.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

func setStats(p:player, h:Double, st:Double, m:Double, sp:Double) -> player
{
    var newP = player();
    newP.points = p.level * 20;
    newP.health = p.level;
    newP.strength = p.level;
    newP.magic = p.level;
    newP.speed = p.level;
    switch((h + st + m + sp))
        {
    case 1:
        newP.health = Int(Double(newP.health) + Double(newP.points) * h);
        newP.strength = Int(Double(newP.strength) + Double(newP.points) * st);
        newP.magic = Int(Double(newP.magic) + Double(newP.points) * m);
        newP.speed = Int(Double(newP.speed) + Double(newP.points) * sp);
        newP.points = 0;
        return newP;
    default:
        newP.health += newP.points/4;
        newP.strength += newP.points/4;
        newP.magic += newP.points/4;
        newP.speed += newP.points/4;
        newP.points = 0;
        return newP;
    }
}