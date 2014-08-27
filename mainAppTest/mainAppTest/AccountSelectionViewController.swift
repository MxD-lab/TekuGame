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
    
    var accounts:NSMutableArray! = NSMutableArray()
    
    @IBOutlet weak var accountPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var prefs = NSUserDefaults.standardUserDefaults()
        if ((prefs.objectForKey("useraccounts")) != nil) {
            accounts = prefs.objectForKey("useraccounts") as NSMutableArray
        }
        accountPickerView.delegate = self
        accountPickerView.reloadAllComponents()
    }
    
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return accounts[row] as String
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return accounts.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "accselect_map" && accounts.count > 0) {
            var prefs = NSUserDefaults.standardUserDefaults()
            prefs.setObject(accounts[accountPickerView.selectedRowInComponent(0)] as String, forKey: "currentuser")
            var nextVC = segue.destinationViewController as MapViewController
            nextVC.playerID = accounts[accountPickerView.selectedRowInComponent(0)] as String
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }
}

