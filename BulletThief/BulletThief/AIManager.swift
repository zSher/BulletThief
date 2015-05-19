//
//  AIManager.swift
//  BulletThief
//
//  Created by Zachary on 5/18/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

enum AIState {
    case Idle
    case ReadyToSpawn
    case Spawning
    case StrafeSpawn
}

///Class to manage spawning / difficulty
class AIManager: NSObject {
    var scene:GameScene!
    var state:AIState = AIState.ReadyToSpawn
    var difficulty:CGFloat = 0
    var goldNode:SKSpriteNode!
    
    //Timing variables
    var timeSinceSpawn:CFTimeInterval = 0
    var goldSpawnCoolDownMax = 10
    var goldCoolDown:CFTimeInterval = 0
    
    //MARK: - Init -
    init(scene:GameScene){
        self.scene = scene
        super.init()
        self.createGoldBody()
        self.setGoldCoolDown()
    }
    
    //MARK: - Update -
    func update(deltaTime: CFTimeInterval) {
        updateDifficulty();
        
        spawnGold(deltaTime)
        spawnEnemies()
    }
    
    //MARK: - Gold Spawn Methods -
    func spawnGold(deltaTime: CFTimeInterval) {
        if timeSinceSpawn >= goldCoolDown {
            spawnGoldAtRandomLocation()
            self.setGoldCoolDown()
            timeSinceSpawn = 0
        } else {
            timeSinceSpawn += deltaTime
        }
    }
    
    func setGoldCoolDown(){
        goldCoolDown = CFTimeInterval(randomRange(CGFloat(goldSpawnCoolDownMax) - 3, CGFloat(goldSpawnCoolDownMax) + 3))
    }
    
    //MARK: - Spawn Enemies Methods -
    func spawnEnemies(){
        if self.state == AIState.ReadyToSpawn {
            var chance = randomRange(0, 1)
            if chance < 0.75 {
                self.state = .StrafeSpawn
            } else {
                self.state = .Spawning
            }
        } else if self.state == .StrafeSpawn {
           //Spawn quickly on a increasing x, or decreasing x
            var numberToSpawn = 0
            if difficulty < 25 {
                numberToSpawn = 3
            } else if difficulty >= 25 && difficulty < 100 {
                numberToSpawn = 4
            } else {
                numberToSpawn = 5
            }
            strafeSpawn(numberToSpawn)
            self.state = .Idle
        } else if self.state == .Spawning {
            //Basic random Spawn
            if difficulty < 25 {
                println("easy")
                easySpawn()
                self.state = .Idle
            } else if difficulty >= 25 {
                println("medium")
                mediumSpawn()
                self.state = .Idle
            }
        } else if self.state == .Idle {
            //Wait for spawn to finish
        }
    }
    
    //MARK: - Basic Spawn Difficulties -
    func easySpawn(){
        var spawnDelay = SKAction.waitForDuration(4, withRange: 2)
        var spawnBlock = SKAction.runBlock(){
            self.spawnEnemyAtRandomLocation(Enemy())
        }
        var spawnSequence = SKAction.sequence([spawnBlock, spawnDelay])
        var spawner = SKAction.repeatAction(spawnSequence, count: Int(randomRange(5, 8)))
        var resetBlock = SKAction.runBlock() { self.resetToReady() }
        scene.runAction(SKAction.sequence([spawner, resetBlock]))
    }
    
    func mediumSpawn(){
        var spawnDelay = SKAction.waitForDuration(3, withRange: 2.5)
        var spawnBlock = SKAction.runBlock(){
            var chance = randomRange(0, 1)
            
            if chance < 0.10 {
                self.spawnEnemyAtRandomLocation(GoldDashEnemy())
            } else if chance >= 0.10 && chance < 0.3 {
                self.spawnEnemyAtRandomLocation(WaveEnemy())
            } else {
                self.spawnEnemyAtRandomLocation(Enemy())
            }
        }
        var spawnSequence = SKAction.sequence([spawnBlock, spawnDelay])
        var spawner = SKAction.repeatAction(spawnSequence, count: Int(randomRange(7, 10)))
        var resetBlock = SKAction.runBlock() { self.resetToReady() }
        scene.runAction(SKAction.sequence([spawner, resetBlock]))
    }
    
