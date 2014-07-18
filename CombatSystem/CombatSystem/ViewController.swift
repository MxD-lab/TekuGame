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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        func printText(input:String) -> Void
        {
            textArea.text = textArea.text + input + "\n";
            println("\(input)");
        }

        func printAll(player:Player) -> Void
        {
            printText("Name: \(player.name)");
            printText("ID: \(player.ID)");
            printText("Job: \(player.job)");
            printText("Level: \(player.level)");
            printText("Health: \(player.health)");
            printText("Strength: \(player.strength)");
            printText("Magic: \(player.magic)");
            printText("Speed: \(player.speed)");
            printText("StatPoints: \(player.statPoints)");
            printText("\n");
        }
        
        func encounter(enemy:Enemy, players:Player ...) -> Void
        {
            var player:Player;
            printText("Enemy encountered: \(enemy.type) : \(enemy.name)");
            printText("Players in encounter...");
            var playerArray = [Player]();
            var array = [Entity]();
            array.append(enemy);
            for player in players
            {
                printText(player.name);
                playerArray.append(player);
                array.append(player);
            }
            array.sort({$0.speed > $1.speed});
            printText("All sorted by speed ...");
            var counter = 0;
            for entity in array
            {
                printText(array[counter].name + "...\(array[counter].speed)");
                counter += 1;
            }
            printText("");
        }
        
        var max = Player();
            max.name = "Max";
            max.setJob(Jobs.Adventurer);
            max.levelUp();
            printAll(max);
        
        var ryo = Player();
            ryo.name = "Ryo";
            ryo.setJob(Jobs.Warrior);
            ryo.levelUp();
            printAll(ryo);
        var stefan = Player();
            stefan.name = "Stefan";
            stefan.setJob(Jobs.Mage);
            stefan.levelUp();
            printAll(stefan);
        var asuka = Player();
            asuka.name = "Asuka";
            asuka.setJob(Jobs.Ranger);
            asuka.levelUp();
            printAll(asuka);

        var tree = Enemy();
            tree.name = "Tree";
            tree.setType(Types.Tree);
            tree.speed = 7;
        
        encounter(tree, max, ryo, stefan, asuka);
        
        max.assignStats(1,STRENGTH: 1,MAGIC: 1,SPEED: 1);
        ryo.assignStats(1,STRENGTH: 1,MAGIC: 1,SPEED: 1);
        stefan.assignStats(1,STRENGTH: 1,MAGIC: 1,SPEED: 1);
        asuka.assignStats(1,STRENGTH: 1,MAGIC: 1,SPEED: 1);
        
        printAll(max);
        printAll(ryo);
        printAll(stefan);
        printAll(asuka);
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

