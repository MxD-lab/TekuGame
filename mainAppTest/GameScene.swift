//
//  GameScene.swift
//  UIExample
//
//  Created by Maxwell Perlman on 8/8/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import UIKit
import SpriteKit

/*Picker Data*/
var num:[String] = ["Utility","Physical","Magic"];
var utility:[Action] = Action.allUtility
var physical:[Action] = Action.allPhysical;
var magic:[Action] = Action.allMagic;

var typeMenu:HMSideMenu = HMSideMenu();
var physicalMenu:HMSideMenu = HMSideMenu();
var magicMenu:HMSideMenu = HMSideMenu();

var magicArr:NSMutableArray = [];
var physicalArr:NSMutableArray = [];

var p:player = player();
var e:enemy = enemy();

var turnPlayer:Bool = false;
var somethingDead:Bool = false;

var doUpdate:Int = 0;

class GameScene: SKScene
{
    var allActions:[(String, [Action])] = [("Utility", utility), ("Physical",physical),("Magic", magic)];
    
    let canDo:[Int] = [5,17,30,43,56,68,81,94,107,120];
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    let background:SKSpriteNode = SKSpriteNode(imageNamed: "background.png");
    let status:UILabel = UILabel(frame: CGRectMake( 0, 0, 320, 50));
    let typePicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let actionPicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let enemyImage:SKSpriteNode = SKSpriteNode(imageNamed: "enemy.png");
    let playerStatus:UILabel = UILabel(frame: CGRectMake(0,0,320, 50));

    var step:Int = 0;
    
    override func didMoveToView(view: SKView)
    {
        var userInfo = NSDictionary(object: false, forKey: "isGameOver")
        NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: self, userInfo: userInfo)
        
        var plStats:[String:[String:Int]] = prefs.objectForKey("playerStats") as [String:[String:Int]]
        var currentuser = prefs.objectForKey("currentuser") as String
        p.level = plStats[currentuser]!["level"]!
        p.health = plStats[currentuser]!["health"]!
        p.strength = plStats[currentuser]!["strength"]!
        p.magic = plStats[currentuser]!["magic"]!
        p.speed = plStats[currentuser]!["speed"]!
        
        p.currentHealth = p.health;
        p.currentStrength = p.strength;
        p.currentMagic = p.magic;
        p.currentSpeed = p.speed;

        e.level = p.level;
        
        e.type = Types.allValues[Int(arc4random_uniform(9))];
        e.subType = (e.type == Types.Elemental) ? Int(arc4random_uniform(3)):Int(arc4random_uniform(2));
        e = setStats(e);
        e.currentHealth = e.health;
        e.currentStrength = e.strength;
        e.currentMagic = e.magic;
        e.currentSpeed = e.speed;
        
        enemyImage.texture = getSprite(e);
        
        turnPlayer = (p.speed > e.speed) ? true : false ;
        
        /* Setup your scene here */
        status.center = CGPointMake(160, 25);
        status.textAlignment = NSTextAlignment.Center;
        status.textColor = UIColor.blackColor();
        status.backgroundColor = UIColor.lightGrayColor();
        status.opaque = false;
        status.alpha = 0.75;
        status.font = UIFont(name: "Optima-ExtraBlack", size: 15);
        status.numberOfLines = 0;
        status.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        view.addSubview(status)
        
        playerStatus.center = CGPointMake(160,518);
        playerStatus.textAlignment = NSTextAlignment.Center;
        playerStatus.backgroundColor = UIColor.lightGrayColor();
        playerStatus.opaque = false;
        playerStatus.alpha = 0.75;
        playerStatus.font = UIFont(name: "Optima-ExtraBlack", size: 15);
        playerStatus.numberOfLines = 2;
        view.addSubview(playerStatus);
        
