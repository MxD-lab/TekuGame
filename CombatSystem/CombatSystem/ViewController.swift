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
        
        func printAll(player:Player) -> Void
        {
            textArea.text = textArea.text + "ID: \(player.getID())\n";
            textArea.text = textArea.text + "Job: \(player.getJob())\n";
            textArea.text = textArea.text + "Level: \(player.getLevel())\n";
            textArea.text = textArea.text + "Health: \(player.getHealth())\n";
            textArea.text = textArea.text + "Strength: \(player.getStrength())\n";
            textArea.text = textArea.text + "Magic: \(player.getMagic())\n";
            textArea.text = textArea.text + "Speed: \(player.getSpeed())\n";
            textArea.text = textArea.text + "Evasion: \(player.getEvasion())\n";
            textArea.text = textArea.text + "StatPoints: \(player.getStatPoints())\n";
            textArea.text = textArea.text + "\n";
        }
        
        println("Create new character...");
        textArea.text = textArea.text + "Create new character...\n";
        var max = Player();
        printAll(max);
        var newJob = Jobs.Warrior;
        println("Assign job \(newJob)...");
        textArea.text = textArea.text + "Assign job \(newJob)...\n";
        max.setJob(newJob);
        printAll(max);
        max.getBaseValues();
        textArea.text = textArea.text + "Level up character...\n";
        textArea.text = textArea.text + "Character leveled up: prompt for stat assignment...\n";
        textArea.text = textArea.text + "5 stat points assigned to \(max.getID())\n";
        max.levelUp();
        max.getBaseValues();
        printAll(max);
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

