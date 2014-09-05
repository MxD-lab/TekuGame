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
    var rand:Int = 0;
    switch(e.type)
    {
    case Types.Humanoid:
        rand = Int(arc4random_uniform(2) + 1);
        switch(e.subType)
            {
        /*Archer*/
        case 0:
            return (rand%2 == 0) ?  Action.Punch :  Action.RapidFire;
        /*Samurai*/
        case 1:
            return (rand%2 == 0) ?  Action.Punch :  Action.Cleave;
        /*Ninja*/
        case 2:
            return (rand%2 == 0) ?  Action.Punch :  Action.RecklessStrike;
        default:
            return Action.empty;
        }
    case Types.Insect:
        rand = Int(arc4random_uniform(2) + 1);
        switch(e.subType)
            {
        /*Wurm*/
        case 0:
            return (rand%2 == 0) ?  Action.Bite :  Action.EatDirt;
        /*Spider*/
        case 1:
            return (rand%2 == 0) ?  Action.Bite :  Action.EightProngStab;
        /*Stag Beetle*/
        case 2:
            return (rand%2 == 0) ?  Action.Bite :  Action.HornSmash;
        default:
            return Action.empty;
        }
    case Types.Alien:
        rand = Int(arc4random_uniform(3) + 1);
        switch(e.subType)
            {
        /*Oorn*/
        case 0:
            if(rand%3 == 0)
            {
                return Action.SprayAcid;
            }
            else if(rand%3 == 1)
            {
                return Action.AetherialFangs;
            }
            else
            {
                return Action.Horrify;
            }
        /*Mi-go*/
        case 1:
            if(rand%3 == 0)
            {
                return Action.Meditate;
            }
            else if(rand%3 == 1)
            {
                return Action.MindInvasion;
            }
            else
            {
                return Action.Horrify;
            }
        /*Yugg*/
        case 2:
            if(rand%3 == 0)
            {
                return Action.AetherialDarts;
            }
            else if(rand%3 == 1)
            {
                return Action.Burrow;
            }
            else
            {
                return Action.Horrify;
            }
        default:
            return Action.empty;
        }
    case Types.Beast:
        rand = Int(arc4random_uniform(2) + 1);
        switch(e.subType)
            {
        /*Minotaur*/
        case 0:
            return (rand%2 == 0) ?  Action.FocusEnergy :  Action.Rushdown;
        /*Cerberus*/
        case 1:
            return (rand%2 == 0) ?  Action.FocusEnergy :  Action.TriBite;
        /*Griffin*/
        case 2:
            return (rand%2 == 0) ?  Action.FocusEnergy :  Action.UnforseenAttack;
        default:
            return Action.empty;
        }
    case Types.Construct:
        rand = Int(arc4random_uniform(10) + 1);
        switch(e.subType)
            {
        /*Qlippoth Barrier*/
        case 0:
            if(rand%10 == 0)
            {
                return Action.Horrify
            }
            else if(rand % 10 == 1)
            {
                return Action.Enrage;
            }
            else if(rand % 10 == 2)
            {
                return Action.Crush
            }
            else
            {
                return Action.DefendCore;
            }
        /*Qlippoth Shell*/
        case 1:
            if(rand%10 == 0)
            {
                return Action.DefendCore
            }
            else if(rand % 10 == 1)
            {
                return Action.Enrage;
            }
            else if(rand % 10 == 2)
            {
                return Action.Crush
            }
            else
            {
                return Action.Horrify;
            }
        /*Qlippoth Husk*/
        case 2:
            if(rand%10 == 0)
            {
                return Action.Horrify
            }
            else if(rand % 10 == 1)
            {
                return Action.DefendCore;
            }
            else if(rand % 10 == 2)
            {
                return Action.Crush
            }
            else
            {
                return Action.Enrage;
            }
        default:
            return Action.empty;
        }
    case Types.Undead:
        rand = Int(arc4random_uniform(2) + 1);
        switch(e.subType)
            {
        /*Zombie*/
        case 0:
            return (rand%2 == 0) ?  Action.HeadBash :  Action.LimbSwing;
        /*Goat-Bat Hybrid*/
        case 1:
            return (rand%2 == 0) ?  Action.HeadBash :  Action.GlancingWing;
        /*Ancent Soldier*/
        case 2:
            return (rand%2 == 0) ?  Action.HeadBash :  Action.Club;
        default:
            return Action.empty;
        }
    case Types.Elemental:
        switch(e.subType)
            {
        /*Fire Elemental*/
        case 0:
            return Action.ScaldingConflagration;
        /*Water Elemental*/
        case 1:
            return Action.SuffocatingCurrent;
        /*Wind Elemental*/
        case 2:
            return Action.SlicingGale;
        /*Earth Elemental*/
        case 3:
            return Action.CrushingGaea
        default:
            return Action.empty;
        }
    case Types.Slime:
        rand = Int(arc4random_uniform(2) + 1);
        switch(e.subType)
            {
        /*Shoggoth*/
        case 0:
            return (rand%2 == 0) ?  Action.Drain :  Action.Horrify;
        /*Brain Slug*/
        case 1:
            return (rand%2 == 0) ?  Action.Drain :  Action.Confuse;
        /*Ooze*/
        case 2:
            return (rand%2 == 0) ?  Action.Drain :  Action.Envelop;
        default:
            return Action.empty;
        }
    case Types.Demon:
        rand = Int(arc4random_uniform(2) + 1);
        switch(e.subType)
            {
        /*Djinn*/
        case 0:
            return (rand%2 == 0) ?  Action.Blight :  Action.Smite;
        /*Vampire*/
        case 1:
            return (rand%2 == 0) ?  Action.Drain :  Action.Engulf;
        /*Angel of Death*/
        case 2:
            return (rand%2 == 0) ?  Action.Blight :  Action.TwilightStrike;
        default:
            return Action.empty;
        }
    case Types.Dragon:
        rand = Int(arc4random_uniform(2) + 1);
        switch(e.subType)
            {
        /*Wyrm*/
        case 0:
            return (rand%2 == 0) ?  Action.EradicatingLight :  Action.TailSwing;
        /*Sea Serpent*/
        case 1:
            return (rand%2 == 0) ?  Action.Constrict :  Action.BreathOfIce;
        /*Dragon*/
        case 2:
            return (rand%2 == 0) ?  Action.CrushUnderFoot :  Action.BreathOfFire;
        default:
            return Action.empty;
        }
    default:
        println("DID EMPTY ATTACK!");
        return Action.empty;
    }
}