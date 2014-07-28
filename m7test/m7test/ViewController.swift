//
//  ViewController.swift
//  m7test
//
//  Created by ステファンアレクサンダー on 2014/07/28.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

// Referenced http://stackoverflow.com/a/20938104 (Objective-C)

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var stepsCountingLabel: UILabel!
    var cmStepCounter:CMStepCounter!
    var operationQueue:NSOperationQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (CMStepCounter.isStepCountingAvailable()) {
            cmStepCounter = CMStepCounter()
            cmStepCounter.startStepCountingUpdatesToQueue(operationQueue, updateOn: 1, withHandler: {(numberOfSteps:NSInteger, timeStamp:NSDate!, error:NSError!) in
                self.stepsCountingLabel.text = "\(numberOfSteps)"
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

