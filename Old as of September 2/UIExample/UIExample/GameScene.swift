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

var allActions:[(String, [Action])] = [("Utility", utility), ("Physical",physical),("Magic", magic)];

var turnPlayer:Bool = false;

class GameScene: SKScene
{
    let background = SKSpriteNode(imageNamed: "background.png");
    let status:UILabel = UILabel(frame: CGRectMake( 0, 0, 548, 20));
    let typePicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let actionPicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let enemyImage:SKSpriteNode = SKSpriteNode(imageNamed: "enemy.png");
    let actionButton:SKSpriteNode = SKSpriteNode(imageNamed: "DoAction");
    
    var p:player = player();
    var e:enemy = enemy();
    
    override func didMoveToView(view: SKView)
    {

        p.level = 1;
        p = setStats(p, 0.25, 0.25, 0.25, 0.25);
        e.level = 1;
        e.type = Types.Humanoid;
        e = setStats(e);
        e.currentHealth = e.health;
        e.currentStrength = e.strength;
        e.currentMagic = e.magic;
        e.currentSpeed = e.speed;
        
        turnPlayer = (p.speed > e.speed) ? true : false ;
        
        /* Setup your scene here */
        status.center = CGPointMake(284, 10);
        status.textAlignment = NSTextAlignment.Left;
        status.textColor = UIColor.blackColor();
        status.backgroundColor = UIColor.lightGrayColor();
        status.opaque = false;
        status.alpha = 0.75;
        self.view.addSubview(status);
        
        typePicker.transform = CGAffineTransformMakeScale(0.75 , 0.75);
        typePicker.frame = CGRectMake(0, 0, 75, 10);
        //typePicker.center = CGPointMake(37.5, X);
        typePicker.center = CGPointMake(60, 250);
        typePicker.delegate = self;
        typePicker.reloadAllComponents();
        self.view.addSubview(typePicker);
        
        actionPicker.transform = CGAffineTransformMakeScale(0.75 , 0.75);
        actionPicker.frame = CGRectMake(0, 0, 135, 10);
        actionPicker.center = CGPointMake(500, 250);
        actionPicker.delegate = self;
        actionPicker.reloadAllComponents();
        self.view.addSubview(actionPicker);
        
        actionButton.position = CGPointMake(CGRectGetMidX(self.frame) + 400, CGRectGetMidY(self.frame) + 80);
        actionButton.size = CGSizeMake(actionButton.size.width * 2, actionButton.size.height * 2);
        actionButton.zPosition = 3;
        self.addChild(actionButton);
        
        background.anchorPoint = CGPoint(x: 0, y: 0);
        background.size = self.size;
        background.zPosition = -2;
        self.addChild(background);

        enemyImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 80);
        enemyImage.zPosition = 1;
        self.addChild(enemyImage);
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        for touch: AnyObject in touches
        {
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
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        var somethingDead:Bool = false;
        
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
    }
}

extension GameScene: UIPickerViewDataSource
{
    func numberOfComponentsInPickerView(colorPicker: UIPickerView!) -> Int
    {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int
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
}

extension GameScene: UIPickerViewDelegate
{
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
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
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
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
}