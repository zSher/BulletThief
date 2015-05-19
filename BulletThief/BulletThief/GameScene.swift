//
//  GameScene.swift
//  BulletThief
//
//  Created by Zachary on 4/24/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, HudControllerProtocol, TapControllerProtocol, SKPhysicsContactDelegate {
    var player:Player!
    var hudController: HudController?
    var tapController: TapController?
    var distanceLbl:SKLabelNode!
    var distance:CGFloat = 0
    var aiManager:AIManager!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0, 0) //no gravity
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
        var playerSpawn = childNodeWithName("player") as SKSpriteNode
        player = Player(node: playerSpawn)
        addChild(player)
        playerSpawn.removeFromParent()
        
        //Test object for testing
        var test = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(25, 25))
        test.position = CGPointMake(self.size.width/2, self.size.height/2)
        test.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(-M_PI * 2), duration: 5.0)))
        addChild(test)
        
        //Chose a control scheme to display
        if playerData.controlScheme != ControlSchemes.Tap {
            hudController = HudController(screenSize: self.size)
            hudController!.delegate = self
            hudController!.position.y = hudController!.leftArrow.size.height/2 + 10
            addChild(hudController!)
        } else {
            tapController = TapController(size: self.size)
            tapController?.delegate = self
        }
        
        distanceLbl = childNodeWithName("distanceLbl") as SKLabelNode
        distanceLbl.text = "\(distance)"
        
        aiManager = AIManager(scene: self)
    }
    
    //MARK: - touches -
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            if touchedNode.name == "enemy" {
                var enemy = touchedNode as Enemy
                if enemy.weakened && player.distanceBetween(enemy) < 25.0 {
                    enemy.steal(player)
                }
            }
            
            tapController?.touchBegan(touchLocation, touch: touch as UITouch)

        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            var to = touch as UITouch
            
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            
            tapController?.touchesEnded(touchLocation, touch: touch as UITouch)
        }
    }
    
    //MARK: - tap controller protocol -
    func directionTapped(tapController: TapController, deltaTime: CFTimeInterval, direction: Int) {
        self.player.move(Directions(rawValue: direction)!, deltaTime: deltaTime)
    }
    
    //MARK: - HudController Delgate -
    func moveDpad(hudController: HudController, deltaTime: CFTimeInterval, direction: Int) {
        //TODO: handle callback from hudController
        self.player.move(Directions(rawValue: direction)!, deltaTime: deltaTime)
    }
    
    //MARK: - update -
    var timeSinceLastUpdate: CFTimeInterval = 0
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var deltaTime = currentTime - timeSinceLastUpdate
        timeSinceLastUpdate = currentTime
        
        if deltaTime > 1.0 {
            deltaTime = 1 / 60.0
        }
        
        distance += CGFloat(deltaTime)
        distanceLbl.text = "\(floor(distance))"
        
        updateControls(deltaTime)
        player.update(deltaTime)
        
        //TODO: genericify
        enumerateChildNodesWithName("enemy") {node, stop in
            var enemy = node as Enemy
            enemy.update(deltaTime)
        }
        
        aiManager.update(deltaTime)
    }

    //ugly but oh well.
    func updateControls(deltaTime:CFTimeInterval){
        if playerData.controlScheme != ControlSchemes.Tap {
            hudController?.update(deltaTime)
        } else {
            tapController?.update(deltaTime)
        }
    }
    
    //MARK: - Physics Delegate -
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Enemy != 0) && (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0) && (firstBody.node != nil && secondBody.node != nil)) {
            // PlayerBullet vs Enemy
            (firstBody.node as Enemy).willDie()
            player.gun.returnToPool(secondBody.node! as Bullet)
        } else if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) && (secondBody.categoryBitMask & CollisionCategories.EnemyBullet != 0) && (firstBody.node != nil && secondBody.node != nil)) {
            // EnemyBullet vs Player
            //TODO: Create a screen manager to hold windows for easy transitioning
            if let scene = ShopScene.unarchiveFromFile("ShopScene") as? ShopScene {
                // Configure the view.
                let skView = self.view! as SKView
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = SKSceneScaleMode.AspectFill
                
                playerData.savePlayerData()
                skView.presentScene(scene)
            }
            
        } else if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) && (secondBody.categoryBitMask & CollisionCategories.Gold != 0) && (firstBody.node != nil && secondBody.node != nil)) {
            //Player vs gold
            secondBody.node?.removeAllActions()
            secondBody.node?.removeFromParent()
            playerData.gold += 1
        }
    }
}

