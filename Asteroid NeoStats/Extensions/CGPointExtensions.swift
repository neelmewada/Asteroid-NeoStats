//
//  CGPointExtensions.swift
//  Progress Tracker
//
//  Created by Neel Mewada on 23/06/21.
//

import UIKit

extension CGPoint {
    public static func +(lhs: Self, rhs: Self) -> Self {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
