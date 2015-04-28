//
//  Utilities.swift
//  SpaceInvaders
//
//  Created by Zachary on 4/20/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

struct CollisionCategories{
//    static let Invader : UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
//    static let InvaderBullet: UInt32 = 0x1 << 2
//    static let PlayerBullet: UInt32 = 0x1 << 3
    static let EdgeBody: UInt32 = 0x1 << 4

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