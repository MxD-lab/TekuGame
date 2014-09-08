//
//  battleViewController.swift
//  multiplayerServer
//
//  Created by Stefan Alexander on 2014/09/08.
//  Copyright (c) 2014年 Stefan Alexander. All rights reserved.
//

import UIKit

class battleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func postPlayersInBattle(pid:String!, bid:String!) {
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/playersinbattle/index.php"
        var str = "playerID=\(pid)&battleID=\(bid)&submit=submit"
        post(urlstring, querystring: str)
    }
    
    func postToBattles(battleID:String!, enemAttack:String!, playAttack:String!, turn:String!, status:String!) {
        
        var urlstring = "http://tekugame.mxd.media.ritsumei.ac.jp/battleForm/index.php"
        var str = "ID=\(battleID)&lastEnemyAttack=\(enemAttack)&lastPlayerAttack=\(playAttack)&turnPlayerID=\(turn)&status=\(status)&submit=submit"
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
        postToBattles(battleID, enemAttack: "", playAttack: "", turn: "", status: "Open")
    }
}
