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

class GameScene: SKScene, UIPickerViewDataSource, UIPickerViewDelegate
{
    var allActions:[(String, [Action])] = [("Utility", utility), ("Physical",physical),("Magic", magic)];
    
    let canDo:[Int] = [5,17,30,43,56,68,81,94,107,120];
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    let background:SKSpriteNode = SKSpriteNode(imageNamed: "background.png");
    let status:UILabel = UILabel(frame: CGRectMake( 0, 0, 320, 20));
    let typePicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let actionPicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let enemyImage:SKSpriteNode = SKSpriteNode(imageNamed: "enemy.png");

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
        /*
        physical = Action.allPhysical;
        magic = Action.allMagic;
        
        for(var i = 9; i >= 0; i -= 1)
        {
            if(p.magic < canDo[i])
            {
                println("Removing: \(magic.last!)");
                magic.removeLast();
            }
            if(p.strength < canDo[i])
            {
                println("Removing: \(physical.last!)");
                physical.removeLast();
            }
        }
        println("Magic: \(magic)");
        println("Physical: \(physical)");
        
        */
        
        /* Setup your scene here */
        status.center = CGPointMake(160, 10);
        status.textAlignment = NSTextAlignment.Left;
        status.textColor = UIColor.blackColor();
        status.backgroundColor = UIColor.lightGrayColor();
        status.opaque = false;
        status.alpha = 0.75;
        view.addSubview(status)

        typePicker.transform = CGAffineTransformMakeScale(0.75 , 0.75);
        //typePicker.frame = CGRectMake(0, 0, 75, 10);
        //typePicker.center = CGPointMake(37.5, X);
        typePicker.center = CGPointMake(60, 250);
        typePicker.delegate = self;
        typePicker.reloadAllComponents();
        //view.addSubview(typePicker);
        actionPicker.transform = CGAffineTransformMakeScale(0.75 , 0.75);
        //actionPicker.frame = CGRectMake(0, 0, 135, 10);
        actionPicker.center = CGPointMake(500, 250);
        actionPicker.delegate = self;
        actionPicker.reloadAllComponents();
        //view.addSubview(actionPicker);
        
        var p_uppercut = setMenuButton32("P_Uppercut.png") { () -> Void in
            if(turnPlayer){
                var dict = doAction(p, e, Action.P_Uppercut);
                var mess = dict["message"]!
                var dam = dict["damage"]!
                self.status.text = "\(mess). Damage: \(dam)"
                doUpdate = 50;
                turnPlayer = !turnPlayer;
            }}
        var p_charged_strike = setMenuButton32("P_Charged_Strike.png") { () -> Void in
            if(turnPlayer){
                doAction(p, e, Action.P_Charged_Strike); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var p_meditation = setMenuButton32("P_Meditation.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.P_Meditation); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var p_leg_sweep = setMenuButton32("P_Leg_Sweep.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.P_Leg_Sweep); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var p_turbo_strike = setMenuButton32("P_Turbo_Strike.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.P_Turbo_Strike); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var p_heart_strike = setMenuButton32("P_Heart_Strike.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.P_Heart_Strike); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var p_muscle_training = setMenuButton32("P_Muscle_Training.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.P_Meditation); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var p_stomp = setMenuButton32("P_Stomp.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.P_Stomp); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var p_sacrificial_strike = setMenuButton32("P_Sacrificial_Strike.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.P_Sacrificial_Strike); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var p_overpower = setMenuButton32("P_Overpower.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.P_Overpower); doUpdate = 50; turnPlayer = !turnPlayer;}}
        
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
        
