//
//  SplitShotEnemy.swift
//  BulletThief
//
//  Created by Zachary on 5/18/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

///Enemy that has chance to give splitshot effect
class SplitShotEnemy: Enemy {
    
    //MARK: - init -
    init(){ 
        var bulletEffects: [BulletEffectProtocol] = [TextureBulletEffect(textureName: "lineBullet"), FireDelayBulletEffect(delay: 4), SpeedBulletEffect(speed: 9), LinePathBulletEffect(direction: .Down), SplitBulletEffect()]
        super.init(textureName: "splitShotEnemy", bulletEffects: bulletEffects, numBullets: 1, bulletCount: 30, speed: 10, name: "enemy")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init not implemented")
    }
    
    //MARK: - Methods -
    
    //Become disabled when killed
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
        player.gun!.addEffect(SplitBulletEffect())
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
