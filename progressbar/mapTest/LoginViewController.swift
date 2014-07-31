//
//  LoginViewController.swift
//  mapTest
//
//  Created by 若尾あすか on 2014/07/23.
//  Copyright (c) 2014年 若尾あすか. All rights reserved.
//

import UIKit
import Accounts

class LoginViewController: UIViewController {
    
    // Login UI.
    @IBOutlet var loginText: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var startButton: UIButton!
    
    // Account store and string for account username.
    var accountStore = ACAccountStore()
    var username = String()
    
    // Ask the user permission to user the account information and login.
    @IBAction func loginPressed(sender: AnyObject) {
        var accountType:ACAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        var haveAccess:Bool = false
        let handler: ACAccountStoreRequestAccessCompletionHandler = { granted, error in
            if(!granted) {
                println("ユーザーがアクセスを拒否しました。")
            }
            else {
                println("ユーザーがアクセスを許可しました。")
                haveAccess = true
            }
        }
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, handler)
        
        var twitterAccounts:NSArray = accountStore.accountsWithAccountType(accountType)
        if (twitterAccounts.count > 0) {
            username = twitterAccounts[0].username
            loginText.text = "@\(username)ういっす"
            loginButton.setTitle("ログインできとるのう", forState: UIControlState.Normal)
            loginButton.enabled = false
            startButton.hidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Pass the player's username to the next view controller.
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "map") {
            var mapVC = segue.destinationViewController as ViewController
            mapVC.playerID = username
        }
    }
}

