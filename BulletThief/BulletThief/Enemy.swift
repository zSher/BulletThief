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

    convenience override init(){
        var bulletEffects: [BulletEffectProtocol] = [TextureBulletEffect(textureName: "lineBullet"), FireDelayBulletEffect(delay: 3.5), SpeedBulletEffect(speed: 8), LinePathBulletEffect(direction: Directions.Down), StandardSpawnBulletEffect()]
        self.init(textureName: "enemy", bulletEffects: bulletEffects, bulletCount: 20, speed: 5, name: "enemy")
    }
    
    init(textureName: String, bulletEffects: [BulletEffectProtocol], bulletCount: UInt, speed:CGFloat, name:String) {
        var texture = SKTexture(imageNamed: "enemy")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        

        self.gun = Gun(initialEffects: bulletEffects, bulletCount: 20, owner: self)
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
    
    func addPath(path:UIBezierPath) {
        self.movementPath = path
    }
    
    func update(deltaTime: CFTimeInterval){
        gun.update(deltaTime)
        if gun.canShoot {
            gun.shoot()
        }
    }
    
    func addToScene(scene:SKScene){
        var moveAction = SKAction.followPath(movementPath!.CGPath, asOffset: true, orientToPath: true, speed: self.speed)
        var removeAction = SKAction.removeFromParent()
        var onScreenActionGrp = SKAction.sequence([moveAction, removeAction])
        scene.addChild(self)
        self.runAction(onScreenActionGrp)
        
    }
}