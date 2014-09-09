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

class GameScene: SKScene, UIPickerViewDataSource, UIPickerViewDelegate
{
    var allActions:[(String, [Action])] = [("Utility", utility), ("Physical",physical),("Magic", magic)];
    
    let canDo:[Int] = [5,17,30,43,56,68,81,94,107,120];
    
    var turnPlayer:Bool = false;
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    let background:SKSpriteNode = SKSpriteNode(imageNamed: "background.png");
    let status:UILabel = UILabel(frame: CGRectMake( 0, 0, 548, 20));
    let typePicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let actionPicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let enemyImage:SKSpriteNode = SKSpriteNode(imageNamed: "enemy.png");
    let actionButton:SKSpriteNode = SKSpriteNode(imageNamed: "DoAction");

    var p:player = player();
    var e:enemy = enemy();
    var step:Int = 0;
    
    override func didMoveToView(view: SKView)
    {
        var userInfo = NSDictionary(object: false, forKey: "isGameOver")
        NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: self, userInfo: userInfo)
        
        /*
        var plStats:[String:[String:Int]] = prefs.objectForKey("playerStats") as [String:[String:Int]]
        var currentuser = prefs.objectForKey("currentuser") as String
        //p.level = plStats[currentuser]!["level"]!
        p.health = plStats[currentuser]!["health"]!
        p.strength = plStats[currentuser]!["strength"]!
        p.magic = plStats[currentuser]!["magic"]!
        p.speed = plStats[currentuser]!["speed"]!
        
        p.currentHealth = p.health;
        p.currentStrength = p.strength;
        p.currentMagic = p.magic;
        p.currentSpeed = p.speed;

        e.level = p.level;
        */
        e.type = Types.allValues[Int(arc4random_uniform(9))];
        e.subType = (e.type == Types.Elemental) ? Int(arc4random_uniform(3)):Int(arc4random_uniform(2));
        e = setStats(e);
        e.currentHealth = e.health;
        e.currentStrength = e.strength;
        e.currentMagic = e.magic;
        e.currentSpeed = e.speed;
        
        enemyImage.texture = getSprite(e);
        
        turnPlayer = (p.speed > e.speed) ? true : false ;
        
        physical = Action.allPhysical;
        magic = Action.allMagic;
        
        for(var i = 9; i >= 0; i -= 1)
        {
            if(p.magic < canDo[i])
            {
                println("Removing: \(magic.last)");
                magic.removeLast();
            }
            if(p.strength < canDo[i])
            {
                println("Removing: \(physical.last)");
                physical.removeLast();
            }
        }
        println("\(magic)");
        println("\(physical)");
        
        /* Setup your scene here */
        status.center = CGPointMake(284, 10);
        status.textAlignment = NSTextAlignment.Left;
        status.textColor = UIColor.blackColor();
        status.backgroundColor = UIColor.lightGrayColor();
        status.opaque = false;
        status.alpha = 0.75;
        view.addSubview(status)

        typePicker.transform = CGAffineTransformMakeScale(0.75 , 0.75);
        typePicker.frame = CGRectMake(0, 0, 75, 10);
        //typePicker.center = CGPointMake(37.5, X);
        typePicker.center = CGPointMake(60, 250);
        typePicker.delegate = self;
        typePicker.reloadAllComponents();
        //view.addSubview(typePicker);
        actionPicker.transform = CGAffineTransformMakeScale(0.75 , 0.75);
        actionPicker.frame = CGRectMake(0, 0, 135, 10);
        actionPicker.center = CGPointMake(500, 250);
        actionPicker.delegate = self;
        actionPicker.reloadAllComponents();
        //view.addSubview(actionPicker);
        
        actionButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 200);
        actionButton.size = CGSizeMake(actionButton.size.width * 2, actionButton.size.height * 2);
        actionButton.zPosition = 3;
        //addChild(actionButton);
        
        var item1:UIView = UIView(frame: CGRectMake(0, 0, 64, 64));
        item1.setMenuActionWithBlock { () -> Void in
            println("Physical");
        }
        var item1ImageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 64, 64));
        item1ImageView.image = UIImage(named: "Physical.png");
        item1.addSubview(item1ImageView);
        
        var item2:UIView = UIView(frame: CGRectMake(0, 0, 64, 64));
        item2.setMenuActionWithBlock { () -> Void in
            println("Magic");
        }
        var item2ImageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 64, 64));
        item2ImageView.image = UIImage(named: "Magic.png");
        item2.addSubview(item2ImageView);
        
        var item3:UIView = UIView(frame: CGRectMake(0, 0, 64, 64));
        item3.setMenuActionWithBlock { () -> Void in
            println("U_Examine");
        }
        var item3ImageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 64, 64));
        item3ImageView.image = UIImage(named: "U_Examine.png");
        item3.addSubview(item3ImageView);
        
        var sideMenu:HMSideMenu = HMSideMenu(items: [item1, item2, item3]);
        sideMenu.menuPosition = HMSideMenuPositionLeft;
        view.addSubview(sideMenu);
        sideMenu.open();
        
        background.anchorPoint = CGPoint(x: 0, y: 0);
        background.size = self.size;
        background.zPosition = -2;
        addChild(background);
        
        enemyImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 80);
        enemyImage.zPosition = 1;
        addChild(enemyImage);
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        for touch: AnyObject in touches
        {
            if (step >= 300) {
                if CGRectContainsPoint(actionButton.frame, touch.locationInNode(self))
                {
                    var action:Action = allActions[typePicker.selectedRowInComponent(0)].1[actionPicker.selectedRowInComponent(0)]
                    p.printAll();
                    e.printAll();
                    doAction(p, e, action);
                    turnPlayer = !turnPlayer;
                }
            }
        }
    }
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        
        if (step < 300) {
            step += 1;
            status.text = "You encountered a \(e.type.typeToStringE())";
        }
        else {
            var somethingDead:Bool = false;
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
                doAction(e, p, selectAttack(e));
                turnPlayer = !turnPlayer;
            }
            else if (somethingDead) {
                somethingDead = false
                var userInfo = ["isGameOver":true, "playerWin":playerWin]
                //var userInfo = NSDictionary(object: true, forKey: "isGameOver")
                NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: self, userInfo: userInfo)
            }
        }
        
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
