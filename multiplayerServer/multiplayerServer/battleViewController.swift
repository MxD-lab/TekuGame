//
//  battleViewController.swift
//  multiplayerServer
//
//  Created by Stefan Alexander on 2014/09/08.
//  Copyright (c) 2014年 Stefan Alexander. All rights reserved.
//

import UIKit

class battleViewController: UIViewController {
    
    @IBOutlet weak var battleTextView: UITextView!
    @IBOutlet weak var attackTextField: UITextField!
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var playerLabelID: UILabel!
    var allPlayers:NSMutableArray!
    var otherPlayers:NSMutableArray!
    var hostID:String!
    var playerID:String!
    var battleID:String!
    var turn:String! = ""
    var choseAttack:Bool! = false
    var enemyAttacking:Bool! = false
    
    @IBAction func attackPressed(sender: AnyObject) {
        // 6. post attack, goto 1.
        attackTextField.enabled = false
        attackButton.enabled = false
        choseAttack = true
        battleTextView.text = battleTextView.text + "\(playerID) used \(attackTextField.text) on the enemy.\n"
        updateBattleStatusAndPost("", eTarget: "", pAttack: attackTextField.text, tur: "", cPlayer: playerID, stat: "same")
        attackTextField.text = ""
        setTimeout("resetTurn", seconds: 3)
    }
    
    func resetTurn() {
        turn = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var prefs = NSUserDefaults.standardUserDefaults()
        playerID = prefs.objectForKey("playerID") as String
        battleID = prefs.objectForKey("battleID") as String
        playerLabelID.text = "ID: \(playerID)"
        setHost()
        otherPlayers = allPlayers
        otherPlayers.removeObject(playerID)
        setInterval("battle", seconds: 1)
    }
    
