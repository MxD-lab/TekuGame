//
//  SecondViewContoller.swift
//  twitterSelection
//
//  Created by ステファンアレクサンダー on 2014/08/06.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var playerID:String!
    
    @IBOutlet weak var playerIDLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerIDLabel.text = "You've selected @\(playerID)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
