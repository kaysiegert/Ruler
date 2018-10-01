//
//  WorldTests.swift
//  RulerTests
//
//  Created by Johannes Heinke Business on 26.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode: hasUniqueKey {
    var key: Int {
        return self.hash
    }
}

final class WorldTests: RulerTests {
    
    final func testWorldFunctionInsert() {
        var world = UndirectedGraphSet<SCNNode, SCNNode>.init()
        
    }
}
