//
//  ShopScene.swift
//  BulletThief
//
//  Created by Zachary on 4/30/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

//Middle scene player deals with to upgrade their player
//Shop has multiple pages of items
class ShopScene: SKScene {
    var table:UITableView!
    var currentShopIndex = 0
    var shopItems:[ShopItem] = []
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        
        //Create a main set of items that scale off of character's current upgrades
        shopItems = [
            ShopItem(name: "Thrusters +", detail: "Movement speed +10%", cost: 50, costChange: 50, costLevel: playerData.speedLevel, action: itemEffectLibrary.increaseMovementSpeed),
            ShopItem(name: "Coolant +", detail: "Fire rate +10%", cost: 100, costChange: 100, costLevel: playerData.bulletDelayLevel, action: itemEffectLibrary.increaseFireRate),
            ShopItem(name: "Caliber +", detail: "Bullet Damage +1", cost: 200, costChange: 200, costLevel: playerData.bulletDamage, action: itemEffectLibrary.increaseBulletDamage),
            ShopItem(name: "Barrel +", detail: "Bullets fird 1+", cost: 300, costChange: 300, costLevel: playerData.bulletNumber, action: itemEffectLibrary.increaseBulletNumber),
            ShopItem(name: "SplitShot", detail: "Double bullet fun", cost: 10000, costChange: 50000, costLevel: 1, action: itemEffectLibrary.increaseMovementSpeed),
            ShopItem(name: "SplitShot", detail: "Double bullet fun", cost: 10000, costChange: 50000, costLevel: 1, action: itemEffectLibrary.increaseMovementSpeed),
            ShopItem(name: "SplitShot", detail: "Double bullet fun", cost: 10000, costChange: 50000, costLevel: 1, action: itemEffectLibrary.increaseMovementSpeed),
            ShopItem(name: "SplitShot", detail: "Double bullet fun", cost: 10000, costChange: 50000, costLevel: 1, action: itemEffectLibrary.increaseMovementSpeed),
            ShopItem(name: "SplitShot", detail: "Double bullet fun", cost: 10000, costChange: 50000, costLevel: 1, action: itemEffectLibrary.increaseMovementSpeed)
        ]
        
        updateShopDisplay()
    }
    
    //TODO: Fix up, clean up
    //Update the costs of items after you purchase them.
    func updateCosts(){
        shopItems[0].calculateCost(playerData.speedLevel)
        shopItems[1].calculateCost(playerData.bulletDelayLevel)
        shopItems[2].calculateCost(playerData.bulletDamage)
        shopItems[3].calculateCost(playerData.bulletNumber)
        //TODO: other items
    }
    
    //Refresh the shop display based on current shop index
    func updateShopDisplay(){
        //Update UI with Shop content
        for i in 0..<4 {
            var node = childNodeWithName("item\(i + 1)")
            var itemNumber = i + (currentShopIndex * 4)
            var nameLbl = node?.childNodeWithName("itemName") as SKLabelNode
            var detailLbl = node?.childNodeWithName("detailText") as SKLabelNode
            var costLbl = node?.childNodeWithName("cost") as SKLabelNode
            var buySprite = node?.childNodeWithName("buyButton") as SKSpriteNode
            
            if itemNumber < shopItems.count {
                var item = shopItems[itemNumber]
                nameLbl.text = item.itemName
                detailLbl.text = item.detailText
                costLbl.text = "Cost: \(item.cost)"
            } else {
                nameLbl.text = "Not available"
                detailLbl.text = "Not available"
                costLbl.text = "Cost: XXX"
            }
        }
        
        var goldNode = childNodeWithName("goldLbl") as SKLabelNode
        goldNode.text = "Gold: \(playerData.gold)"
    }
    
    //MARK: - touches -
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)  
            let touchedNode = self.nodeAtPoint(touchLocation)
        
            if touchedNode.name == "buyButton" {
                var parent = touchedNode.parent!
                
                var lastCharacterString: String = parent.name![4]
                if lastCharacterString.toInt()! - 1 + (currentShopIndex * 4) < shopItems.count {
                    var item = shopItems[lastCharacterString.toInt()! - 1 + (currentShopIndex * 4)]
                    if playerData.gold >= item.cost{
                        item.applyItemEffect(playerData)
                        playerData.gold -= item.cost
                        updateCosts()
                        playerData.savePlayerData()
                        self.updateShopDisplay()
                    } else {
                        //TODO: display alert, not enough gold
                    }
                }
            } else if touchedNode.name == "start" {
                if let scene = GameScene.unarchiveFromFile("BattleScene") as? GameScene {
                    // Configure the view.
                    let skView = self.view! as SKView
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    skView.presentScene(scene)
                }
            } else if touchedNode.name == "nextPage" {
                if (currentShopIndex + 1) * 4 < shopItems.count{
                    currentShopIndex++
                    updateShopDisplay()
                }

            } else if touchedNode.name == "backPage" {
                if currentShopIndex > 0 {
                    currentShopIndex--
                    updateShopDisplay()
                }
            }
            
        }
    }
    
    deinit {
    }
    
    

}
