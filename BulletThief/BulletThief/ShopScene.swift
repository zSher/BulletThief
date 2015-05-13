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
    var currentShopIndex = 0
    var shopItems:[ShopItem] = []
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        shopItems = [
            ShopItem(name: "Thrusters +", detail: "Movement speed +10%", cost: 50, costChange: 50, costLevel: playerData.speedLevel, action: itemEffectLibrary.increaseMovementSpeed),
            ShopItem(name: "Coolant +", detail: "Fire rate +10%", cost: 100, costChange: 100, costLevel: playerData.bulletDelayLevel, action: itemEffectLibrary.increaseFireRate),
            ShopItem(name: "Caliber +", detail: "Bullet Damage +1", cost: 200, costChange: 200, costLevel: playerData.bulletDamage, action: itemEffectLibrary.increaseBulletDamage),
            ShopItem(name: "Barrel +", detail: "Bullets fird 1+", cost: 300, costChange: 300, costLevel: playerData.bulletNumber, action: itemEffectLibrary.increaseBulletNumber)
        ]
        
        updateShopDisplay()
    }
    
    //TODO: Fix up, clean up
    func updateCosts(){
        shopItems[0].calculateCost(playerData.speedLevel)
        shopItems[1].calculateCost(playerData.bulletDelayLevel)
        shopItems[2].calculateCost(playerData.bulletDamage)
        shopItems[3].calculateCost(playerData.bulletNumber)
    }
    
    func updateShopDisplay(){
        //Update UI with Shop content
        for i in 0..<4 {
            var node = childNodeWithName("item\(i + 1)")
            var itemNumber = i + (currentShopIndex * 4)
            var nameLbl = node?.childNodeWithName("itemName") as SKLabelNode
            var detailLbl = node?.childNodeWithName("detailText") as SKLabelNode
            var costLbl = node?.childNodeWithName("cost") as SKLabelNode
            var buySprite = node?.childNodeWithName("buyButton") as SKSpriteNode
            
            var item = shopItems[itemNumber]
            nameLbl.text = item.itemName
            detailLbl.text = item.detailText
            costLbl.text = "Cost: \(item.cost)"
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)  
            let touchedNode = self.nodeAtPoint(touchLocation)
        
            if touchedNode.name! == "buyButton" {
                var parent = touchedNode.parent!
                
                var blad: String = "hi"
                var lastCharacterString: String = parent.name![4]
                var item = shopItems[lastCharacterString.toInt()! - 1 + (currentShopIndex * 4)]
                item.applyItemEffect(playerData)
                updateCosts()
                playerData.savePlayerData()
                self.updateShopDisplay()
            }
            
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
