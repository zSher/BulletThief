//
//  WaveEnemy.swift
//  BulletThief
//
//  Created by Zachary on 5/16/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

class WaveEnemy: Enemy {
    
    //MARK: - init -
    init(){
        var bulletEffects: [BulletEffectProtocol] = [TextureBulletEffect(textureName: "lineBullet"), FireDelayBulletEffect(delay: 3.5), SpeedBulletEffect(speed: 10), WavePathBulletEffect(dir: Directions.Down), StandardSpawnBulletEffect()]
        super.init(textureName: "waveEnemy", bulletEffects: bulletEffects, numBullets: 1, bulletCount: 10, speed: 8, name: "enemy")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init not implemented")
    }

    //MARK: - Methods -
    
    //Always become disabled when killed
    override func willDie() {
        //Chance to disable
        var chance = randomRange(0, 1)
        if chance < 0.1 {
            self.speed = 6
            self.weakened = true
            self.physicsBody?.categoryBitMask = CollisionCategories.None //become unhittable
            var colorizeAction = SKAction.colorizeWithColor(UIColor.grayColor(), colorBlendFactor: 1, duration: 5.0)
            var rotateAction = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(-M_PI * 2), duration: 10.0))
            var groupAction = SKAction.group([rotateAction, colorizeAction])
            self.runAction(groupAction)
        } else {
            super.willDie()
        }

    }
    
    override func steal(player:Player){
        player.gun!.addEffect(WavePathBulletEffect(dir: Directions.Up))
        self.removeAllActions()
        self.removeFromParent()
    }
    
    override func addToScene(scene: SKScene) {
        var moveAction = SKAction.followPath(movementPath!.CGPath, asOffset: true, orientToPath: false, speed: self.speed)
        var removeAction = SKAction.removeFromParent()
        var onScreenActionGrp = SKAction.sequence([moveAction, removeAction])
        scene.addChild(self)
        self.runAction(onScreenActionGrp)
    }
}
