//
//  twitterSelectViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/18.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit
import Accounts

class twitterSelectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var accountStore = ACAccountStore()
    var twitterAccounts = NSArray()
    
    @IBOutlet weak var twitterPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        while (twitterAccounts.count == 0) {
            getAccounts()
        }
        twitterPickerView.delegate = self
        twitterPickerView.reloadAllComponents()
    }
    
    func getAccounts() {
        var accountType:ACAccountType! = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        var haveAccess:Bool = false
        let handler: ACAccountStoreRequestAccessCompletionHandler = { granted, error in }
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, handler)
        twitterAccounts = accountStore.accountsWithAccountType(accountType)
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return twitterAccounts[row].username
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return twitterAccounts.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "twselect_accreate") {
            var nextVC = segue.destinationViewController as AccountCreateViewController
            nextVC.playerID = twitterAccounts[twitterPickerView.selectedRowInComponent(0)].username
        }
    }
}

