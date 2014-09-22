//
//  multiPlayerSetupViewController.swift
//  mainAppTest
//
//  Created by Stefan Alexander on 2014/09/22.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

import UIKit

class multiPlayerSetupViewController: UIViewController {
    
    @IBOutlet weak var battleIDLabel:UILabel!
    @IBOutlet weak var battleTextView:UITextView!
    var battleID:String! = "0"
    var playerID:String!
    var timer:NSTimer!
    var pcount = 0
    var allPlayers:NSMutableArray! = NSMutableArray()
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer = setInterval("get", seconds: 1)
        playerID = prefs.objectForKey("currentuser") as String
    }
    
    func setInterval(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: true)
    }
    
    func get() {
        
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/battle.json"
        var jsObj:[[String:AnyObject]]? = nil
        
        jsObj = getJSON(url)
        var battleExists:Bool = false
        
        
        if (jsObj != nil) {
            for battle in jsObj! {
                var id = battle["ID"] as NSString
                if (id == battleID) {
                    battleExists = true
                    var status = battle["status"] as NSString
                    battleTextView.text = "Battle Status: \(status)\n"
                }
            }
        }
        
        let playersurl = "http://tekugame.mxd.media.ritsumei.ac.jp/json/playersinbattle.json"
        var jsObj2 = getJSON(playersurl)
        allPlayers = NSMutableArray()
        pcount = 0
        battleTextView.text = battleTextView.text + "Players:\n"
        
        if (jsObj2 != nil) {
            for player in jsObj2! {
                var bid = player["battleID"] as NSString!
                if (bid == battleID) {
                    pcount++
                    var pid = player["playerID"] as NSString
                    allPlayers.addObject(pid)
                    battleTextView.text = battleTextView.text + "    \(pid)\n"
                }
            }
        }
        
        battleTextView.text = battleTextView.text + "Player count: \(pcount)\n"
        
        if (!battleExists) {
            postToBattles(battleID, enemAttack: "", enemTarget: "", playAttack: "", turn: "", currentPlayer: "", status: "Open")
        }
        else {
            if (pcount == 2) {
                if (allPlayers.containsObject(playerID)) {
                    postToBattles(battleID, enemAttack: "", enemTarget: "", playAttack: "", turn: "", currentPlayer: "", status: "In Battle")
                    performSegueWithIdentifier("test", sender: self)
                }
                else {
                    battleTextView.text = battleTextView.text + "Please wait for next battle.\n"
                }
            }
            else {
                postPlayersInBattle(playerID, bid: battleID)
            }
        }
    }
    
    func postToBattles(battleID:String!, enemAttack:String!, enemTarget:String!, playAttack:String!, turn:String!, currentPlayer:String!, status:String!) {
        
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/battleForm/index.php"
        var str = "ID=\(battleID)&lastEnemyAttack=\(enemAttack)&lastPlayerAttack=\(playAttack)&turnPlayerID=\(turn)&status=\(status)&enemyTargetID=\(enemTarget)&currentPlayerID=\(currentPlayer)&submit=submit"
        post(urlstring, str)
    }
    
    func postPlayersInBattle(pid:String!, bid:String!) {
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playersinbattle/index.php"
        var str = "playerID=\(pid)&battleID=\(bid)&submit=submit"
        post(urlstring, str)
    }
    
    override func viewDidDisappear(animated: Bool) {
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
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
    
    @IBAction func returnPressed(sender: AnyObject) {
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        postPlayersInBattle(playerID, bid: "-1")
        performSegueWithIdentifier("setup_map", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "setup_battle") {
            if (timer != nil) {
                timer.invalidate()
                timer = nil
            }
        }
    }
}
