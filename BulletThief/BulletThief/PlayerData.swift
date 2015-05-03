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
    var controlScheme: String = "tap"
    
    var path = documentDirectory.stringByAppendingPathComponent("BulletThief.archive")
    
    override init(){
        super.init()
        
    }
    
    init(player:Player) {
        self.player = player
    }
    
    convenience init(player:Player, gold:UInt, farthestTraveled: UInt, controlScheme: String) {
        self.init(player: player)
        self.gold = gold
        self.farthestTraveled = farthestTraveled
        self.controlScheme = controlScheme
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        //Grab data, call convience init
        var player = aDecoder.decodeObjectForKey("player") as Player
        var gold = aDecoder.decodeObjectForKey("gold") as UInt
        var travel = aDecoder.decodeObjectForKey("travel") as UInt
        var controlScheme = aDecoder.decodeObjectForKey("controlScheme") as String
        self.init(player: player, gold: gold, farthestTraveled: travel, controlScheme: controlScheme)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(gold, forKey: "gold")
        aCoder.encodeObject(farthestTraveled, forKey: "travel")
        aCoder.encodeObject(player, forKey: "player")
    }
    
    func savePlayerData(){
        if NSKeyedArchiver.archiveRootObject(self, toFile: path) {
            println("Success writing to file!")
            
            //Debug code below
            //            var loadTiles = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as NSArray
            //            println(loadTiles)
        }
        else {
            println("Unable to write to file!")
        }
    }
    
    func loadPlayerData() -> PlayerData? {
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? PlayerData {
            return data
        }
        else {
            return nil
        }
    }
}

var playerData: PlayerData = PlayerData()