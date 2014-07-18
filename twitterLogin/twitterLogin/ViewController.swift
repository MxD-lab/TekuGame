//
//  ViewController.swift
//  twitterLogin
//
//  Created by ステファンアレクサンダー on 2014/07/18.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

// http://qiita.com/exilias/items/b574e983c18b9360fe34
// http://qiita.com/135yshr/items/54a999b334f50f1709d5

import UIKit
import Accounts

class ViewController: UIViewController {
    
    @IBOutlet var signinButton: UIButton
    @IBOutlet var greetingText: UILabel
    var accountStore = ACAccountStore()
    var username = String()
    
    @IBAction func signinPressed(sender: AnyObject) {
        var accountType:ACAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        var haveAccess:Bool = false
        let handler: ACAccountStoreRequestAccessCompletionHandler =
        {
            granted, error in
            if(!granted) {
                println("ユーザーがアクセスを拒否しました。")
            } else {
                println("ユーザーがアクセスを許可しました。")
                haveAccess = true
            }
        }
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, handler)
        var twitterAccounts:NSArray = accountStore.accountsWithAccountType(accountType)
        if (twitterAccounts.count > 0) {
//            for twacc in twitterAccounts {
//                println(twacc.username)
//            }
            username = twitterAccounts[0].username
            greetingText.text = "Hello, @\(username)!!"
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
}

