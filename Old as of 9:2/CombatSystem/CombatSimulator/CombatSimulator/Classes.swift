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
    case empty = "empty"
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
    /*Enemy Attacks*/
    case Punch = "Punch";
    case RapidFire = "RapidFire";
    case Cleave = "Cleave"
    case RecklessStrike = "RecklessStrike";
    case Bite = "Bite";
    case EatDirt = "Eat Dirt";
    case EightProngStab = "EightProngStab";
    case HornSmash = "HornSmash";
    case SprayAcid = "SprayAcid";
    case AetherialFangs = "Aetherial Fangs"
    case Horrify = "Horrify";
    case Meditate = "Meditate";
    case MindInvasion = "MindInvasion";
    case AetherialDarts = "Aetherial Darts";
    case Burrow = "Burrow";
    case FocusEnergy = "FocusEnergy";
    case Rushdown = "Rushdown";
    case TriBite = "TriBite";
    case UnforseenAttack = "UnforseenAttack";
    case DefendCore = "DefendCore";
    case Enrage = "Enrage";
    case Crush = "Crush";
    case HeadBash = "HeadBash";
    case LimbSwing = "LimbSwing";
    case GlancingWing = "GlancingWing"
    case Club = "Club";
    case ScaldingConflagration = "ScaldingConflagration";
    case SuffocatingCurrent = "SuffocatingCurrent";
    case SlicingGale = "SlicingGale";
    case CrushingGaea = "CrushingGaea";
    case Drain = "Drain";
    case Confuse = "Confuse";
    case Envelop = "Envelop";
    case Blight = "Blight";
    case Smite = "Smite";
    case Engulf = "Engulf";
    case TwilightStrike = "TwilightStrike";
    case EradicatingLight = "EradicatingLight";
    case TailSwing = "TailSwing";
    case Constrict = "Constrict";
    case BreathOfIce = "BreathOfIce";
    case CrushUnderFoot = "CrushUnderFoot";
    case BreathOfFire = "BreathOfFire";
    
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
    static let allUtility = [Action.U_Examine];
    static let allPhysical = [
        Action.P_Uppercut,
        Action.P_Charged_Strike,
        Action.P_Meditation,
        Action.P_Leg_Sweep,
        Action.P_Turbo_Strike,
        Action.P_Heart_Strike,
        Action.P_Muscle_Training,
        Action.P_Stomp,
        Action.P_Sacrificial_Strike,
        Action.P_Overpower
    ];
    static let allMagic = [
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
    
    static let actionsUtilityE:[String] = ["Examine"];
    static let actionPhysicalE:[String] = ["Uppercut", "Charged Strike", "Meditation", "Leg Sweep", "Turbo Strike", "Heart Strike", "Muscle Training", "Stomp", "Sacrificial Strike", "Ovepower"];
    static let actionsMagicE:[String] = ["Energy Ball", "Icy Wind", "Barrier", "Fireball", "Sharpen Mind", "Curse", "Life Drain", "Decay", "Full Heal", "Instant Death"];
    
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
            /**/
        case Action.Punch:
            return "Punch";
        case Action.RapidFire:
            return "Rapid Fire";
        case Action.Cleave:
            return "Cleave";
        case Action.RecklessStrike:
            return "Reckless Strike";
        case Action.Bite:
            return "Bite";
        case Action.EatDirt:
            return "Eat Dirt";
        case Action.EightProngStab:
            return "Eight Pronged Stab";
        case Action.HornSmash:
            return "Horn Smash";
        case Action.SprayAcid:
            return "Spray Acid";
        case Action.AetherialFangs:
            return "Ætherial Fangs";
        case Action.Horrify:
            return "Horrify";
        case Action.Meditate:
            return "Meditate";
        case Action.MindInvasion:
            return "Mind Invasion";
        case Action.AetherialDarts:
            return "Ætherial Darts";
        case Action.Burrow:
            return "Burrow";
        case Action.FocusEnergy:
            return "Focus Energy";
        case Action.Rushdown:
            return "Rushdown";
        case Action.TriBite:
            return "Tri Bite";
        case Action.UnforseenAttack:
            return "Unforseen Attack";
        case Action.DefendCore:
            return "Defend Core";
        case Action.Enrage:
            return "Enrage";
        case Action.Crush:
            return "Crush";
        case Action.HeadBash:
            return "Head Bash";
        case Action.LimbSwing:
            return "Limb Swing";
        case Action.GlancingWing:
            return "Glancing Wing";
        case Action.Club:
            return "Club";
        case Action.ScaldingConflagration:
            return "Scalding Conflagration";
        case Action.SuffocatingCurrent:
            return "Suffocating Current";
        case Action.SlicingGale:
            return "Slicing Gale";
        case Action.CrushingGaea:
            return "Crushing Gaea";
        case Action.Drain:
            return "Drain";
        case Action.Confuse:
            return "Confuse";
        case Action.Envelop:
            return "Envelop";
        case Action.Blight:
            return "Blight";
        case Action.Smite:
            return "Smite";
        case Action.Engulf:
            return "Engulf";
        case Action.TwilightStrike:
            return "Twilight Strike";
        case Action.EradicatingLight:
            return "Eradicating Light";
        case Action.TailSwing:
            return "Tail Swing";
        case Action.Constrict:
            return "Constrict";
        case Action.BreathOfIce:
            return "Breath of Ice";
        case Action.CrushUnderFoot:
            return "Crush Under Foot";
        case Action.BreathOfFire:
            return "Breath of Fire";
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
            return "命がけの一撃";
        case Action.P_Overpower:
            return "制圧する";
        case Action.E_EnergyBall:
            return "エネルギーボール";
        case Action.E_Icy_Wind:
            return "氷風";
        case Action.E_Barrier:
            return "バリアー";
        case Action.E_Fireball:
            return "ファイヤーボール";
        case Action.E_Sharpen_Mind:
            return "心を研ぎ澄ます";
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
            /*えねみーあたっくす*/
        case Action.Punch:
            return "パンチ";
        case Action.RapidFire:
            return "火矢速射";
        case Action.Cleave:
            return "きりさく";
        case Action.RecklessStrike:
            return "捨て身攻撃";
        case Action.Bite:
            return "噛み付く";
        case Action.EatDirt:
            return "土を食べる";
        case Action.EightProngStab:
            return "八方向蜘蛛殺法";
        case Action.HornSmash:
            return "つのでつく";
        case Action.SprayAcid:
            return "酸を吐く";
        case Action.AetherialFangs:
            return "エーテルファング";
        case Action.Horrify:
            return "おどろかす";
        case Action.Meditate:
            return "めいそう";
        case Action.MindInvasion:
            return "精神操作";
        case Action.AetherialDarts:
            return "エーテルダーツ";
        case Action.Burrow:
            return "あなをほる";
        case Action.FocusEnergy:
            return "パワー集中";
        case Action.Rushdown:
            return "突進";
        case Action.TriBite:
            return "三連噛み付き";
        case Action.UnforseenAttack:
            return "不意打ち";
        case Action.DefendCore:
            return "身を守る";
        case Action.Enrage:
            return "怒り";
        case Action.Crush:
            return "クラッシュ";
        case Action.HeadBash:
            return "頭突き";
        case Action.LimbSwing:
            return "腕ちぎりスイング";
        case Action.GlancingWing:
            return "翼スラッシュ";
        case Action.Club:
            return "殴りつける";
        case Action.ScaldingConflagration:
            return "激しい炎";
        case Action.SuffocatingCurrent:
            return "水攻め";
        case Action.SlicingGale:
            return "カマイタチ";
        case Action.CrushingGaea:
            return "大地の拳";
        case Action.Drain:
            return "エナジードレイン";
        case Action.Confuse:
            return "混乱攻撃";
        case Action.Envelop:
            return "スライムハグ";
        case Action.Blight:
            return "腐食攻撃";
        case Action.Smite:
            return "鉄槌";
        case Action.Engulf:
            return "闇に飲み込む";
        case Action.TwilightStrike:
            return "神々の黄昏";
        case Action.EradicatingLight:
            return "断罪の滅殺光";
        case Action.TailSwing:
            return "ドラゴンテールスイング";
        case Action.Constrict:
            return "ドラゴンテールしめつけ";
        case Action.BreathOfIce:
            return "凍てつく吐息";
        case Action.CrushUnderFoot:
            return "踏みつぶす";
        case Action.BreathOfFire:
            return "焼け付く吐息";
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
    
    func printAll() -> Void
    {
        println("\(self)");
        println("   Level:     \(self.level)");
        println("   Health:    \(self.health)");
        println("   Strength:  \(self.strength)");
        println("   Magic:     \(self.magic)");
        println("   Speed:     \(self.speed)");
        println("   Current Health:    \(self.currentHealth)");
        println("   Current Strength:  \(self.currentStrength)");
        println("   Current Magic:     \(self.currentMagic)");
        println("   Current Speed:     \(self.currentSpeed)");
    }
}

class player:Entity
{
    var points:Int;
    override init()
    {
        self.points = 0;
        super.init();
    }
}


class enemy:Entity
{
    var type:Types;
    var subType:Int;
    override init()
    {
        self.type = Types.empty;
        self.subType = 0;
        super.init();
    }
    init(t:Types)
    {
        self.type = t;
        self.subType = 0;
        super.init();
    }
    init(s:Int)
    {
        self.type = Types.empty;
        self.subType = s;
        super.init();
    }
    init(t:Types, s:Int)
    {
        self.type = t;
        self.subType = s;
        super.init();
    }
}