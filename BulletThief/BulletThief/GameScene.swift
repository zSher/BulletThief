//
//  GameScene.swift
//  BulletThief
//
//  Created by Zachary on 4/24/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, HudControllerProtocol, TapControllerProtocol {
    var player:Player!
    var hudController: HudController?
    var tapController: TapController?
    var enemy:Enemy!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0, 0) //no gravity
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
        var playerSpawn = childNodeWithName("player") as SKSpriteNode
        player = Player(node: playerSpawn)
        addChild(player)
        playerSpawn.removeFromParent()
        
        var test = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(25, 25))
        test.position = CGPointMake(self.size.width/2, self.size.height/2)
        addChild(test)
        if playerData.controlScheme != ControlSchemes.Tap {
            hudController = HudController(screenSize: self.size)
            hudController!.delegate = self
            hudController!.position.y = hudController!.leftArrow.size.height/2 + 10
            addChild(hudController!)
        } else {
            tapController = TapController(size: self.size)
            tapController?.delegate = self
        }
        
        var enemySpawner = SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(){self.spawnEnemy()}, SKAction.waitForDuration(2, withRange: 1)]))
        self.runAction(enemySpawner)
        spawnEnemy()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)

            if touchedNode == self {
                tapController?.touchBegan(touchLocation, touch: touch as UITouch)
            }
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
    
    func directionTapped(tapController: TapController, deltaTime: CFTimeInterval, direction: Int) {
        self.player.move(Directions(rawValue: direction)!, deltaTime: deltaTime)
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
//    var testTime:Double = 0
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var deltaTime = currentTime - timeSinceLastUpdate
        timeSinceLastUpdate = currentTime
        
        if deltaTime > 1.0 {
            deltaTime = 1 / 60.0
        }
        
//        testTime += deltaTime
//        println(testTime)
        updateControls(deltaTime)
        player.update(deltaTime)
        
        enumerateChildNodesWithName("enemy") {node, stop in
            var enemy = node as Enemy
            enemy.update(deltaTime)
        }
        
    }
    
    // Return a random range
    func randomRange(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min
            < max)
        return CGFloat(arc4random()) / 0xFFFFFFFF * (max - min) + min
    }
    
    func spawnEnemy(){
        enemy = Enemy()
        var xRand = self.randomRange(0, max: self.size.width)
        var yPos = self.size.height + enemy.size.height
        enemy.position = CGPointMake(xRand, yPos)
        
        //create straight line movement
        var enemyPath = UIBezierPath()
        enemyPath.moveToPoint(CGPointZero)
        enemyPath.addLineToPoint(CGPointMake(0, -self.size.height - enemy.size.height - 20))
        enemy.addPath(enemyPath)
        enemy.addToScene(self)

    }

    //ugly but oh well.
    func updateControls(deltaTime:CFTimeInterval){
        if playerData.controlScheme != ControlSchemes.Tap {
            hudController?.update(deltaTime)
        } else {
            tapController?.update(deltaTime)
        }
    }
}

