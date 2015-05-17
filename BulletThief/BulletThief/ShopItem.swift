//
//  ShopItem.swift
//  BulletThief
//
//  Created by Zachary on 5/8/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit

//
class ShopItem: NSObject {
    var itemName:String = ""
    var detailText:String = ""
    var cost:UInt = 0
    var baseCost:UInt = 0
    var costChange:UInt = 0
    var action: (data:PlayerData) -> () //callback for what this item should do when purchased
    var equippable = false
    
    override init() {
        action = {(data) in }
        super.init()
    }
    
    convenience init(name:String, detail:String, cost:UInt, costChange:UInt, costLevel:UInt,  action: (data:PlayerData) -> (), equippable: Bool = false) {
        self.init()
        self.itemName = name
        self.detailText = detail
        self.baseCost = cost
        self.costChange = costChange
        if equippable {
            calculateEquipmentCost(playerData.purchasedBulletSetFlags[itemName]!)
        } else {
            calculateCost(costLevel)
        }
        self.action = action
        self.equippable = equippable

    }
    
    func calculateCost(costLevel: UInt){
        self.cost = baseCost + costChange * (costLevel - 1)
    }
    
    func calculateEquipmentCost(costLevel: UInt){
        if costLevel == 1  {
            self.cost = baseCost + costChange * (costLevel - 1)
        } else {
            cost = 0
        }
    }
    
    func applyItemEffect(data:PlayerData) {
        self.action(data: data) //function pointers, cooool
    }
}

//Singleton to hold all item effects that are given to a shop item
class ItemEffectLibrary {
    
    //increase movement speed by 10%
    func increaseMovementSpeed(data:PlayerData) {
        data.speedLevel += 1
    }
    
    //increase bullet fire rate by 10%
    func increaseFireRate(data:PlayerData) {
        data.bulletDelayLevel += 1
    }
    
    //increase bullet damage
    func increaseBulletDamage(data:PlayerData) {
        //TODO: Bullet damage
        println("Bullet Damage Not Completed yet")
    }
    
    //increase number of shots per fire
    func increaseBulletNumber(data:PlayerData){
        data.bulletNumber += 1
    }
    
    func equipDefaultSet(data:PlayerData){
        data.bulletSet = DefaultSet(data: data)
    }
    
    func equipDoubleCrossSet(data:PlayerData){
        data.bulletSet = DoubleCrossSet(data: data)
        println(data.bulletSet!.bulletEffects)
    }
}
var itemEffectLibrary = ItemEffectLibrary()