        var p_uppercut = setMenuButton32("P_Uppercut.png") { () -> Void in self.actionAndStatus(Action.P_Uppercut);}
        var p_charged_strike = setMenuButton32("P_Charged_Strike.png") { () -> Void in self.actionAndStatus(Action.P_Charged_Strike);}
        var p_meditation = setMenuButton32("P_Meditation.png") { () -> Void in self.actionAndStatus(Action.P_Meditation);}
        var p_leg_sweep = setMenuButton32("P_Leg_Sweep.png") { () -> Void in self.actionAndStatus(Action.P_Leg_Sweep);}
        var p_turbo_strike = setMenuButton32("P_Turbo_Strike.png") { () -> Void in self.actionAndStatus(Action.P_Turbo_Strike);}
        var p_heart_strike = setMenuButton32("P_Heart_Strike.png") { () -> Void in self.actionAndStatus(Action.P_Heart_Strike);}
        var p_muscle_training = setMenuButton32("P_Muscle_Training.png") { () -> Void in self.actionAndStatus(Action.P_Muscle_Training);}
        var p_stomp = setMenuButton32("P_Stomp.png") { () -> Void in self.actionAndStatus(Action.P_Stomp);}
        var p_sacrificial_strike = setMenuButton32("P_Sacrificial_Strike.png") { () -> Void in self.actionAndStatus(Action.P_Sacrificial_Strike);}
        var p_overpower = setMenuButton32("P_Overpower.png") { () -> Void in self.actionAndStatus(Action.P_Overpower);}
        
        physicalArr = [
            p_uppercut,
            p_charged_strike,
            p_meditation,
            p_leg_sweep,
            p_turbo_strike,
            p_heart_strike,
            p_muscle_training,
            p_stomp,
            p_sacrificial_strike,
            p_overpower
        ];
        
        var e_energy_ball = setMenuButton32("E_Energy_Ball.png") { () -> Void in self.actionAndStatus(Action.E_EnergyBall);}
        var e_icy_wind = setMenuButton32("E_Icy_Wind.png") { () -> Void in self.actionAndStatus(Action.E_Icy_Wind);}
        var e_barrier = setMenuButton32("E_Barrier.png") { () -> Void in self.actionAndStatus(Action.E_Barrier);}
        var e_fireball = setMenuButton32("E_Fireball.png") { () -> Void in self.actionAndStatus(Action.E_Fireball);}
        var e_sharpen_mind = setMenuButton32("E_Sharpen_Mind.png") { () -> Void in self.actionAndStatus(Action.E_Sharpen_Mind);}
        var e_curse = setMenuButton32("E_Curse.png") { () -> Void in self.actionAndStatus(Action.E_Curse);}
        var e_life_drain = setMenuButton32("E_Life_Drain.png") { () -> Void in self.actionAndStatus(Action.E_Life_Drain);}
        var e_decay = setMenuButton32("E_Decay.png") { () -> Void in self.actionAndStatus(Action.E_Decay);}
        var e_full_heal = setMenuButton32("E_Full_Heal.png") { () -> Void in self.actionAndStatus(Action.E_Full_Heal);}
        var e_instant_death = setMenuButton32("E_Instant_Death.png") { () -> Void in self.actionAndStatus(Action.E_Instant_Death);}
        
        magicArr = [
            e_energy_ball,
            e_icy_wind,
            e_barrier,
            e_fireball,
            e_sharpen_mind,
            e_curse,
            e_life_drain,
            e_decay,
            e_full_heal,
            e_instant_death
        ];
        
        for(var i = 9; i >= 0; i -= 1)
        {
            if(p.magic < canDo[i])
            {
                magicArr.removeLastObject();
            }
            if(p.strength < canDo[i])
            {
                physicalArr.removeLastObject();
            }
        }
        physicalMenu = HMSideMenu(items: physicalArr);
        magicMenu = HMSideMenu(items: magicArr);
        
        physicalMenu.menuPosition = HMSideMenuPositionRight;
        view.addSubview(physicalMenu);
        magicMenu.menuPosition = HMSideMenuPositionRight;
        view.addSubview(magicMenu);
        
        var physicalButton = setMenuButton64("Physical.png") { () -> Void in
            if(!physicalMenu.isOpen && !magicMenu.isOpen)
            {
                physicalMenu.open();
            }
            else if(!physicalMenu.isOpen && magicMenu.isOpen)
            {
                magicMenu.close();
                physicalMenu.open();
            }
        }
        var magicButton = setMenuButton64("Magic.png") { () -> Void in
            if(!physicalMenu.isOpen && !magicMenu.isOpen)
            {
                magicMenu.open();
            }
            else if(physicalMenu.isOpen && !magicMenu.isOpen)
            {
                physicalMenu.close();
                magicMenu.open();
            }
        }
        
