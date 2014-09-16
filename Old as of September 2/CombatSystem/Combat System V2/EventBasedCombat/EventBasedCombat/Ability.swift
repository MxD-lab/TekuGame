//
//  Ability.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/22/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

enum Move: String, Printable
{
    case empty = "empty";
    case P_Punch = "P_Punch";
    case P_SweepLeg = "P_SweepLeg";
    case M_EnergyBall = "M_EnergyBall";
    
    var description : String
    {
    get
    {
        switch(self)
            {
        case empty:
            return "empty";
        case P_Punch:
            return "P_Punch";
        case P_Punch:
            return "P_SweepLeg";
        case M_EnergyBall:
            return "M_EnergyBall";
        default:
            return "";
        }
    }
    }
}
