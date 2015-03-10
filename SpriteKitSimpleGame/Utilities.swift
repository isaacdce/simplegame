//
//  Utilities.swift
//  SpriteKitSimpleGame
//
//  Created by Isaac Diaz on 2/12/15.
//  Copyright (c) 2015 Isaac Diaz. All rights reserved.
//

import SpriteKit

let π = CGFloat(M_PI)

enum PhysicsCategory : UInt32 {
    case All     = 0xffffffff
    case None    = 0
    case Frame   = 0b1
    case Enemy   = 0b10
    case Bullet  = 0b100
    case PowerUp = 0b1000
    case Player  = 0b10000
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

public func random(#min: CGFloat, #max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func + (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

func - (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

func * (point: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: point.dx * scalar, dy: point.dy * scalar)
}

func / (point: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: point.dx / scalar, dy: point.dy / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGVector) -> CGVector {
    return CGVector(sqrtf(Float(a)))
    }
#endif

extension CGVector {
    func length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    func normalized() -> CGVector {
        return self / length()
    }
}