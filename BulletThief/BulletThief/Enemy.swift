//
//  Enemy.swift
//  BulletThief
//
//  Created by Zachary on 5/6/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    var gun:Gun!
    var movementPath:UIBezierPath?
    var weakened:Bool = false //flag to be stolen
    
    //MARK: - Init -
    convenience override init(){
        var bulletEffects: [BulletEffectProtocol] = [TextureBulletEffect(textureName: "lineBullet"), FireDelayBulletEffect(delay: 3.5), SpeedBulletEffect(speed: 8), LinePathBulletEffect(direction: Directions.Down), StandardSpawnBulletEffect()]
        self.init(textureName: "enemy", bulletEffects: bulletEffects, bulletCount: 20, speed: 5, name: "enemy")
    }
    
    init(textureName: String, bulletEffects: [BulletEffectProtocol], bulletCount: UInt, speed:CGFloat, name:String) {
        var texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        

        self.gun = Gun(initialEffects: bulletEffects, bulletCount: bulletCount, owner: self)
        self.gun.setPhysicsBody(CollisionCategories.EnemyBullet, contactBit: CollisionCategories.Player, collisionBit: CollisionCategories.None)
        self.speed = speed
        self.name = name
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Enemy
        self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBullet
        self.physicsBody?.collisionBitMask = CollisionCategories.None
        self.physicsBody?.usesPreciseCollisionDetection = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods -
    //Add path for movement
    func addPath(path:UIBezierPath) {
        self.movementPath = path
    }
    
    //MARK: - Update -
    func update(deltaTime: CFTimeInterval){
        gun.update(deltaTime)
        if gun.canShoot && !weakened {
            gun.shoot()
        }
    }
    
    //Function to perform when player steals this character's ability
    func steal(){
        
    }

    //Function called when about to die
    func willDie(){
        self.removeAllActions()
        self.removeFromParent()
    }
    
    //separate add function to add all components before being put onto screen
    func addToScene(scene:SKScene){
        var moveAction = SKAction.followPath(movementPath!.CGPath, asOffset: true, orientToPath: true, speed: self.speed)
        var removeAction = SKAction.removeFromParent()
        var onScreenActionGrp = SKAction.sequence([moveAction, removeAction])
        scene.addChild(self)
        self.runAction(onScreenActionGrp)
        
    }
}