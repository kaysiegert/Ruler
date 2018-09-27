//
//  WorldTests.swift
//  RulerTests
//
//  Created by Johannes Heinke Business on 26.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit

let count = 1000
internal final class WorldTests: RulerTests {
    final func testNewWorld() {
        self.measure {
            let n1 = SCNNode.init()
            var g = UndirectedGraph<SCNNode, SCNNode>.init(for: n1)
            for _ in 0...count {
                let l1 = SCNNode.init()
                let n2 = SCNNode.init()
                _ = g.insertConnection(from: n2, with: l1, to: n1)
            }
        }
    }
    
    final func testOldWorld() {
        self.measure {
            let w = World.init()
            let n1 = SCNNode.init()
            for _ in 0...count {
                let l1 = SCNNode.init()
                let n2 = SCNNode.init()
                w.insertConnection(from: n1, with: l1, to: n2)
            }
        }
    }
    
    final func testNewestWorld() {
        self.measure {
            let n1 = SCNNode.init()
            var g = UndirectedGraph2<SCNNode, SCNNode>.init(branch: n1)
            for _ in 0...count {
                let l1 = SCNNode.init()
                let n2 = SCNNode.init()
                _ = g.insertConnection(from: n2, with: l1, to: n1)
            }
        }
    }
    
    final func testNewestWorld2() {
        self.measure {
            let n1 = SCNNode.init()
            var g = UndirectedGraph3<SCNNode, SCNNode>.init(firstBranch: n1)
            for _ in 0...count {
                let l1 = SCNNode.init()
                let n2 = SCNNode.init()
                _ = g.insertConnection(from: n2, with: l1, to: n1)
            }
        }
    }
}
