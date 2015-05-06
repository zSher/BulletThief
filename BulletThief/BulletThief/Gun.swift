//
//  Gun.swift
//  BulletThief
//
//  Created by Zachary on 4/28/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

@objc protocol GunProtocol {
    func reset()
}

class Gun: SKNode, GunProtocol {
    var numberOfBulletsToFire = 1
    var bulletEffects: [BulletEffectProtocol] = []
    var bulletPool: [Bullet] = [] //the pool of bullets to be fired
    var fireDelay: CFTimeInterval = 0
    var canShoot = true
    var bulletSpawnPoints: [CGPoint] = []
    var owner:SKSpriteNode?
    
    override init(){
        super.init()
        self.bulletPool = bulletManager.requestBullets(100)
    }
    
    convenience init(initialEffects:[BulletEffectProtocol], owner:SKSpriteNode) {
        self.init()
        self.bulletEffects = initialEffects
        self.owner = owner
        calculateEffects()
    }
    
    func calculateEffects(){
        for effect in bulletEffects {
            effect.applyEffect(self)
        }
    }
    
    func shoot(player:Player){
        if canShoot {
            var scene = player.scene!
            var spawnIndex = 0
            for i in 0..<self.numberOfBulletsToFire {
                var bullet = bulletPool.removeAtIndex(0) //Pull bullet from front
                bullet.position = CGPointMake(player.position.x + bulletSpawnPoints[spawnIndex].x, player.position.y + bulletSpawnPoints[spawnIndex].y)
                
                //Create fire action group
                //follow path, return to the pool when done, remove from screen
                var followPath = SKAction.followPath(bullet.path!.CGPath, asOffset: true, orientToPath: true, speed: bullet.speed)
                var returnToPool = SKAction.runBlock({() in
                    self.bulletPool.append(bullet) //Push bullet to back
                })
                var removeAction = SKAction.removeFromParent()
                var actionGrp = SKAction.sequence([followPath, returnToPool, removeAction])
                
                scene.addChild(bullet)
                bullet.runAction(actionGrp)
                if spawnIndex < bulletSpawnPoints.count - 1 {
                    spawnIndex++
                } else {
                    spawnIndex = 0
                }
            }
            canShoot = false
        }
    }
    
    func reset(){
        numberOfBulletsToFire = 1
        bulletEffects = []
        bulletPool = []
    }
    
    var timeSinceLastShot: CFTimeInterval = 0
    func update(deltaTime: CFTimeInterval) {
        if !canShoot {
            timeSinceLastShot += deltaTime
            if timeSinceLastShot >= fireDelay {
                timeSinceLastShot = 0
                canShoot = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
