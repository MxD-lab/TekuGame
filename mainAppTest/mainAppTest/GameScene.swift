//
//  GameScene.swift
//  mainAppTest
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

class GameScene: SKScene
{
    let background = SKSpriteNode(imageNamed: "background.png");
    let status:UILabel = UILabel(frame: CGRectMake( 0, 0, 548, 20));
    let typePicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let actionPicker:UIPickerView = UIPickerView(frame: CGRectMake(0, 0, 568, 20));
    let enemyImage:SKSpriteNode = SKSpriteNode(imageNamed: "enemy.png");
    let doActionButton = UIButton.buttonWithType(UIButtonType.System) as UIButton;
    
    var frameCount:Int = 0;
    
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

        doActionButton.frame = CGRectMake(0,0,100,25);
        doActionButton.center = CGPointMake(505, 120);
        doActionButton.backgroundColor = UIColor.lightGrayColor();
        doActionButton.layer.borderWidth = 1;
        doActionButton.layer.cornerRadius = 5;
        doActionButton.setTitle("Do Action", forState: UIControlState.Normal);
        doActionButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
        self.view.addSubview(doActionButton);
        
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
//        var vc = self.view.window!.rootViewController
//        vc.performSegueWithIdentifier("mainmap", sender: vc)
        var userInfo = NSDictionary(object: true, forKey: "isGameOver")
        NSNotificationCenter.defaultCenter().postNotificationName("GameOver", object: self, userInfo: userInfo)
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
                actionPicker.reloadAllComponents();
            case actionPicker:
                break;
            default:
                break;
        }
    }
}
