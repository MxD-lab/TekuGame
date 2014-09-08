//
//  ViewController.swift
//  multiplayerServer
//
//  Created by Stefan Alexander on 2014/09/08.
//  Copyright (c) 2014年 Stefan Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var battleTextField: UITextField!
    @IBOutlet weak var playerTextField: UITextField!
    
    var currentBattle:[NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "next") {
            var nextVC = segue.destinationViewController as secondViewController
            nextVC.battleID = battleTextField.text
            nextVC.playerID = playerTextField.text
            var prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(playerTextField.text, forKey: "playerID")
            prefs.setObject(battleTextField.text, forKey: "battleID")
        }
    }
}
