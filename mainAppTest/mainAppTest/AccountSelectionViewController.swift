//
//  AccountSelectionViewController.swift
//  mainAppTest
//
//  Created by ステファンアレクサンダー on 2014/08/19.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit
import Accounts

class AccountSelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var accountStore = ACAccountStore()
    var twitterAccounts = NSArray()
    var accounts:[String] = []
    
    @IBOutlet weak var accountPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getAccounts()
        accountPickerView.reloadAllComponents()
    }
    
    @IBAction func refreshPickerViewPressed(sender: AnyObject) {
        getAccounts()
        accountPickerView.reloadAllComponents()
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
        
        for acc in twitterAccounts {
            accounts.append(acc.username)
        }
        
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/playerdata.json"
        var players = getJSON(url)
        
        var index = 0
        for acc in accounts {
            var inDatabase = false
            for pl in players! {
                var currentplayername = pl["ID"] as NSString
                if ("\(acc) (Twitter)" == currentplayername) {
                    inDatabase = true
                    println("in database")
                }
            }
            if (inDatabase == false) {
                accounts.removeAtIndex(index)
                println("removed \(acc)")
            }
            index++
        }
        accountPickerView.delegate = self
    }
    
    @IBAction func startGamePressed(sender: AnyObject) {
        var versionstr:NSString = UIDevice.currentDevice().systemVersion
        var versiondouble = versionstr.doubleValue
        
        var prefs = NSUserDefaults.standardUserDefaults()
        var username: AnyObject = accounts[accountPickerView.selectedRowInComponent(0)]
        var selecteduser = "\(username) (Twitter)"
        prefs.setObject(selecteduser, forKey: "currentuser")
        
        if (versiondouble < 8.0) {
            performSegueWithIdentifier("accselect_map", sender: self)
        }
        else {
            if (isConnectedToInternet()) {
                
                var stats = getMyStats()
                
                if (stats != nil) {
                    performSegueWithIdentifier("accselect_map", sender: self)
                }
                else {
                    UIAlertView(title: "Error", message: "Error occured when trying to load your stats from the server.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
            else {
                UIAlertView(title: "Error", message: "Please check your internet connection.", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        var label = UILabel(frame: CGRectMake(0, 0, pickerView.frame.size.width, 44))
        label.font = UIFont(name: "Papyrus", size: 18)
        label.textColor = UIColor.blackColor()
        label.text = accounts[row]
        label.textAlignment = NSTextAlignment.Center
        return label
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accounts.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "accselect_map" && accounts.count > 0) {
            var nextVC = segue.destinationViewController as MapViewController
            var selecteduser = "\(accounts[accountPickerView.selectedRowInComponent(0)]) (Twitter)"
            nextVC.playerID = selecteduser
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
}