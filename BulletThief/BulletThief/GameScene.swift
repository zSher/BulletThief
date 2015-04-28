//
//  GameScene.swift
//  BulletThief
//
//  Created by Zachary on 4/24/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, HudControllerProtocol {
    var player:Player!
    var hudController: HudController!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0, 0) //no gravity
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
        player = Player()
        
        player.position = CGPointMake(self.size.width/2, player.size.height * 2.0)
        addChild(player)
        
        hudController = HudController(screenSize: self.size)
        hudController.delegate = self
        hudController.position.y = hudController.leftArrow.size.height/2 + 10
        addChild(hudController)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
        }
    }
    
    //MARK: - HudController Delgate -
    func moveDpad(hudController: HudController, deltaTime: CFTimeInterval, direction: Int) {
        //TODO: handle callback from hudController
        self.player.move(Directions(rawValue: direction)!, deltaTime: deltaTime)
    }
    
    func shootBtn(hudController: HudController, deltaTime: CFTimeInterval) {
        self.player.shoot(deltaTime)
    }
   
    var timeSinceLastUpdate: CFTimeInterval = 0
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var deltaTime = currentTime - timeSinceLastUpdate
        timeSinceLastUpdate = currentTime
        
        if deltaTime > 1.0 {
            deltaTime = 1 / 60.0
        }
        
        hudController.update(deltaTime)
    }
}

