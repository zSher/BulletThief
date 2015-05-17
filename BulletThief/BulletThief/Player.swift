//
//  Player.swift
//  BulletThief
//
//  Created by Zachary on 4/24/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

///Visual representation of the player when in game mode
@IBDesignable class Player: SKSpriteNode {
    let BASE_SPEED = 100
    let BASE_FIRE_DELAY:CGFloat = 2
    var gun:Gun!
    
    //MARK: - Init -
    override init(){
        var texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())

    }
    
    //Init from sks file
    init(node: SKSpriteNode){
        super.init(texture: node.texture, color: node.color, size:node.texture!.size())
        self.position = node.position
        self.shader = node.shader
        
        self.physicsBody = SKPhysicsBody(texture: self.texture, size: self.size)
        self.name = "player"
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Player
        self.physicsBody?.contactTestBitMask = CollisionCategories.EnemyBullet
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.allowsRotation = false

        //Pull data from global playerData object
        self.speed = 100 +  CGFloat(CGFloat(playerData.speedLevel - 1) * 0.10 * 100)
                
        var bulletEffects: [BulletEffectProtocol] = playerData.bulletSet!.bulletEffects
        
        self.gun = Gun(initialEffects: bulletEffects, bulletCount: playerData.bulletSet!.numberOfStoredBullets, owner: self)
        self.gun.setPhysicsBody(CollisionCategories.PlayerBullet, contactBit: CollisionCategories.Enemy, collisionBit: CollisionCategories.None)
        
        self.gun.numberOfBulletsToFire = Int(playerData.bulletNumber)
        //TODO: Bullet damage

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Movement -
    //direction: false is left | true is right
    func move(direction:Directions, deltaTime: CFTimeInterval) {
        
        var amount = direction == .Left ? CGFloat(self.speed * -1) : CGFloat(self.speed)
        self.position.x += amount * CGFloat(deltaTime)
    }
    
    //MARK: - Update -
    func update(deltaTime: CFTimeInterval){
        gun.update(deltaTime)
        if gun.canShoot {
            gun.shoot()
        }
    }
    

}
