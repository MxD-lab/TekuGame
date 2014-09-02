//
//  ViewController.swift
//  multipeerConnectivityTest
//
//  Created by ステファンアレクサンダー on 2014/07/29.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

// https://hirooka.pro/?p=3264 を参考に

import UIKit
import Accounts
import MultipeerConnectivity

class ViewController: UIViewController, MCNearbyServiceBrowserDelegate, MCSessionDelegate, UIAlertViewDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var myPeerID:MCPeerID!
    var serviceType:NSString!
    var nearbyServiceAdvertiser:MCNearbyServiceAdvertiser!
    var nearbyServiceBrowser:MCNearbyServiceBrowser!
    var session:MCSession!
    
    var otherPeerID:MCPeerID!
    var otherPeers:NSMutableArray = NSMutableArray()
    
    var accountStore = ACAccountStore()
    var username = "guest"
    
    @IBAction func btnLogin(sender: AnyObject) {
        getAccount()
        loginButton.hidden = true
    }
    @IBOutlet weak var peerCountLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet var outputText: UITextView!
    @IBOutlet var textInput: UITextField!
    
    @IBAction func btntest(sender: AnyObject) {
        var error:NSError?
        var chatmessage:NSString = "\(username): \(textInput.text)"
        outputText.text = "\(outputText.text)\n    →\(chatmessage)"
        textInput.text = ""
        session.sendData(chatmessage.dataUsingEncoding(NSUTF8StringEncoding), toPeers: otherPeers, withMode: MCSessionSendDataMode.Reliable, error: &error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var uuid:NSUUID = NSUUID.UUID()
        myPeerID = MCPeerID(displayName: uuid.UUIDString)
        var namePeerID:NSString = myPeerID.displayName
        println("myPeerID.displayName \(namePeerID)")

        serviceType = "p2ptest"
        
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        nearbyServiceBrowser.delegate = self
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.None)
        session.delegate = self
        
        startAdvertising()
        nearbyServiceBrowser.startBrowsingForPeers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAccount () {
        var accountType:ACAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        var haveAccess:Bool = false
        let handler: ACAccountStoreRequestAccessCompletionHandler =
        {
            granted, error in
            if(!granted) {
                println("ユーザーがアクセスを拒否しました。")
            } else {
                println("ユーザーがアクセスを許可しました。")
                haveAccess = true
            }
        }
        accountStore.requestAccessToAccountsWithType(accountType, options: nil, handler)
        var twitterAccounts:NSArray = accountStore.accountsWithAccountType(accountType)
        if (twitterAccounts.count > 0) {
            username = twitterAccounts[0].username
        }
        else {
            username = "guest"
        }
        
        usernameLabel.text = username
        
    }
    
    // MARK: - MCNearbyServiceBrowserDelegate
    
    // --------------------
    // MCNearbyServiceBrowserDelegate
    // --------------------
    
    // Error Handling Delegate Methods
    // browser:didNotStartBrowsingForPeers:
    // Called when a browser failed to start browsing for peers. (required)
    func browser(browser: MCNearbyServiceBrowser!, didNotStartBrowsingForPeers error: NSError!) {
        if (error) {
            println("error.localizedDescription \(error.localizedDescription)")
        }
    }
    
    // Peer Discovery Delegate Methods
    
    // browser:foundPeer:withDiscoveryInfo:
    // Called when a new peer appears. (required)
    func browser(browser: MCNearbyServiceBrowser!, foundPeer peerID: MCPeerID!, withDiscoveryInfo info: [NSObject : AnyObject]!) {
        println("found peer: \(peerID.displayName)")
        
        nearbyServiceBrowser.invitePeer(peerID, toSession: session, withContext: "Welcome".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), timeout: 10)
        
    }
    
    func browser(browser: MCNearbyServiceBrowser!, lostPeer peerID: MCPeerID!) {
        println("lost peer")
    }
    
    // MARK: - MCNearbyServiceAdvertiserDelegate
    
    // --------------------
    // MCNearbyServiceAdvertiserDelegate
    // --------------------
    
    // Error Handling Delegate Methods
    
    // advertiser:didNotStartAdvertisingPeer:
    // Called when advertisement fails. (required)
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
        if (error) {
            println(error.localizedDescription)
        }
    }
    
    // Invitation Handling Delegate Methods
    
    // advertiser:didReceiveInvitationFromPeer:withContext:invitationHandler:
    // Called when a remote peer invites the app to join a session. (required)
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        invitationHandler(true, session)
    }
    
    // MARK: - MCSessionDelegate
    
    // --------------------
    // MCSessionDelegate
    // --------------------
    
    // MCSession Delegate Methods
    
    // session:didReceiveData:fromPeer:
    // Called when a remote peer sends an NSData object to the local peer. (required)
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        var receivedData:NSString = NSString(data: data, encoding: NSUTF8StringEncoding)
        dispatch_async(dispatch_get_main_queue(), {
            self.outputText.text = "\(self.outputText.text)\n\(receivedData)"
        })
    }
    
    // session:didStartReceivingResourceWithName:fromPeer:withProgress:
    // Called when a remote peer begins sending a file-like resource to the local peer. (required)
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        println("didStartReceivingResourceWithName")
    }
    
    // session:didFinishReceivingResourceWithName:fromPeer:atURL:withError:
    // Called when a remote peer sends a file-like resource to the local peer. (required)
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        println("didFinishReceivingResourceWithName")
    }
    
    // session:didReceiveStream:withName:fromPeer:
    // Called when a remote peer opens a byte stream connection to the local peer. (required)
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        println("didReceiveStream")
    }
    
    // session:peer:didChangeState:
    // Called when the state of a remote peer changes. (required)
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
        println("peerID \(peerID)")
        println("state \(state) ")
        
        if (state == MCSessionState.Connected && session != nil) {
            otherPeerID = peerID
            otherPeers.addObject(otherPeerID)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.peerCountLabel.text = "\(self.otherPeers.count + 1)"
            })
        }
    }
    
    // session:didReceiveCertificate:fromPeer:certificateHandler:
    // Called to authenticate a remote peer when the connection is first established. (required)
    func session(session: MCSession!, didReceiveCertificate certificate: [AnyObject]!, fromPeer peerID: MCPeerID!, certificateHandler: ((Bool) -> Void)!) {
        certificateHandler(true)
    }
    
    // MARK: - Advertising
    
    // -----------------------------
    // Advertising
    // -----------------------------
    
    func startAdvertising() {
        var discoveryInfo:NSDictionary = NSDictionary(objects: ["foo", "bar"], forKeys: ["bar", "foo"])
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
}

