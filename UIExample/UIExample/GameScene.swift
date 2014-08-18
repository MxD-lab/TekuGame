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
var utility:[String] = ["Examine",];
var physical:[String] = ["Punch", "Kick"];
var magic:[String] = ["Energy Ball", "Fireball", "Lightning Strike", "Icy Wind", "Dark Ball"];

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
                println("VALUE: \(typePicker.selectedRowInComponent(component))");
                switch(typePicker.selectedRowInComponent(component))
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
                return utility[row];
            case 1:
                return physical[row];
            case 2:
                return magic[row];
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
            typePicker.reloadAllComponents();
        case actionPicker:
            actionPicker.reloadAllComponents();
        default:
            break;
        }
    }
}

class GameScene: SKScene
{
    let background = SKSpriteNode(imageNamed: "background.png");
    let status:UILabel = UILabel(frame: CGRectMake( 0, 0, 548, 20));
    let typePicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let actionPicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let enemyImage:SKSpriteNode = SKSpriteNode(imageNamed: "enemy.png");
    
    var count:Int = 0;
    
    override func didMoveToView(view: SKView)
    {
        /* Setup your scene here */
        status.center = CGPointMake(284, 10);
        status.textAlignment = NSTextAlignment.Left;
        status.textColor = UIColor.blackColor();
        self.view.addSubview(status);
        
        /*
        picker.center = CGPointMake(284, 280);
        picker.delegate = self;
        picker.reloadAllComponents();
        self.view.addSubview(picker);
        */
        
        typePicker.center = CGPointMake(284, 200);
        typePicker.delegate = self;
        typePicker.reloadAllComponents();
        self.view.addSubview(typePicker);
        
        actionPicker.center = CGPointMake(284, 100);
        actionPicker.delegate = self;
        actionPicker.reloadAllComponents();
        self.view.addSubview(actionPicker);
        
        background.anchorPoint = CGPoint(x: 0, y: 0);
        background.size = self.size;
        background.zPosition = -2;
        self.addChild(background);

        enemyImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+10);
        enemyImage.zPosition = 1;
        //self.addChild(enemyImage);
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
        /* Called when a touch begins */
        //for touch: AnyObject in touches
        //{
        //}
    }
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        status.text = "Testing: \(count)";
        count += 1;
    }
}
