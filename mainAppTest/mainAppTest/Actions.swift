//
//  Actions.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/25/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import Foundation

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
    case EradicatingLight = "";
    case TailSwing = "TailSwing";
    case Constrict = "Constrict";
    case BreathOfIce = "BreathOfIce";
    case CrushUnderFood = "CrushUnderFood";
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
        case Action.CrushUnderFood:
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
        /**/
        case Action.Punch:
            return "";
        case Action.RapidFire:
            return "";
        case Action.Cleave:
            return "";
        case Action.RecklessStrike:
            return "";
        case Action.EatDirt:
            return "";
        case Action.EightProngStab:
            return "";
        case Action.HornSmash:
            return "";
        case Action.SprayAcid:
            return "";
        case Action.AetherialFangs:
            return "";
        case Action.Horrify:
            return "";
        case Action.Meditate:
            return "";
        case Action.MindInvasion:
            return "";
        case Action.AetherialDarts:
            return "";
        case Action.Burrow:
            return "";
        case Action.FocusEnergy:
            return "";
        case Action.Rushdown:
            return "";
        case Action.TriBite:
            return "";
        case Action.UnforseenAttack:
            return "";
        case Action.DefendCore:
            return "";
        case Action.Enrage:
            return "";
        case Action.Crush:
            return "";
        case Action.HeadBash:
            return "";
        case Action.LimbSwing:
            return "";
        case Action.GlancingWing:
            return "";
        case Action.Club:
            return "";
        case Action.ScaldingConflagration:
            return "";
        case Action.SuffocatingCurrent:
            return "";
        case Action.SlicingGale:
            return "";
        case Action.CrushingGaea:
            return "";
        case Action.Drain:
            return "";
        case Action.Confuse:
            return "";
        case Action.Envelop:
            return "";
        case Action.Blight:
            return "";
        case Action.Smite:
            return "";
        case Action.Engulf:
            return "";
        case Action.TwilightStrike:
            return "";
        case Action.EradicatingLight:
            return "";
        case Action.TailSwing:
            return "";
        case Action.Constrict:
            return "";
        case Action.BreathOfIce:
            return "";
        case Action.CrushUnderFood:
            return "";
        case Action.BreathOfFire:
            return "";
        default:
            return "";
        }
    }
}