//
//  GameViewController.swift
//  mainAppTest
//
//  Created by Maxwell Perlman on 8/8/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    var incremented = false
    var segued = false
    var pwin = false
    var leveledUp = false
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func awakeFromNib() {
        var notifcenter = NSNotificationCenter.defaultCenter()
        notifcenter.addObserver(self, selector: "gameOver:", name: "GameOver", object: nil)
    }
    
    func gameOver(notification: NSNotification) {
        var userInfo:NSDictionary = notification.userInfo!
        var gmover:Bool = false
        pwin = false

        if (userInfo.objectForKey("isGameOver") != nil) {
            gmover = userInfo.objectForKey("isGameOver") as Bool
        }

        if (userInfo.objectForKey("playerWin") != nil) {
            pwin = userInfo.objectForKey("playerWin") as Bool
            println("Pwin: \(pwin)")
        }

        if (gmover && pwin && !incremented) {
            var enemiesbeaten = 0
            var prefs = NSUserDefaults.standardUserDefaults()
            prefs.removeObjectForKey("encounterStep")
            if (prefs.objectForKey("enemiesBeaten") != nil) {
                enemiesbeaten = prefs.objectForKey("enemiesBeaten") as Int
                enemiesbeaten += 1
                prefs.setObject(enemiesbeaten, forKey: "enemiesBeaten")
            }
            else {
                prefs.setObject(1, forKey: "enemiesBeaten")
            }
            
            // Assign experience stuff when won.
            var plStats:[String:[String:AnyObject]] = prefs.objectForKey("playerStats") as [String:[String:AnyObject]]
            var currentuser = prefs.objectForKey("currentuser") as String
            var exp:Int = plStats[currentuser]!["exp"]! as Int
            var level:Int = plStats[currentuser]!["level"]! as Int
            var assignpoints:Int = plStats[currentuser]!["assignpoints"]! as Int
            
            exp += 1
            if (exp == 10 * level) {
                level += 1
                exp = 0
                assignpoints += 20
                leveledUp = true
            }
            
            plStats[currentuser]!["exp"]! = exp
            plStats[currentuser]!["level"]! = level
            plStats[currentuser]!["assignpoints"]! = assignpoints
            
            prefs.setObject(plStats, forKey: "playerStats")
            
            incremented = true
//            performSegueWithIdentifier("mainmap", sender: self)
            performSegueWithIdentifier("results", sender: self)
        }
        else if (gmover && !pwin && !segued) {
            segued = true
            
            var prefs = NSUserDefaults.standardUserDefaults()
            // Assign experience stuff when lost.
            var plStats:[String:[String:Int]] = prefs.objectForKey("playerStats") as [String:[String:Int]]
            var currentuser = prefs.objectForKey("currentuser") as String
            var exp:Int = plStats[currentuser]!["exp"]!
            
            if (exp > 0) {
               exp -= 1
            }
            
            plStats[currentuser]!["exp"]! = exp
            prefs.setObject(plStats, forKey: "playerStats")

//            performSegueWithIdentifier("mainmap", sender: self)
            performSegueWithIdentifier("results", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "results") {
            var nextVC = segue.destinationViewController as resultsViewController
            nextVC.playerwin = pwin
            nextVC.leveledUp = leveledUp
        }
    }

    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        let skView = self.view as SKView
        skView.presentScene(nil)
    }
}