    //MARK: - Strafe -
    //Spawn enemies in a wave
    func strafeSpawn(numberToSpawn:Int){
        //Choose enemy type
        var chance = randomRange(0, 1)
        var enemyType:Enemy!
        if chance < 0.10 {
            enemyType = GoldDashEnemy()
        } else if chance >= 0.10 && chance < 0.3 {
            enemyType = WaveEnemy()
        } else {
            enemyType = Enemy()
        }
        
        //Pick a side to spawn, and set the incr/dec amount
        var isLeftSpawn = randomRange(0, 1) >= 0.5
        var spawnPosition = createRandomTopPoint(offset: enemyType.size)
        var spawnChangeAmount = isLeftSpawn ? enemyType.size.width : -enemyType.size.width
        
        var spawnDelay = SKAction.waitForDuration(0.5)
        var spawnBlock = SKAction.runBlock() {
            var enemy = enemyType.copy() as Enemy
            enemy.position = spawnPosition
            
            //create straight line movement
            var enemyPath = self.createStraightLinePath(offset: enemy.size)
            enemy.addPath(enemyPath)
            
            var moveAction = SKAction.followPath(enemy.movementPath!.CGPath, asOffset: true, orientToPath: false, speed: enemy.speed)
            var removeAction = SKAction.removeFromParent()
            var onScreenActionGrp = SKAction.sequence([moveAction, removeAction])
            
            enemy.addToScene(self.scene)
            enemy.runAction(onScreenActionGrp)
            
            spawnPosition.x += spawnChangeAmount
        }
        
        var sequenceAction = SKAction.sequence([spawnBlock, spawnDelay])
        var repeateAction = SKAction.repeatAction(sequenceAction, count: numberToSpawn)
        var resetBlock = SKAction.runBlock() { self.resetToReady() }
        var strafeFullAction = SKAction.sequence([repeateAction, resetBlock])
        scene.runAction(strafeFullAction)
    }
    
    //MARK: - Helper Functions -
    func updateDifficulty(){
        difficulty = scene.distance //TODO: be more smart about difficulty
    }
    
    func resetToReady(){
        self.state = .ReadyToSpawn
    }
    
    func spawnGoldAtRandomLocation() {
        
        var gold = goldNode.copy() as SKSpriteNode
        gold.speed = goldNode.speed //not copied for some reason
        
        
        gold.position = createRandomTopPoint(offset: gold.size)
        
        //create straight line movement
        var path = createStraightLinePath(offset: gold.size)
        
        var moveAction = SKAction.followPath(path.CGPath, asOffset: true, orientToPath: false, speed: gold.speed)
        var removeAction = SKAction.removeFromParent()
        var onScreenActionGrp = SKAction.sequence([moveAction, removeAction])
        
        scene.addChild(gold)
        
        gold.runAction(onScreenActionGrp)
    }
    
    //AI Manager spawns new enemies
    func spawnEnemyAtRandomLocation(enemy:Enemy){
        enemy.position = createRandomTopPoint(offset: enemy.size)
        
        //create straight line movement
        var enemyPath = createStraightLinePath(offset: enemy.size)
        enemy.addPath(enemyPath)
        enemy.addToScene(scene)
        
    }
    
    func createStraightLinePath(offset:CGSize = CGSizeZero) -> UIBezierPath {
        //create straight line movement
        var path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.addLineToPoint(CGPointMake(0, -scene.size.height - offset.height -
            20))
        return path
    }
    
    func createRandomTopPoint(offset: CGSize = CGSizeZero) -> CGPoint {
        var xRand = randomRange(0, scene.size.width)
        var yPos = scene.size.height + offset.height
        return CGPointMake(xRand, yPos)
    }
    
    //Create a single gold node to copy from
    func createGoldBody(){
        var goldTexture = SKTexture(imageNamed: "goldItem")
        goldNode = SKSpriteNode(texture: goldTexture, color: UIColor.clearColor(), size: goldTexture.size())
        goldNode.physicsBody = SKPhysicsBody(edgeLoopFromRect: goldNode.frame)
        goldNode.physicsBody?.dynamic = true
        goldNode.physicsBody?.categoryBitMask = CollisionCategories.Gold
        goldNode.physicsBody?.contactTestBitMask = CollisionCategories.Player
        goldNode.physicsBody?.collisionBitMask = CollisionCategories.None
        goldNode.physicsBody?.usesPreciseCollisionDetection = false
        goldNode.speed = 10
        goldNode.name = "gold"
    }
}
