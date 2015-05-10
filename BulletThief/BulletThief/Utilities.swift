//
//  Utilities.swift
//  SpaceInvaders
//
//  Created by Zachary on 4/20/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func randomElement() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

struct CollisionCategories{
    static let None : UInt32 = 0x0
    static let Enemy : UInt32 = 0x1
    static let Player: UInt32 = 0x1 << 1
    static let EnemyBullet: UInt32 = 0x1 << 2
    static let PlayerBullet: UInt32 = 0x1 << 3
    static let EdgeBody: UInt32 = 0x1 << 4

}

// Return a random range
func randomRange(min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min
        < max)
    return CGFloat(arc4random()) / 0xFFFFFFFF * (max - min) + min
}

func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
    for (index, value) in enumerate(array) {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

enum Directions: Int {
    case Left = 0
    case Right
}

enum ControlSchemes: Int {
    case Tap = 0
    case Buttons
}

var documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
var documentDirectory = documentDirectories[0] as String