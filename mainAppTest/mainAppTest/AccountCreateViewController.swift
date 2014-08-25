//
//  AccountCreateViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/18.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class AccountCreateViewController: UIViewController {
    
    var playerID:String! = ""
    @IBOutlet weak var playerIDLabel : UILabel!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        playerIDLabel.text = "ID: @\(playerID)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        if (segue.identifier == "accreate_charcreate" && playerID != "") {
//            var nextVC = segue.destinationViewController as CharacterCreateViewController
//            nextVC.playerID = playerID
//        }
//    }
}
