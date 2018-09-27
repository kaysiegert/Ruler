//
//  WorldTests.swift
//  RulerTests
//
//  Created by Johannes Heinke Business on 26.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode: FastComparable {
    static func == (lhs: SCNNode, rhs: SCNNode) -> Bool {
        return lhs === rhs
    }
    
    static func << (lhs: SCNNode, rhs: SCNNode) -> Bool {
        return lhs.opacity < rhs.opacity
    }
}

let count = 1000
internal final class WorldTests: RulerTests {
  
    final func testBTree() {
        var b = BTree<Int, Int>.init()
        var i = 0
        self.measure {
            for _ in 0...count {
                i = i &+ 1
                b.insert((i,i))
            }
        }
    }
    
    final func testNewestWorld() {
        let n1 = SCNNode.init()
        var g = UndirectedGraph2<SCNNode, SCNNode>.init(branch: n1)
        self.measure {
            for _ in 0...count {
                let l1 = SCNNode.init()
                let n2 = SCNNode.init()
                _ = g.insertConnection(from: n1, with: l1, to: n2)
            }
        }
        print(g)
    }
    
    final func testNewestWorldReal() {
        let n1 = SCNNode.init()
        let g = UndirectedGraph4<SCNNode, SCNNode>.init(branch: n1)
        let r = g
        r.insertConnection(from: n1, with: SCNNode.init(), to: SCNNode.init())
        self.measure {
            for _ in 0...count {
                let l1 = SCNNode.init()
                let n2 = SCNNode.init()
                _ = g.insertConnection(from: n1, with: l1, to: n2)
            }
        }
        print(g)
    }
    
    final func testNewestWorldReally() {
        let n1 = SCNNode.init()
        let g = UndirectedGraph<SCNNode, SCNNode>.init(firstBranchValue: n1)
        self.measure {
            for _ in 0...count {
                let l1 = SCNNode.init()
                let n2 = SCNNode.init()
                _ = g.insertConnection(from: n1, with: l1, to: n2)
            }
        }
        print(g)
    }
}
