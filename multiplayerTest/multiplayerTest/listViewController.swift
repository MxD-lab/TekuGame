//
//  listViewController.swift
//  multiplayerCombatTest
//
//  Created by Stefan Alexander on 2014/09/03.
//  Copyright (c) 2014年 Stefan Alexander. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class listViewController: UIViewController, MCNearbyServiceBrowserDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
    // from segue
    var playerID:String!
    
    var myPeerID:MCPeerID!
    var serviceType:NSString!
    var nearbyServiceAdvertiser:MCNearbyServiceAdvertiser!
    var nearbyServiceBrowser:MCNearbyServiceBrowser!
    var session:MCSession!
    
    var otherPeerID:MCPeerID!
    var otherPeers:[MCPeerID] = []
    var otherPeersDict:[MCPeerID : [String : String]] = [:]
    
    var timer:NSTimer!
    
    var battleStarted = false
    var hostID:MCPeerID!
    
    @IBOutlet weak var playerTextView: UITextView!
    @IBOutlet weak var readyTextView: UITextView!
    @IBOutlet weak var battleTextView: UITextView!
    @IBOutlet weak var readySwitch: UISwitch!
    @IBOutlet weak var readyLabel: UILabel!
    
    @IBAction func readyTouched(sender: AnyObject) {
        startAdvertising()
        
        var readyBoolStr:String!
        if (readySwitch.on) {
            readyBoolStr = "true"
        }
        else {
            readyBoolStr = "false"
        }
        var mydict:[String:String] = ["display_name":playerID, "ready": readyBoolStr]
        
        var error:NSError?
        var data = NSKeyedArchiver.archivedDataWithRootObject(mydict)
//        println("going to send")
        session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        println("Error: \(error?.localizedDescription)")
        println("Peers: \(session.connectedPeers)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var uuid:NSUUID = NSUUID.UUID()
        myPeerID = MCPeerID(displayName: uuid.UUIDString)
        var namePeerID:NSString = myPeerID.displayName
        println("myPeerID.displayName \(namePeerID)")
        
        serviceType = "p2pcombattest"
        
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        nearbyServiceBrowser.delegate = self
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
        session.delegate = self
        
        startAdvertising()
        nearbyServiceBrowser.startBrowsingForPeers()
        
        setInterval("updatePlayerList", seconds: 1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func setInterval(functionname:String, seconds:NSNumber) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector(functionname), userInfo: nil, repeats: true)
    }
    
    func updatePlayerList() {
        if (!battleStarted) {
            var count = 0
            playerTextView.text = "\(playerID)\n"
            if (readySwitch.on) {
                readyTextView.text = "○\n"
                count++
            }
            else {
                readyTextView.text = "×\n"
            }
            
            for pl in otherPeers {
                if (otherPeersDict[pl] != nil) {
                    playerTextView.text = playerTextView.text + otherPeersDict[pl]!["display_name"]! + "\n"
                    if (otherPeersDict[pl]!["ready"]! == "true") {
                        readyTextView.text = readyTextView.text + "○\n"
                        count++
                    }
                    else {
                        readyTextView.text = readyTextView.text + "×\n"
                    }
                }
            }
            if (count >= 3) {
                initBattle()
            }
        }
    }
    
    func initBattle() {
        
        var mydict:[String:String] = ["battle":"true"]
        var error:NSError?
        var data = NSKeyedArchiver.archivedDataWithRootObject(mydict)
        session.sendData(data, toPeers: session.connectedPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
        
        battleStarted = true
        playerTextView.hidden = true
        readyTextView.hidden = true
        readySwitch.hidden = true
        readyLabel.hidden = true
        battleTextView.hidden = false
        battleTextView.text = "You have encountered a monster!\n"
        
        var hostIDText:String! = "\(myPeerID.displayName)"
        hostID = myPeerID
        for id in otherPeers {
            var IDText:String! = "\(id.displayName)"
            if (IDText < hostIDText) {
                hostIDText = IDText
                hostID = id
            }
        }
        
        if (hostIDText == "\(myPeerID.displayName)") {
            battleTextView.text = battleTextView.text + "I am the host.\n"
        }
        else {
            var hostname:String! = otherPeersDict[hostID]!["display_name"]!
            battleTextView.text = battleTextView.text + "\(hostname) is the host.\n"
        }
        
    }
    
    // Called when a browser failed to start browsing for peers. (required)
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        if ((error) != nil) {
            println("error.localizedDescription \(error.localizedDescription)")
        }
    }
    
    // Called when a new peer appears. (required)
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
//        println("found peer: \(peerID.displayName)")
        nearbyServiceBrowser.invitePeer(peerID, toSession: session, withContext: "Welcome".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), timeout: 10)
        var peer_name:AnyObject! = info["display_name"]
        var pname:String = peer_name as String
        var ready:AnyObject! = info["ready"]
        var rstr:String = ready as String
//        println("display_name: \(pname)")
        dispatch_async(dispatch_get_main_queue(), {
            if (find(self.otherPeers, peerID) == nil) {
                self.otherPeers.append(peerID)
            }
            self.otherPeersDict[peerID] = ["display_name" : pname, "ready" : rstr]
        })
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        println("lost peer: \(peerID.displayName)")
        var index = 0
        for id in otherPeers {
            if (id == peerID) {
                break
            }
            index++
        }
        
        var pname = otherPeersDict[peerID]!["display_name"]!
        if (battleStarted) {
            battleTextView.text = battleTextView.text + "Lost connection with \(pname)\n"
        }
        
        otherPeers.removeAtIndex(index)
//        otherPeersDict.removeValueForKey(peerID)
    }
    
    // Called when advertisement fails. (required)
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        if (error != nil) {
            println(error.localizedDescription)
        }
    }
    
    // Called when a remote peer invites the app to join a session. (required)
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        invitationHandler(true, session)
    }
    
    // Called when a remote peer sends an NSData object to the local peer. (required)
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        dispatch_async(dispatch_get_main_queue(), {
            var dict:[String:String]! = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [String:String]!
            
            if (dict["display_name"] != nil) {
                var pname:String! = dict["display_name"] as String!
                var ready:String! = dict["ready"] as String!
                
                self.otherPeersDict[peerID] = ["display_name" : pname, "ready" : ready]
            }
            else {
                if (!self.battleStarted) {
                    self.initBattle()
                }
            }
        })
    }
    
    // Called when a remote peer begins sending a file-like resource to the local peer. (required)
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("didStartReceivingResourceWithName")
    }
    
    // Called when a remote peer sends a file-like resource to the local peer. (required)
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        println("didFinishReceivingResourceWithName")
    }
    
    // Called when a remote peer opens a byte stream connection to the local peer. (required)
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        println("didReceiveStream")
    }
    
    // Called when the state of a remote peer changes. (required)
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println("peerID \(peerID)")
        println("state \(state) ")
        
    }
    
    // Called to authenticate a remote peer when the connection is first established. (required)
    func session(session: MCSession!, didReceiveCertificate certificate: [AnyObject]!, fromPeer peerID: MCPeerID!, certificateHandler: ((Bool) -> Void)!) {
        certificateHandler(true)
    }
    
    func startAdvertising() {
        var ready = "false"
        if (readySwitch.on) {
            ready = "true"
        }
        var discoveryInfo:NSDictionary = NSDictionary(objects: [playerID, ready], forKeys: ["display_name", "ready"])
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        playerTextView.text = ""
        if (timer != nil) {
            timer.invalidate()
        }
        timer = nil
    }
    
}
