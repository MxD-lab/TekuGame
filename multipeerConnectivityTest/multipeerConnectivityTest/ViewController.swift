//
//  ViewController.swift
//  multipeerConnectivityTest
//
//  Created by ステファンアレクサンダー on 2014/07/29.
//  Copyright (c) 2014年 ステファンアレクサンダー. All rights reserved.
//

// https://hirooka.pro/?p=3264 を参考に

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCNearbyServiceBrowserDelegate, MCSessionDelegate, UIAlertViewDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var myPeerID:MCPeerID!
    var serviceType:NSString!
    var nearbyServiceAdvertiser:MCNearbyServiceAdvertiser!
    var nearbyServiceBrowser:MCNearbyServiceBrowser!
    var session:MCSession!
    
    var otherPeerID:MCPeerID!
    
//    @IBOutlet var labelMyPeer: UILabel!
//    @IBOutlet var labelYourPeer: UILabel!
    @IBOutlet var outputText: UITextView!
    @IBOutlet var textInput: UITextField!
    
//    @IBAction func btnStartAdvertising(sender: AnyObject) {
//        startAdvertising()
//    }
    
//    @IBAction func btnStopAdvertising(sender: AnyObject) {
//        nearbyServiceAdvertiser.stopAdvertisingPeer()
//    }
    
//    @IBAction func btnStartBrowsing(sender: AnyObject) {
//        nearbyServiceBrowser.startBrowsingForPeers()
//    }
    
//    @IBAction func btnStopBrowsing(sender: AnyObject) {
//        nearbyServiceBrowser.stopBrowsingForPeers()
//    }
    
    @IBAction func btntest(sender: AnyObject) {
        var error:NSError?
        var message:NSString = textInput.text
        outputText.text = outputText.text + "\n自分： \(message)"
        textInput.text = ""
        session.sendData(message.dataUsingEncoding(NSUTF8StringEncoding), toPeers: NSArray(object: otherPeerID), withMode: MCSessionSendDataMode.Reliable, error: &error)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var uuid:NSUUID = NSUUID.UUID()
        myPeerID = MCPeerID(displayName: uuid.UUIDString)
        var namePeerID:NSString = myPeerID.displayName
        println("myPeerID.displayName \(namePeerID)")
        
//        labelMyPeer.text = myPeerID.displayName
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
    
    func showAlert(title:String!, message:String!) {
        var alert:UIAlertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
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
        showAlert("found peer", message: peerID.displayName)
//        labelYourPeer.text = peerID.displayName
        
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
            showAlert("ERROR didNotStartAdvertisingPeer", message: error.localizedDescription)
        }
    }
    
    // Invitation Handling Delegate Methods
    
    // advertiser:didReceiveInvitationFromPeer:withContext:invitationHandler:
    // Called when a remote peer invites the app to join a session. (required)
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        invitationHandler(true, session)
        showAlert("didReceiveInvitationFromPeer", message: "accept invitation!")
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
        println("\(receivedData)")
        dispatch_async(dispatch_get_main_queue(), {
            self.outputText.text = self.outputText.text + "\nヤツ： \(receivedData)"
        })
        
        showAlert("didReceiveData", message: receivedData)
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
            println("session sends data!")
            var error:NSError?
            var message:NSString = "message from \(myPeerID.displayName)"
            otherPeerID = peerID
//            session.sendData(message.dataUsingEncoding(NSUTF8StringEncoding), toPeers: NSArray(object: otherPeerID), withMode: MCSessionSendDataMode.Reliable, error: &error)
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

