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
    var difficultyFlag: (low:CGFloat, high:CGFloat) = (25, 100)
    let STRAFE_CHANCE: CGFloat = 0.75
    
    //Timing variables
    var timeSinceSpawn:CFTimeInterval = 0
    var goldSpawnCoolDownMax = 10
    var goldCoolDown:CFTimeInterval = 0
    let GOLD_CD_RANGE:CGFloat = 3
    
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
    
    //Set the cooldown of gold spawn to a
    func setGoldCoolDown(){
        goldCoolDown = CFTimeInterval(randomRange(CGFloat(goldSpawnCoolDownMax) - GOLD_CD_RANGE, CGFloat(goldSpawnCoolDownMax) + GOLD_CD_RANGE))
    }
    
    //MARK: - Spawn Enemies Methods -
    func spawnEnemies(){
        if self.state == AIState.ReadyToSpawn {
            var chance = randomRange(0, 1)
            if chance < STRAFE_CHANCE {
                self.state = .StrafeSpawn
            } else {
                self.state = .Spawning
            }
        } else if self.state == .StrafeSpawn {
           //Spawn quickly on a increasing x, or decreasing x
            var numberToSpawn = 0
            if difficulty < difficultyFlag.low {
                numberToSpawn = 3
            } else if difficulty >= difficultyFlag.low && difficulty < difficultyFlag.high {
                numberToSpawn = 4
            } else {
                numberToSpawn = 5 + Int((difficulty - difficultyFlag.high) / difficultyFlag.high) //add 1 every 100 difficulty
            }
            strafeSpawn(numberToSpawn)
            self.state = .Idle
        } else if self.state == .Spawning {
            //Basic random Spawn
            if difficulty < difficultyFlag.low {
                println("easy")
                easySpawn()
                self.state = .Idle
            } else if difficulty >= difficultyFlag.low && difficulty < difficultyFlag.high {
                println("medium")
                mediumSpawn()
                self.state = .Idle
            } else {
                println("hard")
                hardSpawn()
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
    
    //Spawns enemies faster with higher chance of harder enemies
    func mediumSpawn(){
        var spawnDelay = SKAction.waitForDuration(3, withRange: 2.5)
        var spawnBlock = SKAction.runBlock(){
            var chance = randomRange(0, 1)
            
            if chance < 0.10 {
                self.spawnEnemyAtRandomLocation(GoldDashEnemy())
            } else if chance >= 0.10 && chance < 0.3 {
                self.spawnEnemyAtRandomLocation(WaveEnemy())
            } else if chance >= 0.3 && chance < 0.7 {
                self.spawnEnemyAtRandomLocation(SplitShotEnemy())
            } else {
                self.spawnEnemyAtRandomLocation(Enemy())
            }
        }
        var spawnSequence = SKAction.sequence([spawnBlock, spawnDelay])
        var spawner = SKAction.repeatAction(spawnSequence, count: Int(randomRange(7, 10)))
        var resetBlock = SKAction.runBlock() { self.resetToReady() }
        scene.runAction(SKAction.sequence([spawner, resetBlock]))
    }
    
    //Spawns enemies even faster then medium and at even faster speeds
    func hardSpawn(){
        var spawnDelay = SKAction.waitForDuration(1, withRange: 0.75)
        var spawnBlock = SKAction.runBlock(){
            var chance = randomRange(0, 1)
            
            if chance < 0.10 {
                self.spawnEnemyAtRandomLocation(GoldDashEnemy())
            } else if chance >= 0.10 && chance < 0.4 {
                self.spawnEnemyAtRandomLocation(WaveEnemy())
            } else if chance >= 0.4 && chance < 0.8 {
                self.spawnEnemyAtRandomLocation(SplitShotEnemy())
            } else {
                self.spawnEnemyAtRandomLocation(Enemy())
            }
        }
        var spawnSequence = SKAction.sequence([spawnBlock, spawnDelay])
        var spawner = SKAction.repeatAction(spawnSequence, count: Int(randomRange(2, 4)))
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
        } else if chance >= 0.3 && chance < 0.7 {
            enemyType = SplitShotEnemy()
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
    
    //MARK: - Helper Functions-
    func updateDifficulty(){
        difficulty = scene.distance //TODO: be more smart about difficulty
    }
    
    //Reset state to readyToSpawn
    func resetToReady(){
        self.state = .ReadyToSpawn
    }
    
    //Helper to spawn gold at random location
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
    
    //Helper to create line paths for spawning
    func createStraightLinePath(offset:CGSize = CGSizeZero) -> UIBezierPath {
        //create straight line movement
        var path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.addLineToPoint(CGPointMake(0, -scene.size.height - offset.height -
            20))
        return path
    }
    
    //Helper to create random spawn points above top of screen
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
