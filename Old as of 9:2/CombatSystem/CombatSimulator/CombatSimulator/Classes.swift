//
//  Classes.swift
//  CombatSimulator
//
//  Created by Maxwell Perlman on 8/19/14.
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

enum Action:String, Printable
{
    /*Utility Actions*/
    case U_Examine = "U_Examine";
    /*Physical Actions*/
    case P_Uppercut = "P_Uppercut";
    case P_Charged_Strike = "P_Charged_Strike";
    case P_Meditation = "P_Meditation";
    case P_Leg_Sweep = "P_Leg_Sweep";
    case P_Turbo_Strike = "P_Turbo_Strike";
    case P_Heart_Strike = "P_Heart_Strike";
    case P_Muscle_Training = "P_Muscle_Training";
    case P_Stomp = "P_Stomp";
    case P_Sacrificial_Strike = "P_Sacrificial_Strike";
    case P_Overpower = "P_Overpower";
    /*Magic Actions*/
    case E_EnergyBall = "E_Energy_Ball";
    case E_Icy_Wind = "E_Icy_Wind";
    case E_Barrier = "E_Barrier";
    case E_Fireball = "E_Fireball";
    case E_Sharpen_Mind = "E_Sharpen_Mind";
    case E_Curse = "E_Curse";
    case E_Life_Drain = "E_Life_Drain";
    case E_Decay = "E_Decay";
    case E_Full_Heal = "E_Full_Heal";
    case E_Instant_Death = "E_Instant_Death";
    static let allValues = [
        Action.U_Examine,
        Action.P_Uppercut,
        Action.P_Charged_Strike,
        Action.P_Meditation,
        Action.P_Leg_Sweep,
        Action.P_Turbo_Strike,
        Action.P_Heart_Strike,
        Action.P_Muscle_Training,
        Action.P_Stomp,
        Action.P_Sacrificial_Strike,
        Action.P_Overpower,
        Action.E_EnergyBall,
        Action.E_Icy_Wind,
        Action.E_Barrier,
        Action.E_Fireball,
        Action.E_Sharpen_Mind,
        Action.E_Curse,
        Action.E_Life_Drain,
        Action.E_Decay,
        Action.E_Full_Heal,
        Action.E_Instant_Death
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
        case Action.U_Examine:
            return "Examine";
        case Action.P_Uppercut:
            return "Uppercut";
        case Action.P_Charged_Strike:
            return "Charged Strike";
        case Action.P_Meditation:
            return "Meditation";
        case Action.P_Leg_Sweep:
            return "Leg Sweep";
        case Action.P_Turbo_Strike:
            return "Turbo Strike";
        case Action.P_Heart_Strike:
            return "Heart Strike";
        case Action.P_Muscle_Training:
            return "Muscle Training";
        case Action.P_Stomp:
            return "Stomp";
        case Action.P_Sacrificial_Strike:
            return "Sacrificial Strike";
        case Action.P_Overpower:
            return "Ovepower";
        case Action.E_EnergyBall:
            return "Energy Ball";
        case Action.E_Icy_Wind:
            return "Icy Wind";
        case Action.E_Barrier:
            return "Barrier";
        case Action.E_Fireball:
            return "Fireball";
        case Action.E_Sharpen_Mind:
            return "Sharpen Mind";
        case Action.E_Curse:
            return "Curse";
        case Action.E_Life_Drain:
            return "Life Drain";
        case Action.E_Decay:
            return "Decay";
        case Action.E_Full_Heal:
            return "Full Heal";
        case Action.E_Instant_Death:
            return "Instant Death";
        default:
            return "";
        }
    }
    
    func typeToStringJ() -> String
    {
        switch(self)
        {
        case Action.U_Examine:
            return "調べる";
        case Action.P_Uppercut:
            return "アッパー";
        case Action.P_Charged_Strike:
            return "チャージ攻撃";
        case Action.P_Meditation:
            return "瞑想";
        case Action.P_Leg_Sweep:
            return "レッグスイープ";
        case Action.P_Turbo_Strike:
            return "ターボストライク";
        case Action.P_Heart_Strike:
            return "ハートストライク";
        case Action.P_Muscle_Training:
            return "肉体トレーニング";
        case Action.P_Stomp:
            return "踏む";
        case Action.P_Sacrificial_Strike:
            return "犠牲攻撃";
        case Action.P_Overpower:
            return "制圧";
        case Action.E_EnergyBall:
            return "エネルギーボール";
        case Action.E_Icy_Wind:
            return "氷風";
        case Action.E_Barrier:
            return "バリアー";
        case Action.E_Fireball:
            return "ファイヤーボール";
        case Action.E_Sharpen_Mind:
            return "研ぎ澄ます";
        case Action.E_Curse:
            return "呪う";
        case Action.E_Life_Drain:
            return "ライフドレイン";
        case Action.E_Decay:
            return "腐敗";
        case Action.E_Full_Heal:
            return "フルヒール";
        case Action.E_Instant_Death:
            return "デス";
        default:
            return "";
        }
    }
}

class Entity
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

class enemy:Entity
{
    var type:Types;
    init()
    {
        self.type = Types.empty;
        super.init();
    }
}

class player:Entity
{
    var points:Int;
    init()
    {
        self.points = 0;
        super.init();
    }
}