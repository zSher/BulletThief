//
//  Bullet.swift
//  BulletThief
//
//  Created by Zachary on 4/28/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

class Bullet: SKSpriteNode {
    var damage: UInt = 0
    var path: UIBezierPath?
    
    convenience init(name:String){
        var tex = SKTexture(imageNamed: name)
        self.init(texture: tex, dmg: 1)
    }
    
    init(texture:SKTexture, dmg:UInt) {
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.damage = dmg

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
