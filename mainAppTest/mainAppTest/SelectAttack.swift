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
        switch(e.subType)
            {
            /*Archer*/
        case 0:
            break;
            /*Samurai*/
        case 1:
            break;
            /*Ninja*/
        case 2:
            break;
        default:
            break;
        }
    case Types.Insect:
        switch(e.subType)
            {
            /*Wurm*/
        case 0:
            break;
            /*Spider*/
        case 1:
            break;
            /*Stag Beetle*/
        case 2:
            break;
        default:
            break;
        }
    case Types.Alien:
        switch(e.subType)
            {
            /*Oorn*/
        case 0:
            break;
            /*Mi-go*/
        case 1:
            break;
            /*Yugg*/
        case 2:
            break;
        default:
            break;
        }
    case Types.Beast:
        switch(e.subType)
            {
            /*Minotaur*/
        case 0:
            break;
            /*Cerberus*/
        case 1:
            break;
            /*Griffin*/
        case 2:
            break;
        default:
            break;
        }
    case Types.Construct:
        switch(e.subType)
            {
            /*Qlippoth Barrier*/
        case 0:
            break;
            /*Qlippoth Shell*/
        case 1:
            break;
            /*Qlippoth Husk*/
        case 2:
            break;
        default:
            break;
        }
    case Types.Undead:
        switch(e.subType)
            {
            /*Zombie*/
        case 0:
            break;
            /*Goat-Bat Hybrid*/
        case 1:
            break;
            /*Ancent Soldier*/
        case 2:
            break;
        default:
            break;
        }
    case Types.Elemental:
        
        switch(e.subType)
            {
            /*Fire Elemental*/
        case 0:
            break;
            /*Water Elemental*/
        case 1:
            break;
            /*Wind Elemental*/
        case 2:
            break;
            /*Earth Elemental*/
        case 3:
            break;
        default:
            break;
        }
    case Types.Slime:
        switch(e.subType)
            {
            /*Shoggoth*/
        case 0:
            break;
            /*Brain Slug*/
        case 1:
            break;
            /*Ooze*/
        case 2:
            break;
        default:
            break;
        }
    case Types.Demon:
        switch(e.subType)
            {
            /*Djinn*/
        case 0:
            break;
            /*Vampire*/
        case 1:
            break;
            /*Angel of Death*/
        case 2:
            break;
        default:
            break;
        }
    case Types.Dragon:
        switch(e.subType)
            {
            /*Wyrm*/
        case 0:
            break;
            /*Sea Serpent*/
        case 1:
            break;
            /*Dragon*/
        case 2:
            break;
        default:
            break;
        }
    default:
        println("DID EMPTY ATTACK!");
        return Action.empty;
    }
}