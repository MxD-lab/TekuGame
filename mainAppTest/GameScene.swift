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
    //
    var allPlayers:[String] = []
    var otherPlayers:NSMutableArray!
    var hostID:String!
    var playerID:String!
    var battleID:String!
    var turn:String! = ""
    var choseAttack:Bool! = false
    var enemyAttacking:Bool! = false
    var isMultiplayer:Bool! = false
    var beaconenem:enemy?
    
    var allPlayerStats:[String:[String:AnyObject]]! = ["":[:]]
    
    var allActions:[(String, [Action])] = [("Utility", utility), ("Physical",physical),("Magic", magic)];
    
    let canDo:[Int] = [5,17,30,43,56,68,81,94,107,120];
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    let background:SKSpriteNode = SKSpriteNode(imageNamed: "background.png");
    var status:UILabel! = UILabel(frame: CGRectMake( 0, 0, 320, 50));
    let typePicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let actionPicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let enemyImage:SKSpriteNode = SKSpriteNode(imageNamed: "enemy.png");
    var playerStatus:UILabel = UILabel(frame: CGRectMake(0,0,320, 50));

    var step:Int = 0;
    
    func setPlayerStats(inout player_a:player) {
        var plStats:[String:[String:AnyObject]] = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
        var currentuser = prefs.objectForKey("currentuser") as String
        player_a.level = plStats[currentuser]!["level"]! as Int
        player_a.health = plStats[currentuser]!["health"]! as Int
        player_a.strength = plStats[currentuser]!["strength"]! as Int
        player_a.magic = plStats[currentuser]!["magic"]! as Int
        player_a.speed = plStats[currentuser]!["speed"]! as Int
        
        player_a.currentHealth = p.health;
        player_a.currentStrength = p.strength;
        player_a.currentMagic = p.magic;
        player_a.currentSpeed = p.speed;
    }
    
    func setEnemyStats(inout enemy_a:enemy, level:Int) {
        enemy_a.level = level;
        
        enemy_a.type = Types.allValues[Int(arc4random_uniform(10))];
        enemy_a.subType = (enemy_a.type == Types.Elemental) ? Int(arc4random_uniform(4)):Int(arc4random_uniform(3));
        enemy_a = setStats(enemy_a);
        enemy_a.currentHealth = enemy_a.health;
        enemy_a.currentStrength = enemy_a.strength;
        enemy_a.currentMagic = enemy_a.magic;
        enemy_a.currentSpeed = enemy_a.speed;
    }
    
    func setStatusBar(inout stat:UILabel!) {
        stat.center = CGPointMake(160, 25);
        stat.textAlignment = NSTextAlignment.Center;
        stat.textColor = UIColor.blackColor();
        stat.backgroundColor = UIColor.lightGrayColor();
        stat.opaque = false;
        stat.alpha = 0.75;
        stat.font = UIFont(name: "Optima-ExtraBlack", size: 15);
        stat.numberOfLines = 0;
        stat.lineBreakMode = NSLineBreakMode.ByWordWrapping;
    }
    
    func setPlayerStatusBar(inout pstat:UILabel) {
        pstat.center = CGPointMake(160,518);
        pstat.textAlignment = NSTextAlignment.Center;
        pstat.backgroundColor = UIColor.lightGrayColor();
        pstat.opaque = false;
        pstat.alpha = 0.75;
        pstat.font = UIFont(name: "Optima-ExtraBlack", size: 15);
        pstat.numberOfLines = 2;
    }
    
    override func didMoveToView(view: SKView)
    {
        if (allPlayers.count > 0) {
            isMultiplayer = true
        }
        
        if (isMultiplayer == true) {
            setHost()
            println("host: \(hostID)")
        }
        else {
            println("is not multiplayer")
        }
        
        var userInfo = NSDictionary(object: false, forKey: "isGameOver")
        NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: self, userInfo: userInfo)
        
        setPlayerStats(&p)
        
        /* Setup your scene here */
        setStatusBar(&status)
        view.addSubview(status)
        
        setPlayerStatusBar(&playerStatus)
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
        
        for can in canDo.reverse() {
            if(p.magic < can)
            {
                magicArr.removeLastObject();
            }
            if(p.strength < can)
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
        
        if (isMultiplayer == true) {
            println("multi")
            
            allPlayerStats.removeValueForKey("")
            
            if (playerID == hostID) {
                var enemylevel:Int = 0
                
                for player in allPlayers {
                    var temp = getPlayer(player) as [String:AnyObject]!
                    allPlayerStats[player] = temp
                    var level = temp["level"]! as Int
                    enemylevel += level
                }
                
                enemylevel = (enemylevel / allPlayers.count) + (allPlayers.count / 2);
                setEnemyStats(&e, level: enemylevel); // (sum of levels / # players)  +  (#players/2))
//                println("elevel \(e.level) \(enemylevel)");
                postLog("Fight Begin - Player: level: \(p.level), health: \(p.health), magic: \(p.magic), speed: \(p.speed), strength: \(p.strength), remaining points: \(p.points)");
                postLog("Fight Begin - Enemy: level: \(enemylevel), type: \(e.type), subtype: \(e.subType), health: \(e.health), magic: \(e.magic), speed: \(e.speed), strength: \(e.strength)");
            }
            else {
                e = beaconenem!
                println("Enemy: level: \(e.level), type: \(e.type), subtype: \(e.subType), health: \(e.health), magic: \(e.magic), speed: \(e.speed), strength: \(e.strength)")
            }
            enemyImage.texture = getSprite(e);
            enemyImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 80);
            enemyImage.zPosition = 1;
            addChild(enemyImage);
            initEnemy()
            
            turnPlayer = (p.speed > e.speed) ? true : false ;
            
        }
        else {
            println("player")
            setEnemyStats(&e, level: p.level + Int(arc4random_uniform(2)));
            enemyImage.texture = getSprite(e);
            enemyImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 80);
            enemyImage.zPosition = 1;
            addChild(enemyImage);
            turnPlayer = (p.speed > e.speed) ? true : false ;
            postLog("Fight Begin - Player: level: \(p.level), health: \(p.health), magic: \(p.magic), speed: \(p.speed), strength: \(p.strength), remaining points: \(p.points)");
            postLog("Fight Begin - Enemy: type: \(e.type), subtype: \(e.subType), health: \(e.health), magic: \(e.magic), speed: \(e.speed), strength: \(e.strength)");
        }
    }
    
    func initEnemy() {
        if (playerID == hostID) {
            // post enemy
            postEnemy(e);
        }
        else {
            
        }
    }
    
    func postEnemy(enem:enemy) {
        var url = "http://tekugame.mxd.media.ritsumei.ac.jp/battleenemiesForm/"
        var atype = enem.type.typeToIndex() as Int
        println(atype)
        var query = "ID=\(battleID)&type=\(atype)&subtype=\(enem.subType)&level=\(enem.level)&health=\(enem.health)&strength=\(enem.strength)&magic=\(enem.magic)&speed=\(enem.speed)&submit=submit"
        println(query)
        post(url, query)
    }
    
    func setHost() {
        hostID = allPlayers[0] as String
        for player in allPlayers {
            var pid = player as String
            if (pid < hostID) {
                hostID = pid
            }
        }
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
                    postLog("Fight: Both Died");
                    somethingDead = true;
                }
                else if(p.currentHealth <= 0 && e.currentHealth > 0)
                {
                    status.text = "Player Died";
                    postLog("Fight: Player Died");
                    somethingDead = true;
                }
                else if(e.currentHealth <= 0 && p.currentHealth > 0)
                {
                    status.text = "Enemy Died";
                    postLog("Fight: Enemy Died");
                    somethingDead = true;
                    playerWin = true;
                }
                else
                {
                    status.text = (turnPlayer) ? "Player Turn" : "Enemy Turn";
                }
                
                if(turnPlayer && !typeMenu.isOpen)
                {
                    typeMenu.open();
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
                    
                    postLog("Fight: Enemy Attack: \(mess). Damage: \(dam)");
                    doUpdate = 150;
                    turnPlayer = !turnPlayer;
                }
                else if (somethingDead) {
                    somethingDead = false
                    if (isMultiplayer == true) {
                        postPlayersInBattle(playerID, "-1")
                        e.type = Types.empty
                        postEnemy(e)
                    }
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
            turnPlayer = !turnPlayer;
            typeMenu.close();
            if(physicalMenu.isOpen)
            {
                physicalMenu.close();
            }
            if(magicMenu.isOpen)
            {
                magicMenu.close();
            }
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
            postLog("Fight: Player Attack: \(mess). Damage: \(dam)");
            doUpdate = 150;
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
