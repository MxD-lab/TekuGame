//
//  battleViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/20.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class battleViewController: UIViewController {
    
    var playerID:String!
    
    @IBAction func battleEndPressed(sender: AnyObject) {
        battleEnd()
    }
    
    func battleEnd() {
        performSegueWithIdentifier("battle_map", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "battle_map") {
            var nextVC = segue.destinationViewController as MapViewController
            nextVC.playerID = playerID
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.toRaw())
    }
}
