//
//  Enemy Types.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation
enum Types:String, Printable
{
    case Humanoid = "Humanoid";
    case Insect = "Insect";
    case Alien = "Alien";
    case Beast = "Beast";
    case Construct = "Construct";
    case Undead = "Undead";
    case Elemental = "Elemental";
    case Slime = "Slime";
    case Demon = "Demon";
    case Dragon = "Dragon";
    case empty = "";
    static let allValues = [
        Types.Humanoid,
        Types.Insect,
        Types.Alien,
        Types.Beast,
        Types.Construct,
        Types.Undead,
        Types.Elemental,
        Types.Slime,
        Types.Demon,
        Types.Dragon
    ];
    
    var description:String
    {
        get
        {
            return self.toRaw();
        }
    }
    
    func typeToStringE() -> String
    {
        switch(self)
            {
        case Types.Humanoid:
            return "Humanoid";
        case Types.Insect:
            return "Insect";
        case Types.Alien:
            return "Alien";
        case Types.Beast:
            return "Beast";
        case Types.Construct:
            return "Construct";
        case Types.Undead:
            return "Undead";
        case Types.Elemental:
            return "Elemental";
        case Types.Slime:
            return "Slime";
        case Types.Demon:
            return "Demon";
        case Types.Dragon:
            return "Dragon";
        default:
            return "";
        }
    }
    
    func typeToStringJ() -> String
    {
        switch(self)
        {
        case Types.Humanoid:
            return "ヒューマノイド";
        case Types.Insect:
            return "昆虫";
        case Types.Alien:
            return "エイリアン";
        case Types.Beast:
            return "ビースト";
        case Types.Construct:
            return "無機物";
        case Types.Undead:
            return "アンデッド";
        case Types.Elemental:
            return "エレメンタル";
        case Types.Slime:
            return "スライム";
        case Types.Demon:
            return "デーモン";
        case Types.Dragon:
            return "ドラゴン";
        default:
            return "";
        }
    }
}