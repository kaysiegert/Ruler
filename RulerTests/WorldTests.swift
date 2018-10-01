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
        print(world)
        let n1 = SCNNode.init()
        let n2 = SCNNode.init()
        let l1 = SCNNode.init()
        world.insertConnection(from: n1, with: l1, to: n2)
        print(world)
        let n3 = SCNNode.init()
        let l2 = SCNNode.init()
        world.insertConnection(from: n3, with: l2, to: n3)
        print(world)
        world.insertConnection(from: n1, with: SCNNode.init(), to: n3)
        print(world)
    }
}
