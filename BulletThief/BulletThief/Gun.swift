//
//  Gun.swift
//  BulletThief
//
//  Created by Zachary on 4/28/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

//Main class for all guns, different kinds of guns are created via bullet effects
class Gun: SKNode {
    var numberOfBulletsToFire: UInt = 1
    var bulletEffects: [BulletEffectProtocol] = []
    var bulletPool: [Bullet] = [] //the pool of bullets to be fired
    var fireDelay: CFTimeInterval = 0
    var canShoot = true
    var bulletSpawnPoints: [CGPoint] = []
    var bulletOffset: CGFloat = 5

    var owner:SKSpriteNode?
    
    //MARK: - Init
    override init(){
        super.init()
    }
    
    convenience init(initialEffects:[BulletEffectProtocol], numberOfBulletsToFire: UInt, bulletCount:UInt, owner:SKSpriteNode) {
        self.init()
        self.bulletPool = bulletManager.requestBullets(bulletCount)
        self.bulletEffects = initialEffects
        self.owner = owner
        self.numberOfBulletsToFire = numberOfBulletsToFire
        calculateEffects()
    }
    
    //Return bullets back to the bullet manager on deinit
    deinit {
        bulletManager.returnBullets(bulletPool)
    }
    
    //MARK: - methods -
    
    //Set the physics body of the bullets
    func setPhysicsBody(category:UInt32, contactBit:UInt32, collisionBit:UInt32){
        for bullet in bulletPool {
            bullet.setPhysicsBody(category, contactBit: contactBit, collisionBit: collisionBit)
        }
    }
    
    //Recalculate all bullet effects (usually only done on creation)
    func calculateEffects(){
        for effect in bulletEffects {
            effect.applyEffect(self)
        }
    }
    
    func addEffect(bEffect: BulletEffectProtocol){
        bEffect.applyEffect(self)
        self.bulletEffects.append(bEffect)
    }
    
    //Fire bullets
    func shoot(){
        //If not on cool down and we have bullets available
        if canShoot && (bulletPool.count - Int(numberOfBulletsToFire)) > 0{
            var scene = owner!.scene!
            var spawnIndex = 0
            //for each bullet we fire per fire
            for i in 0..<self.numberOfBulletsToFire {
                var bullet = bulletPool.removeAtIndex(0) //Pull bullet from front
                
                //offset slightly if we shoot +1 bullet every fire
                var spawnOffsetX = randomRange(-bulletOffset, bulletOffset)
                var spawnOffsetY = randomRange(-bulletOffset, bulletOffset)
                bullet.position = CGPointMake(owner!.position.x + bulletSpawnPoints[spawnIndex].x + spawnOffsetX, owner!.position.y + bulletSpawnPoints[spawnIndex].y + spawnOffsetY)
                
                //Create fire action group
                //follow path, return to the pool when done, remove from screen
                var followPath = SKAction.followPath(bullet.path!.CGPath, asOffset: true, orientToPath: true, speed: bullet.speed)
                var removeAction = SKAction.runBlock() {
                    self.returnToPool(bullet)
                }
                var actionGrp = SKAction.sequence([followPath, removeAction])
                
                if bullet.scene != nil {
                    bullet.removeFromParent()
                    println("caught failed to remove bullet")
                }
                scene.addChild(bullet)
                bullet.runAction(actionGrp)
                
                //rotate around all spawn points
                if spawnIndex < bulletSpawnPoints.count - 1 {
                    spawnIndex++
                } else {
                    spawnIndex = 0
                }
            }
            canShoot = false
        }
    }
    
    //MARK: - update -
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
    
    func returnToPool(bullet:Bullet){
        bullet.removeFromParent()
        self.bulletPool.append(bullet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
