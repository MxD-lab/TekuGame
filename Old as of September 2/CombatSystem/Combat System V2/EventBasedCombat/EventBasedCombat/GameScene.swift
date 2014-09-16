//
//  GameScene.swift
//  EventBasedCombat
//
//  Created by Maxwell Perlman on 7/24/14.
//  Copyright (c) 2014 Maxwell Perlman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    
    let background = SKSpriteNode(imageNamed: "background.png");
    var button1:SKSpriteNode = SKSpriteNode(imageNamed: "buttonUp.png");
    var button2:SKSpriteNode = SKSpriteNode(imageNamed: "buttonUp.png");
    var gameOver:SKSpriteNode = SKSpriteNode(imageNamed: "GAMEOVER.png");
    var enemyGFX:SKSpriteNode = SKSpriteNode(imageNamed: "spritesize.png");
    
    var max:Player = Player();
    var enemy:Enemy = Enemy();
    
    var isTurnPlayer:Bool = true;
    var shownEnemyDead:Bool = false;
    
    var combatOrder:[Entity] = [];
    var combatCount = 0;
    
    override func didMoveToView(view: SKView)
    {   /* Setup your scene here */
        
        max.levelUp();
        max.name = "Max";
        printAll(max);
        
        enemy.setType(Types.Slime);
        enemy.name = "Goopa";
        enemy.setStats(1, health: 5, strength: 2, magic: 2, speed: 3);
        
        background.anchorPoint = CGPoint(x: 0, y: 0);
        background.size = self.size;
        background.zPosition = -2;
        self.addChild(background);
        
        enemyGFX.texture = loadEnemyGFX(enemy).0;
        enemyGFX.position = CGPoint(x: 200, y: 375);
        enemyGFX.zPosition = 1;
        enemyGFX.setScale(2);
        self.addChild(enemyGFX);

        button1.position = CGPoint(x: 900, y: 300);
        button1.setScale(5);
        button1.zPosition = 1;
        self.addChild(button1);
        
        button2.position = CGPoint(x: 900, y: 500);
        button2.setScale(5);
        button2.zPosition = 1;
        self.addChild(button2);
        
        combatOrder = setCombatOrder(enemy, max);
        if(combatOrder[0].name == max.name)
        {
            isTurnPlayer = true;
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {   /* Called when a touch begins */
        
        for touch: AnyObject in touches
        {
            let location = touch.locationInNode(self)
            if(isTurnPlayer)
            {
                if CGRectContainsPoint(button1.frame, touch.locationInNode(self))
                {
                    doAction(Move.P_Punch, max, enemy);
                    isTurnPlayer = false;
                    combatCount += 1;
                }
                if CGRectContainsPoint(button2.frame, touch.locationInNode(self))
                {
                    doAction(Move.M_EnergyBall, max, enemy);
                    isTurnPlayer = false;
                    combatCount += 1;
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval)
    {   /* Called before each frame is rendered */
        
        if(combatCount >= combatOrder.count)
        {
            combatCount = 0;
        }
        
        if(combatOrder[combatCount].name == max.name)
        {
            isTurnPlayer = true;
        }
        else
        {
            isTurnPlayer = false;
        }

        if(enemy.dead == true && shownEnemyDead == false)
        {
            enemyGFX.texture = loadEnemyGFX(enemy).1;
            shownEnemyDead = true;
        }
        else if(enemy.dead == false)
        {
            if(isTurnPlayer == false)
            {
                doAction(Move.P_Punch, enemy, max);
                combatCount += 1;
                isTurnPlayer = true;
            }
        }
        
        if(max.dead == true)
        {
            gameOver.anchorPoint = CGPoint(x: 0, y: 0);
            gameOver.size = self.size;
            gameOver.zPosition = 10;
            self.addChild(gameOver);
        }
    }
}
