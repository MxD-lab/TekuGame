//
//  SelectAttack.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/26/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

func selectAttack(e:enemy) -> Action
{
    switch(e.type)
    {
    case Types.Humanoid:
        return Action.P_Uppercut;
    case Types.Insect:
        return Action.P_Uppercut;
    case Types.Alien:
        return Action.E_EnergyBall;
    case Types.Beast:
        return Action.P_Uppercut;
    case Types.Construct:
        return Action.P_Uppercut;
    case Types.Undead:
        return Action.P_Uppercut;
    case Types.Elemental:
        return Action.E_EnergyBall;
    case Types.Slime:
        return Action.E_EnergyBall;
    case Types.Demon:
        return Action.E_EnergyBall;
    case Types.Dragon:
        return (e.strength > e.magic) ? Action.P_Uppercut : Action.E_EnergyBall;
    default:
        println("DID EMPTY ATTACK!");
        return Action.empty;
    }
}