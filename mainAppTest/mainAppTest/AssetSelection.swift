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
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Humanoid1-2", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Humanoid2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Humanoid3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Insect:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Insect1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Insect2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Insect3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Alien:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Alien1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Alien2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Alien3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Beast:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Beast1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Beast2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Beast3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Construct:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Construct1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Construct2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Construct3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Undead:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Undead1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Undead2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Undead3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Elemental:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Elemental1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Elemental2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Elemental3", ofType: "png")! as NSString));
        case 3:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Elemental4", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Slime:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Slime1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Slime2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Slime3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Demon:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Demon1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Demon2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Demon3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    case Types.Dragon:
        switch(e.subType)
            {
        case 0:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Dragon1", ofType: "png")! as NSString));
        case 1:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Dragon2", ofType: "png")! as NSString));
        case 2:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("Dragon3", ofType: "png")! as NSString));
        default:
            return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
        }
    default:
        return SKTexture(image: UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("enemy", ofType: "png")! as NSString));
    }
}