        var e_energy_ball = setMenuButton32("E_Energy_Ball.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_EnergyBall); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_icy_wind = setMenuButton32("E_Icy_Wind.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Icy_Wind); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_barrier = setMenuButton32("E_Barrier.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Barrier); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_fireball = setMenuButton32("E_Fireball.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Fireball); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_sharpen_mind = setMenuButton32("E_Sharpen_Mind.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Sharpen_Mind); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_curse = setMenuButton32("E_Curse.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Curse); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_life_drain = setMenuButton32("E_Life_Drain.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Life_Drain); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_decay = setMenuButton32("E_Decay.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Decay); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_full_heal = setMenuButton32("E_Full_Heal.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Full_Heal); doUpdate = 50; turnPlayer = !turnPlayer;}}
        var e_instant_death = setMenuButton32("E_Instant_Death.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.E_Instant_Death); doUpdate = 50; turnPlayer = !turnPlayer;}}
        
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
        
        var examineButton = setMenuButton64("U_Examine.png") { () -> Void in
            if(turnPlayer){doAction(p, e, Action.U_Examine); doUpdate = 50; turnPlayer = !turnPlayer;}}
        
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
        
        if(doUpdate > 0)
        {
            doUpdate -= 1;
        }
        else
        {
            if (step < 20)
            {
                step += 1;
                status.text = "You encountered a \(e.type.typeToStringE())";
            }
            else
            {
                somethingDead = false
                var playerWin:Bool = false;
                
                if(p.currentHealth <= 0 && e.currentHealth <= 0)
                {
                    status.text = "Both Died";
                    somethingDead = true;
//                    setTimeout("setSomethingDead", seconds: 2)
                }
                else if(p.currentHealth <= 0 && e.currentHealth > 0)
                {
                    status.text = "Player Died";
                    somethingDead = true;
                    //                    setTimeout("setSomethingDead", seconds: 2)
                }
                else if(e.currentHealth <= 0 && p.currentHealth > 0)
                {
                    status.text = "Enemy Died";
                    somethingDead = true;
                    //                    setTimeout("setSomethingDead", seconds: 2)
                    playerWin = true;
                }
                else
                {
                    status.text = (turnPlayer) ? "Player Turn" :"Enemy Turn";
                }
                
                if(!turnPlayer && !somethingDead)
                {
                    doAction(e, p, selectAttack(e));
                    turnPlayer = !turnPlayer;
                    setTimeout("changeTurn", seconds: 1)
                }
                else if (somethingDead) {
                    somethingDead = false
                    var userInfo = ["isGameOver":true, "playerWin":playerWin]
                    NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: self, userInfo: userInfo)
                }
                
                doUpdate = 50;
            }
        }
    }
    
    func changeTurn() {
        
    }
    
    func setSomethingDead() {
        somethingDead = true;
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
    
    func setTimeout(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: false)
    }
    
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int
    {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch(pickerView)
            {
        case typePicker:
            return num.count;
        case actionPicker:
            switch(typePicker.selectedRowInComponent(0))
                {
            case 0:
                return utility.count;
            case 1:
                return physical.count;
            default:
                return magic.count;
            }
        default:
            return 0;
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        switch(pickerView)
            {
        case typePicker:
            return num[row];
        case actionPicker:
            switch(typePicker.selectedRowInComponent(0))
                {
            case 0:
                return utility[row].typeToStringE();
            case 1:
                return physical[row].typeToStringE();
            case 2:
                return magic[row].typeToStringE();
            default:
                return "";
            }
        default:
            return "";
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch(pickerView)
            {
        case typePicker:
            actionPicker.reloadAllComponents();
        case actionPicker:
            break;
        default:
            break;
        }
    }
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        var label = UILabel(frame: CGRectMake(0, 0, pickerView.frame.size.width, 44))
        label.font = UIFont(name: "Optima-ExtraBlack", size: 24)
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor.whiteColor();
        
        switch(pickerView)
            {
        case typePicker:
            label.text = num[row];
        case actionPicker:
            switch(typePicker.selectedRowInComponent(0))
                {
            case 0:
                label.text = utility[row].typeToStringE();
            case 1:
                label.text = physical[row].typeToStringE();
            case 2:
                label.text = magic[row].typeToStringE();
            default:
                label.text = "";
            }
        default:
            label.text = "";
        }

        
        label.textAlignment = NSTextAlignment.Center
        return label
    }
}
