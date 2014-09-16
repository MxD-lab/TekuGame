//
//  ViewController.swift
//  CombatSystem
//
//  Created by Maxwell Perlman on 7/17/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textArea: UITextView
    @IBOutlet var picArea: UIImageView
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var slimeAlive:UIImage = UIImage(named: "slime.png");
        var slimeDead:UIImage = UIImage(named: "slime.png");
        var gameOver:UIImage = UIImage(named: "gameover");
        
        picArea.image = slimeAlive;
        
        // Do any additional setup after loading the view, typically from a nib.
        var max = Player();
            max.name = "Max";
            max.levelUp();
            printAll(textArea, max);
        var slime = Enemy();
            slime.name = "Goopa";
            slime.setStats(1, health: 5, strength: 2, magic: 2, speed: 4);
        
        encounter(textArea, slime, max);
        while(max.dead != true && slime.dead != true)
        {
            doAction(textArea, Move.P_Punch, max, slime);
            if(slime.currentHealth <= 0)
            {
                slime.dead = true;
                printText(textArea, "Slime died...");
                picArea.image = slimeDead;
                break;
            }
            doAction(textArea, Move.P_Punch, slime, max);
            if(max.currentHealth <= 0)
            {
                max.dead = true;
                printText(textArea, "Max died...");
                picArea.image = gameOver;
            }
        }
        
        /*
        var mao = Player();
            mao.name = "Mao";
            mao.levelUp();
            printAll(textArea, mao);
        var stefan = Player();
            stefan.name = "Stefan";
            stefan.levelUp();
            printAll(textArea, stefan);
        var asuka = Player();
            asuka.name = "Asuka";
            asuka.levelUp();
            printAll(textArea, asuka);
        var ryo = Enemy();
            ryo.name = "Ryo";
            ryo.setType(Types.Tree);
            ryo.setStats(1, health: 10, strength: 2, magic: 0, speed: 2);
            ryo.speed = 2;
        
        encounter(textArea, ryo, max, mao, stefan, asuka);
        
        max.assignStats(textArea, HEALTH: 1,STRENGTH: 1,MAGIC: 1,SPEED: 1);
        mao.assignStats(textArea, HEALTH: 1,STRENGTH: 1,MAGIC: 1,SPEED: 1);
        stefan.assignStats(textArea, HEALTH: 1,STRENGTH: 1,MAGIC: 1,SPEED: 1);
        asuka.assignStats(textArea, HEALTH: 1,STRENGTH: 1,MAGIC: 1,SPEED: 1);
        
        printAll(textArea, max);
        printAll(textArea, mao);
        printAll(textArea, stefan);
        printAll(textArea, asuka);
        printAll(textArea, ryo);
        
        doAction(textArea, Move.P_Punch, mao, ryo);
        doAction(textArea, Move.P_SweepLeg, asuka, max);
        doAction(textArea, Move.M_EnergyBall, max, stefan);
        */
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