        var examineButton = setMenuButton64("U_Examine.png") { () -> Void in self.actionAndStatus(Action.U_Examine);}
        
        typeMenu = HMSideMenu(items: [
            physicalButton,
            magicButton,
            examineButton
            ]);
        
        typeMenu.menuPosition = HMSideMenuPositionLeft;
        view.addSubview(typeMenu);
        typeMenu.open();
        
        background.anchorPoint = CGPoint(x: 0, y: 0);
        background.size = self.size;
        background.zPosition = -2;
        addChild(background);
        
        enemyImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 80);
        enemyImage.zPosition = 1;
        addChild(enemyImage);
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {   /* Called when a touch begins */
        for touch: AnyObject in touches
        {
        }
    }
    
    override func update(currentTime: CFTimeInterval)
    {   /* Called before each frame is rendered */
        
        playerStatus.text = "Health: \(p.currentHealth)/\(p.health)     Speed:\(p.currentSpeed)/\(p.speed)\nStrength: \(p.currentStrength)/\(p.strength)     Magic:\(p.currentMagic)/\(p.magic)";
        
        if(doUpdate > 0)
        {
            doUpdate -= 1;
        }
        else
        {
            if (step < 150)
            {
                step += 1;
                status.text = "You encountered a \(e.type.typeToStringE())";
            }
            else
            {
                somethingDead = false;
                var playerWin:Bool = false;
                
                if(p.currentHealth <= 0 && e.currentHealth <= 0)
                {
                    status.text = "Both Died";
                    somethingDead = true;
                }
                else if(p.currentHealth <= 0 && e.currentHealth > 0)
                {
                    status.text = "Player Died";
                    somethingDead = true;
                }
                else if(e.currentHealth <= 0 && p.currentHealth > 0)
                {
                    status.text = "Enemy Died";
                    somethingDead = true;
                    playerWin = true;
                }
                else
                {
                    status.text = (turnPlayer) ? "Player Turn" :"Enemy Turn";
                }
                
                if(!turnPlayer && !somethingDead)
                {
                    var dict = doAction(e, p, selectAttack(e));
                    var mess = dict["message"]!
                    var dam = dict["damage"]!
                    if(dam == "0")
                    {
                        self.status.text = "\(mess)."
                    }
                    else
                    {
                        self.status.text = "\(mess). Damage: \(dam).";
                    }
                    
                    doUpdate = 150;
                    turnPlayer = !turnPlayer;
                }
                else if (somethingDead) {
                    somethingDead = false
                    var userInfo = ["isGameOver":true, "playerWin":playerWin]
                    NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: self, userInfo: userInfo)
                }
                
                doUpdate = 150;
            }
        }
    }
    
    func setSomethingDead() {
        somethingDead = true;
    }
    
    func actionAndStatus(a:Action)
    {
        if(turnPlayer)
        {
            var dict = doAction(p, e, a);
            var mess = dict["message"]!
            var dam = dict["damage"]!
            if(dam == "0")
            {
                self.status.text = "\(mess)."
            }
            else
            {
                self.status.text = "\(mess). Damage: \(dam).";
            }
            
            doUpdate = 150;
            turnPlayer = !turnPlayer;
        }
    }
    
    func setMenuButton32(name:String!, block:(() -> Void)!) -> UIView!
    {
        var tempbutton:UIView = UIView(frame: CGRectMake(0, 0, 56, 56))
        tempbutton.setMenuActionWithBlock(block)
        
        var tempbuttonIcon:UIImageView = UIImageView(frame: CGRectMake(0, 0, 56, 56))
        tempbuttonIcon.image = UIImage(named: name)
        tempbutton.addSubview(tempbuttonIcon)
        
        return tempbutton
    }
    func setMenuButton64(name:String!, block:(() -> Void)!) -> UIView!
    {
        var tempbutton:UIView = UIView(frame: CGRectMake(0, 0, 64, 64))
        tempbutton.setMenuActionWithBlock(block)
        
        var tempbuttonIcon:UIImageView = UIImageView(frame: CGRectMake(0, 0, 64, 64))
        tempbuttonIcon.image = UIImage(named: name)
        tempbutton.addSubview(tempbuttonIcon)
        
        return tempbutton
    }
}
