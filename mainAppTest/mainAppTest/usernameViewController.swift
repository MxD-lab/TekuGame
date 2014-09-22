//
//  usernameViewController.swift
//  mainAppTest
//
//  Created by Stefan Alexander on 2014/09/10.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class usernameViewController: UIViewController {
    
    var playerID:String!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func startEditing(sender: AnyObject) {
        usernameTextField.backgroundColor = UIColor.whiteColor()
        errorLabel.text = ""
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        if (usernameTextField.text == "") {
            usernameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
            errorLabel.text = "Text field is empty!"
        }
        else {
            playerID = usernameTextField.text + "(tekugame)"
            if (usernameAvailable()) {
                performSegueWithIdentifier("username_accreate", sender: self)
            }
            else {
                errorLabel.text = "Username taken!"
                usernameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
                usernameTextField.text = ""
            }
        }
    }
    
    func usernameAvailable() -> Bool {
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/playerandlocation.json"
        var jsObj = getJSON(url) as [[String:AnyObject]]?

        if (jsObj != nil) {
            for data in jsObj! {
                var pid = data["phoneid"] as NSString
                
                if (pid == playerID) {
                    return false
                }
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "username_accreate") {
            var nextVC = segue.destinationViewController as AccountCreateViewController
            nextVC.playerID = playerID
        }
    }
}
