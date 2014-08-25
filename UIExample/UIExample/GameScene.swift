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

class GameScene: SKScene
{
    let background = SKSpriteNode(imageNamed: "background.png");
    let status:UILabel = UILabel(frame: CGRectMake( 0, 0, 548, 20));
    let typePicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let actionPicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let enemyImage:SKSpriteNode = SKSpriteNode(imageNamed: "enemy.png");
    let actionButton:SKSpriteNode = SKSpriteNode(imageNamed: "DoAction");
    var frameCount:Int = 0;
    
    var p:player = player();
    var e:enemy = enemy();
    
    override func didMoveToView(view: SKView)
    {
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
                //println(allActions[typePicker.selectedRowInComponent(0)].1[actionPicker.selectedRowInComponent(0)]);
                println("   \(p.level)");
                println("       Health:     \(p.health)");
                println("       Strength:   \(p.strength)");
                println("       Magic:      \(p.magic)");
                println("       Speed:      \(p.speed)");
                println("       Current Health:     \(p.currentHealth)");
                println("       Current Strength:   \(p.currentStrength)");
                println("       Current Magic:      \(p.currentMagic)");
                println("       Current Speed:      \(p.currentSpeed)");
                println("   \(e.type) : \(e.level)");
                println("       Health:     \(e.health)");
                println("       Strength:   \(e.strength)");
                println("       Magic:      \(e.magic)");
                println("       Speed:      \(e.speed)");
                println("       Current Health:     \(e.currentHealth)");
                println("       Current Strength:   \(e.currentStrength)");
                println("       Current Magic:      \(e.currentMagic)");
                println("       Current Speed:      \(e.currentSpeed)");
                println(" ");
                println("Player \(p) to use action \(action) on enemy \(e)");
                doAction(p, e, action);
                println("   \(p.level)");
                println("       Health:     \(p.health)");
                println("       Strength:   \(p.strength)");
                println("       Magic:      \(p.magic)");
                println("       Speed:      \(p.speed)");
                println("       Current Health:     \(p.currentHealth)");
                println("       Current Strength:   \(p.currentStrength)");
                println("       Current Magic:      \(p.currentMagic)");
                println("       Current Speed:      \(p.currentSpeed)");
                println("   \(e.type) : \(e.level)");
                println("       Health:     \(e.health)");
                println("       Strength:   \(e.strength)");
                println("       Magic:      \(e.magic)");
                println("       Speed:      \(e.speed)");
                println("       Current Health:     \(e.currentHealth)");
                println("       Current Strength:   \(e.currentStrength)");
                println("       Current Magic:      \(e.currentMagic)");
                println("       Current Speed:      \(e.currentSpeed)");
            }
        }
    }
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        status.text = "Testing: \(frameCount)";
        frameCount += 1;
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
                        return utility[row].description;
                    case 1:
                        return physical[row].description;
                    case 2:
                        return magic[row].description;
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