    func setInterval(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: true)
    }
    
    func setTimeout(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: false)
    }
    
    func updateBattleStatusAndPost(eAttack:String!, eTarget:String!, pAttack:String!, tur:String!, cPlayer:String!, stat:String!) {
        
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/battle.json"
        var jsObj = getJSON(url)
        
        var enemAttack = ""
        var enemTarget = ""
        var playAttack = ""
        var turnID = ""
        var currentPlayer = ""
        var status = ""
        
        for battle in jsObj {
            var id = battle["ID"] as String
            
            if (id == battleID) {
                enemAttack = battle["lastEnemyAttack"] as String
                enemTarget = battle["enemyTargetID"] as String
                playAttack = battle["lastPlayerAttack"] as String
                turnID = battle["turnPlayerID"] as String
                currentPlayer = battle["currentPlayerID"] as String
                status = battle["status"] as String
                break
            }
        }
        
        if (eAttack != "same") {
            enemAttack = eAttack
        }
        if (eTarget != "same") {
            enemTarget = eTarget
        }
        if (pAttack != "same") {
            playAttack = pAttack
        }
        if (tur != "same") {
            turnID = tur
        }
        if (cPlayer != "same") {
            currentPlayer = cPlayer
        }
        if (stat != "same") {
            status = stat
        }
        
        postToBattles(battleID, eAt: enemAttack, enemTarget: enemTarget, playAttack: playAttack, turn: turnID, currentPlayer: currentPlayer, status: status)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
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
    
    func battle() {
        battleTextView.scrollRangeToVisible(NSMakeRange(countElements(battleTextView.text), 0))
        // Host.
        if (playerID == hostID) {
            if (turn == "") {
                // 1. choose turn
                var pcount:Int! = otherPlayers.count
                var randomint:Int! = Int(arc4random_uniform(UInt32(pcount+2)))
                if (randomint == pcount + 1) {
                    turn = "enemy"
                }
                else if (randomint == pcount) {
                    turn = playerID
                }
                else {
                    turn = otherPlayers[randomint] as String
                }
                
                // 2. post turn
                updateBattleStatusAndPost("", eTarget: "", pAttack: "", tur: turn, cPlayer: "", stat: "same")
                
                // a. if turn == enemy, goto 3.
                if (turn == "enemy" && !enemyAttacking) {
                    // 3. enemy chooses attack/target
                    battleTextView.text = battleTextView.text + "It is the enemy's turn.\n"
                    attackTextField.enabled = false
                    attackButton.enabled = false
                    // Note: enemy attack & post will be done in enemyAttack()
                    enemyAttacking = true
                    setTimeout("enemyAttack", seconds: 5)
                    setTimeout("setEnemyAttacking", seconds: 10)
                }
                
                // b. if turn == host, goto 5.
                else if (turn == playerID) {
                    // 5. wait for player to choose attack
                    battleTextView.text = battleTextView.text + "It is your turn.\n"
                    attackTextField.enabled = true
                    attackButton.enabled = true
                    // Note: 6. will be done in the @IBAction func attackPressed(sender: AnyObject)
                }
                
                // c. else goto 7.
                else {
                    battleTextView.text = battleTextView.text + "It is \(turn)'s turn.\n"
                    attackTextField.enabled = false
                    attackButton.enabled = false
                }
            }
            else if (turn != "enemy" && turn != playerID) {
                // 7. get JSON
                //     a. if JSON includes playerAttack, print and goto 1.
                //     b. else, goto 7.
                checkAttackFromClient()
            }
        }
        
        // Client.
        else {
            checkBattle()
        }
    }
    
    func checkAttackFromClient() {
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/battle.json"
        var jsObj = getJSON(url)
        
        var enemAttack = ""
        var enemTarget = ""
        var playAttack = ""
        var turnID = ""
        var currentPlayer = ""
        var status = ""
        
        for battle in jsObj {
            var id = battle["ID"] as String
            
            if (id == battleID) {
                enemAttack = battle["lastEnemyAttack"] as String
                enemTarget = battle["enemyTargetID"] as String
                playAttack = battle["lastPlayerAttack"] as String
                turnID = battle["turnPlayerID"] as String
                currentPlayer = battle["currentPlayerID"] as String
                status = battle["status"] as String
                break
            }
        }
        
        if (playAttack != "") {
            battleTextView.text = battleTextView.text + "\(turn) used a \(playAttack) on the enemy.\n"
            turn = ""
        }
    }
    
    func checkBattle() {
        // 1. get JSON
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/battle.json"
        var jsObj = getJSON(url)
        
        var enemAttack = ""
        var enemTarget = ""
        var playAttack = ""
        var turnID = ""
        var currentPlayer = ""
        var status = ""
        
        for battle in jsObj {
            var id = battle["ID"] as String
            
            if (id == battleID) {
                enemAttack = battle["lastEnemyAttack"] as String
                enemTarget = battle["enemyTargetID"] as String
                playAttack = battle["lastPlayerAttack"] as String
                turnID = battle["turnPlayerID"] as String
                currentPlayer = battle["currentPlayerID"] as String
                status = battle["status"] as String
                break
            }
        }
        
        // a. if JSON turn == myID goto 2.
        if (turnID == playerID) {
            // 2. print "it is your turn", enable UI
            var battletext = battleTextView.text as String
            var arraylines = battletext.componentsSeparatedByString("\n")
            var lastline = ""
            if (arraylines.count >= 2) {
                lastline = arraylines[arraylines.count-2]
            }
            if (lastline != "It is your turn.") {
                battleTextView.text = battleTextView.text + "It is your turn.\n"
                attackTextField.enabled = true
                attackButton.enabled = true
                // 3. post (eattack = "", etarget = "", pattack = "", tur = myID, cplayer = myID, stat = "same")
                updateBattleStatusAndPost("", eTarget: "", pAttack: "", tur: playerID, cPlayer: playerID, stat: "same")
                // 4. wait for player to choose attack, print attack
                // 5. post attack (eattack = "", etarget = "", pattack = attack, tur = "", cplayer = myID, stat = "same")
                // Done in @IBAction func attackPressed(sender: AnyObject)
            }
        }
            
        // b. if JSON turn == enemy goto 6.
        else if (turnID == "enemy") {
            // 6. print "it is the enemy's turn"
            var battletext = battleTextView.text as String
            var arraylines = battletext.componentsSeparatedByString("\n")
            var lastline = ""
            if (arraylines.count >= 2) {
                lastline = arraylines[arraylines.count-2]
            }
            if (lastline != "It is the enemy's turn.") {
                battleTextView.text = battleTextView.text + "It is the enemy's turn.\n"
            }
            attackTextField.enabled = false
            attackButton.enabled = false
        }
            
        // c. if JSON turn == other client goto 7.
        else if (turnID != "") {
            // 7. print "it is \(turn)'s turn"
            var battletext = battleTextView.text as String
            var arraylines = battletext.componentsSeparatedByString("\n")
            var lastline = ""
            if (arraylines.count >= 2) {
                lastline = arraylines[arraylines.count-2]
            }
            if (lastline != "It is \(turnID)'s turn.") {
                battleTextView.text = battleTextView.text + "It is \(turnID)'s turn.\n"
            }
            attackTextField.enabled = false
            attackButton.enabled = false
        }
            
        // d. if JSON turn == "" goto 8.
        else if (turnID == "") {
            // 8. if cplayer == enemy print "enemy used \(eattack) on \(etarget)" else print "\(cplayer) used \(attack) on enemy."
            var battletext = battleTextView.text as String
            var arraylines = battletext.componentsSeparatedByString("\n")
            var lastline = ""
            if (arraylines.count >= 2) {
                lastline = arraylines[arraylines.count-2]
            }
            if (currentPlayer == "enemy") {
                if (lastline != "Enemy used \(enemAttack) on \(enemTarget).") {
                    battleTextView.text = battleTextView.text + "Enemy used \(enemAttack) on \(enemTarget).\n"
                }
            }
            else if (currentPlayer != "") {
                if (lastline != "\(currentPlayer) used \(playAttack) on the enemy.") {
                    battleTextView.text = battleTextView.text + "\(currentPlayer) used \(playAttack) on the enemy.\n"
                }
            }
            attackTextField.enabled = false
            attackButton.enabled = false
        }
    }
    
    func enemyAttack() {
        // 3. enemy chooses attack/target
        var attacks:[String!] = ["Punch", "Kick", "Fire", "Thunder", "Blizzard"]
        var randomint:Int! = Int(arc4random_uniform(UInt32(attacks.count)))
        var randomindex:Int! = Int(arc4random_uniform(UInt32(otherPlayers.count+1)))
        var target = ""
        if (randomindex == otherPlayers.count) {
            target = playerID
        }
        else {
            target = otherPlayers[randomindex] as String
        }
        var attack = attacks[randomint] as String
        battleTextView.text = battleTextView.text + "Enemy used \(attack) on \(target).\n"
        // 4. post enemy attacks, goto 1.  (eattack = attack, etarget = target, pattack = "", tur = "", cplayer = "enemy", stat = "same")
        updateBattleStatusAndPost(attack, eTarget: target, pAttack: "", tur: "", cPlayer: "enemy", stat: "same")
//        turn = ""
    }
    
    func setEnemyAttacking() {
        turn = ""
        enemyAttacking = false
    }
    
    func getJSON(urlstring:String!) -> [NSDictionary] {
        var jsonData = NSData(contentsOfURL: NSURL(string: urlstring))
        var error: NSError?
        var jsObj = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &error) as [NSDictionary]
        return jsObj
    }
    
    func postPlayersInBattle(pid:String!, bid:String!) {
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playersinbattle/index.php"
        var str = "playerID=\(pid)&battleID=\(bid)&submit=submit"
        post(urlstring, querystring: str)
    }
    
    func postToBattles(battleID:String!, eAt:String!, enemTarget:String!, playAttack:String!, turn:String!, currentPlayer:String!, status:String!) {
        
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/battleForm/index.php"
        var str = "ID=\(battleID)&lastEnemyAttack=\(eAt)&lastPlayerAttack=\(playAttack)&turnPlayerID=\(turn)&status=\(status)&enemyTargetID=\(enemTarget)&currentPlayerID=\(currentPlayer)&submit=submit"
        post(urlstring, querystring: str)
    }
    
    func post(urlstring:String!, querystring:String!) {
        var url = NSURL.URLWithString(urlstring) // URL object from URL string.
        var request = NSMutableURLRequest(URL: url) // Request.
        request.HTTPMethod = "POST" // Could be POST or GET.
        
        // Post has HTTPBody.
        var strData = querystring.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = strData
        request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: "Accept")
        request.setValue("gzip,deflate,sdch", forHTTPHeaderField: "Accept-Encoding")
        request.setValue("ja,en-US;q=0.8,en;q=0.6", forHTTPHeaderField: "Accept-Language")
        request.setValue("tekugame.mxd.media.ritsumei.ac.jp", forHTTPHeaderField: "Host")
        
        // Values returned from server.
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        
        // Reply from server.
        NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var prefs = NSUserDefaults.standardUserDefaults()
        var playerID = prefs.objectForKey("playerID") as String!
        var battleID = prefs.objectForKey("battleID") as String!
        postPlayersInBattle(playerID, bid: "-1")
        
        let playersurl = "http://tekugame.mxd.media.ritsumei.ac.jp/json/playersinbattle.json"
        var jsObj2 = getJSON(playersurl)
        allPlayers = NSMutableArray()
        var pcount = 0
        for player in jsObj2 {
            var bid = player["battleID"] as String!
            if (bid == battleID) {
                pcount++
                var pid = player["playerID"] as String
                allPlayers.addObject(pid)
            }
        }
        if (pcount == 0) {
            postToBattles(battleID, eAt: "", enemTarget: "", playAttack: "", turn: "", currentPlayer: "", status: "Open")
        }
        else {
            postToBattles(battleID, eAt: "", enemTarget: "", playAttack: "", turn: "", currentPlayer: "", status: "Battle Finished")
        }
    }
}
