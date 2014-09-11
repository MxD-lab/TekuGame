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
    var facebookAccounts = NSArray()
    var allAccounts:[(String,String)] = []
    
    @IBOutlet weak var twitterPickerView: UIPickerView!
    
    @IBAction func refreshPickerViewPressed(sender: AnyObject) {
        getAccounts()
        twitterPickerView.reloadAllComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        setTimeout("getAccounts", seconds: 2)
        getAccounts()
        twitterPickerView.reloadAllComponents()
    }
    
    func getAccounts() {
        var accountType:ACAccountType! = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        var haveAccess:Bool = false
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, { granted, error in
            if (granted) {
                self.twitterAccounts = self.accountStore.accountsWithAccountType(accountType)
            }
            else {
                println(error.description)
            }
        })
        
//        var accountStore2:ACAccountStore! = ACAccountStore()
//        var accountType2:ACAccountType! = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
//        var options = [ACFacebookAppIdKey: "343510302483842", ACFacebookAudienceKey: ACFacebookAudienceOnlyMe, ACFacebookPermissionsKey: []]
//        accountStore.requestAccessToAccountsWithType(accountType2, options: options, completion: { granted, error in
//            if (granted) {
//                self.facebookAccounts = self.accountStore.accountsWithAccountType(accountType2)
//            }
//            else {
////                println(error.description!)
//            }
//        })
        
        allAccounts = []
        for acc in twitterAccounts {
            var twacc:(String, String)! = (acc.username, "Twitter")
            allAccounts += [twacc]
        }
//        for acc in facebookAccounts {
//            var fbacc:(String, String)! = (acc.username, "Facebook")
//            allAccounts += [fbacc]
//        }

//        println(allAccounts.count)
        twitterPickerView.delegate = self
        
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(allAccounts[row].0) (\(allAccounts[row].1))"
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allAccounts.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        var label = UILabel(frame: CGRectMake(0, 0, pickerView.frame.size.width, 44))
        label.font = UIFont(name: "Optima", size: 24)
        label.textColor = UIColor.blackColor()
        label.text = "\(allAccounts[row].0) (\(allAccounts[row].1))"
        label.textAlignment = NSTextAlignment.Center
        return label
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "twselect_accreate") {
            var nextVC = segue.destinationViewController as AccountCreateViewController
            if (allAccounts.count == 0) {
                nextVC.playerID = ""
            }
            else {
                nextVC.playerID = "\(allAccounts[twitterPickerView.selectedRowInComponent(0)].0) (\(allAccounts[twitterPickerView.selectedRowInComponent(0)].1))"
            }
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
}

