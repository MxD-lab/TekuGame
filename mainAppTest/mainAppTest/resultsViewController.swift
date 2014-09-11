//
//  resultsViewController.swift
//  mainAppTest
//
//  Created by Stefan Alexander on 2014/09/11.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class resultsViewController: UIViewController {
    
    var playerwin:Bool! = false
    
    @IBOutlet weak var playerWinLabel: UILabel!
    
    @IBAction func continuePressed(sender: AnyObject) {
        performSegueWithIdentifier("results_map", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (playerwin == true) {
            playerWinLabel.text = "You win!"
        }
        else {
            playerWinLabel.text = "You lose."
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
}
