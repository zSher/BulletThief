//
//  ShopScene.swift
//  BulletThief
//
//  Created by Zachary on 4/30/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

class ShopScene: SKScene {
    var table:UITableView!
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            if touchedNode.name == "start" {
                if let scene = GameScene.unarchiveFromFile("BattleScene") as? GameScene {
                    // Configure the view.
                    let skView = self.view! as SKView
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    skView.presentScene(scene)
                }
            }
        }
    }
    
    deinit {
    }
    

}
