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
    var battleID:String!
    var playerID:String!
    var timer:NSTimer!
    var pcount = 0
    var pneed:Int!
    var allPlayers:[String] = []
    var hostID:String! = ""
    
    var gamestarted = false
    var beaconenem:enemy? = nil
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        battleIDLabel.text = "Battle ID: \(battleID)"
        timer = setInterval("get", seconds: 1)
        playerID = prefs.objectForKey("currentuser") as String
    }
    
    
    func setInterval(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: true)
    }
    
    func setTimeout(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: false)
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
        allPlayers = []
        pcount = 0
        battleTextView.text = battleTextView.text + "Players:\n"
        
        if (jsObj2 != nil) {
            for player in jsObj2! {
                var bid = player["battleID"] as NSString!
                if (bid == battleID) {
                    pcount++
                    var pid = player["playerID"] as NSString
                    allPlayers.append(pid)
                    battleTextView.text = battleTextView.text + "    \(pid)\n"
                }
            }
        }
        
        battleTextView.text = battleTextView.text + "Player count: \(pcount) / \(pneed)\n"
        
        if (!battleExists) {
            postToBattles(battleID, "", "", "", "", "", "Open")
        }
        else {
            if (pcount == pneed && gamestarted == false) {
                var contains:Bool = false
                for player in allPlayers {
                    if (player == playerID) {
                        contains = true
                        break
                    }
                }
                if (contains == true) {
                    gamestarted = true
                    postToBattles(battleID, "", "", "", "", "", "In Battle")
                    setHost()
//                    performSegueWithIdentifier("setup_battle", sender: nil)
                }
                else {
                    battleTextView.text = battleTextView.text + "Please wait for next battle.\n"
                }
            }
            else {
                postPlayersInBattle(playerID, battleID)
            }
        }
        
        if (gamestarted == true) {
            if (playerID == hostID) {
                performSegueWithIdentifier("setup_battle", sender: nil)
            }
            else {
                println("waiting for enemy")
                beaconenem = getEnemy()
                if (beaconenem != nil) {
                    performSegueWithIdentifier("setup_battle", sender: nil)
                }
            }
        }
    }
    
    func getEnemy() -> enemy? {
        // get enemy
        var battleEnemObj = getJSON("http://tekugame.mxd.media.ritsumei.ac.jp/json/battleenemies.json")
        if (battleEnemObj != nil) {
            for battle in battleEnemObj! {
                var ID = battle["ID"] as NSString
                if (ID == battleID) {
                    var typestr = battle["type"] as NSString
                    var subtypestr = battle["subtype"] as NSString
                    var levelstr = battle["level"] as NSString
                    var healthstr = battle["health"] as NSString
                    var strengthstr = battle["strength"] as NSString
                    var magicstr = battle["magic"] as NSString
                    var speedstr = battle["speed"] as NSString
                    
                    var type = Int(typestr.doubleValue)
                    var subtype = Int(subtypestr.doubleValue)
                    var level = Int(levelstr.doubleValue)
                    var health = Int(healthstr.doubleValue)
                    var strength = Int(strengthstr.doubleValue)
                    var magic = Int(magicstr.doubleValue)
                    var speed = Int(speedstr.doubleValue)
                    
                    println("\(type) \(subtype) \(level) \(health) \(strength) \(magic) \(speed)")
                    
                    if (type == -1) {
                        return nil
                    }
                    else {
                        var en = enemy()
                        en.type = Types.allValues[type]
                        en.subType = subtype
                        en.level = level
                        en.health = health
                        en.strength = strength
                        en.magic = magic
                        en.speed = speed
                        return en
                    }
                }
            }
        }
        return nil
    }
    
    func setHost() {
        hostID = allPlayers[0] as String
        for player in allPlayers {
            var pid = player as String
            if (pid < hostID) {
                hostID = pid
            }
        }
    }
    
//    func postToBattles(battleID:String!, enemAttack:String!, enemTarget:String!, playAttack:String!, turn:String!, currentPlayer:String!, status:String!) {
//        
//        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/battleForm/index.php"
//        var str = "ID=\(battleID)&lastEnemyAttack=\(enemAttack)&lastPlayerAttack=\(playAttack)&turnPlayerID=\(turn)&status=\(status)&enemyTargetID=\(enemTarget)&currentPlayerID=\(currentPlayer)&submit=submit"
//        post(urlstring, str)
//    }
//    
//    func postPlayersInBattle(pid:String!, bid:String!) {
//        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playersinbattle/index.php"
//        var str = "playerID=\(pid)&battleID=\(bid)&submit=submit"
//        post(urlstring, str)
//    }
    
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
        postPlayersInBattle(playerID, "-1")
        performSegueWithIdentifier("setup_map", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "setup_battle") {
            if (timer != nil) {
                timer.invalidate()
                timer = nil
            }
            var nextVC = segue.destinationViewController as GameViewController
            nextVC.allPlayers = allPlayers
            nextVC.battleID = battleID
            nextVC.beaconenem = beaconenem
        }
    }
}

