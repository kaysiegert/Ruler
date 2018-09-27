//
//  FastComparable.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 27.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal protocol FastComparable: AnyObject & Hashable {
    static func <<(lhs: Self, rhs: Self) -> Bool
}

internal extension FastComparable {
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
    static func <<=(lhs: Self, rhs: Self) -> Bool {
        return lhs << rhs || lhs == rhs
    }
    
    static func >>(lhs: Self, rhs: Self) -> Bool {
        return !(lhs << rhs) && !(lhs == rhs)
    }
    
    static func >>=(lhs: Self, rhs: Self) -> Bool {
        return (lhs == rhs) || !(lhs << rhs)
    }
}
