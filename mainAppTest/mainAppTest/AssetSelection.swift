//
//  AssetSelection.swift
//  mainAppTest
//
//  Created by Maxwell Perlman on 9/8/14.
//  Copyright (c) 2014 ステファンアレクサンダー. All rights reserved.
//

import Foundation
import SpriteKit

func getSprite(e:enemy) -> SKTexture
{
    switch(e.type)
        {
    case Types.Humanoid:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Humanoid1-2.png");
        case 1:
            return SKTexture(imageNamed: "Humanoid2.png");
        case 2:
            return SKTexture(imageNamed: "Humanoid3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Insect:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Insect1.png");
        case 1:
            return SKTexture(imageNamed: "Insect2.png");
        case 2:
            return SKTexture(imageNamed: "Insect3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Alien:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Alien1.png");
        case 1:
            return SKTexture(imageNamed: "Alien2.png");
        case 2:
            return SKTexture(imageNamed: "Alien3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Beast:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Beast1.png");
        case 1:
            return SKTexture(imageNamed: "Beast2.png");
        case 2:
            return SKTexture(imageNamed: "Beast3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Construct:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Construct1.png");
        case 1:
            return SKTexture(imageNamed: "Construct2.png");
        case 2:
            return SKTexture(imageNamed: "Construct3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Undead:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Undead1.png");
        case 1:
            return SKTexture(imageNamed: "Undead2.png");
        case 2:
            return SKTexture(imageNamed: "Undead3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Elemental:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Elemental1.png");
        case 1:
            return SKTexture(imageNamed: "Elemental2.png");
        case 2:
            return SKTexture(imageNamed: "Elemental3.png");
        case 3:
            return SKTexture(imageNamed: "Elemental4.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Slime:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Slime1.png");
        case 1:
            return SKTexture(imageNamed: "Slime2.png");
        case 2:
            return SKTexture(imageNamed: "Slime3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Demon:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Demon1.png");
        case 1:
            return SKTexture(imageNamed: "Demon2.png");
        case 2:
            return SKTexture(imageNamed: "Demon3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    case Types.Dragon:
        switch(e.subType)
            {
        case 0:
            return SKTexture(imageNamed: "Dragon1.png");
        case 1:
            return SKTexture(imageNamed: "Dragon2.png");
        case 2:
            return SKTexture(imageNamed: "Dragon3.png");
        default:
            return SKTexture(imageNamed: "enemy.png");
        }
    default:
        return SKTexture(imageNamed: "enemy.png");
    }
}