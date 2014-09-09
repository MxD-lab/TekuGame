//
//  secondViewController.swift
//  multiplayerServer
//
//  Created by Stefan Alexander on 2014/09/08.
//  Copyright (c) 2014年 Stefan Alexander. All rights reserved.
//

import UIKit

class secondViewController: UIViewController {
    
    @IBOutlet weak var battleIDLabel:UILabel!
    @IBOutlet weak var battleTextView:UITextView!
    var battleID:String!
    var playerID:String!
    var timer:NSTimer!
    var pcount = 0
    var allPlayers:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        battleIDLabel.text = "Battle ID: \(battleID)"
        timer = setInterval("get", seconds: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInterval(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: true)
    }
    
    func get() {
        
        let url = "http://tekugame.mxd.media.ritsumei.ac.jp/json/battle.json"
        var jsObj = getJSON(url)
        var battleExists:Bool = false
        
        for battle in jsObj {
            var id = battle["ID"] as String
            
            if (id == battleID) {
                battleExists = true
                var status = battle["status"] as String
                
                battleTextView.text = "Battle Status: \(status)\n"
                
            }
        }
        
        let playersurl = "http://tekugame.mxd.media.ritsumei.ac.jp/json/playersinbattle.json"
        var jsObj2 = getJSON(playersurl)
        allPlayers = NSMutableArray()
        pcount = 0
        battleTextView.text = battleTextView.text + "Players:\n"
        for player in jsObj2 {
            var bid = player["battleID"] as String!
            if (bid == battleID) {
                pcount++
                var pid = player["playerID"] as String
                allPlayers.addObject(pid)
                battleTextView.text = battleTextView.text + "    \(pid)\n"
            }
        }
        battleTextView.text = battleTextView.text + "Player count: \(pcount)\n"
        
        if (!battleExists) {
            postToBattles(battleID, enemAttack: "", enemTarget: "", playAttack: "", turn: "", currentPlayer: "", status: "Open")
        }
        else {
            if (pcount == 3) {
                if (allPlayers.containsObject(playerID)) {
                    
                    postToBattles(battleID, enemAttack: "", enemTarget: "", playAttack: "", turn: "", currentPlayer: "", status: "In Battle")
                    performSegueWithIdentifier("battle", sender: self)
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
    
    func getJSON(urlstring:String!) -> [NSDictionary] {
        var jsonData = NSData(contentsOfURL: NSURL(string: urlstring))
        var error: NSError?
        var jsObj = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &error) as [NSDictionary]
        return jsObj
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
    
    func postToBattles(battleID:String!, enemAttack:String!, enemTarget:String!, playAttack:String!, turn:String!, currentPlayer:String!, status:String!) {
        
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/battleForm/index.php"
        var str = "ID=\(battleID)&lastEnemyAttack=\(enemAttack)&lastPlayerAttack=\(playAttack)&turnPlayerID=\(turn)&status=\(status)&enemyTargetID=\(enemTarget)&currentPlayerID=\(currentPlayer)&submit=submit"
        post(urlstring, querystring: str)
    }
    
    func postPlayersInBattle(pid:String!, bid:String!) {
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playersinbattle/index.php"
        var str = "playerID=\(pid)&battleID=\(bid)&submit=submit"
        post(urlstring, querystring: str)
    }
    
    override func viewDidDisappear(animated: Bool) {
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "back") {
            postPlayersInBattle(playerID, bid: "-1")
        }
        else if (segue.identifier == "battle") {
            var nextVC = segue.destinationViewController as battleViewController
            nextVC.allPlayers = allPlayers
        }
    }
}
