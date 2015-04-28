//
//  PlayerData.swift
//  BulletThief
//
//  Created by Zachary on 4/25/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation

class PlayerData: NSObject, NSCoding {
    var gold: UInt = 0 //Standard currency
    var farthestTraveled: UInt = 0 //"highscore" per say
    var player: Player? //For saving player weapons etc
    
    init(player:Player) {
        self.player = player
    }
    
    convenience init(player:Player, gold:UInt, farthestTraveled: UInt) {
        self.init(player: player)
        self.gold = gold
        self.farthestTraveled = farthestTraveled
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        //Grab data, call convience init
        var player = aDecoder.decodeObjectForKey("player") as Player
        var gold = aDecoder.decodeObjectForKey("gold") as UInt
        var travel = aDecoder.decodeObjectForKey("travel") as UInt
        self.init(player: player, gold: gold, farthestTraveled: travel)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(gold, forKey: "gold")
        aCoder.encodeObject(farthestTraveled, forKey: "travel")
        aCoder.encodeObject(player, forKey: "player")
    }
}