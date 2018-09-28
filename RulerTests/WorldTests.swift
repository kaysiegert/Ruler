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

extension SCNNode: hasKey {
    var key: Int {
        return self.hash
    }
}

let count = 1000
internal final class WorldTests: RulerTests {
  
    
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

    
    final func testBTree() {
        var b = BTree<Int, SCNNode>.init()
        let n1 = SCNNode.init()
        n1.name = "Test"
        b.insert((n1.hash, n1))
        let i = b.index(forKey: n1.hash)!
        var nodes = [SCNNode].init()
        for _ in 0...9 {
            for _ in 0...count {
                let n = SCNNode.init()
                b.insert((n.hash, n))
                nodes.append(n)
                let m = SCNNode.init()
                b.insert((m.hash, m))
                var j = b.offset(forKey: n.hash)!
                j = j &+ 1
            }
        }
        self.measure {
            nodes.forEach({ (node) in
                let j = b.offset(forKey: node.hash)!
                let g = b.element(atOffset: j)
            })
        }
        let j = b.offset(forKey: n1.hash)!
        print(b.element(atOffset: j).1.name)
    }
    
    final func testArray() {
        var nodes = [SCNNode].init()
        for _ in 0...9 {
            for _ in 0...count {
                nodes.append(SCNNode.init())
            }
        }
        
        self.measure {
            nodes.forEach({ (node) in
                let j = nodes.firstIndex(of: node)!
                let g = nodes[j]
            })
        }
    }
    
    final func testBTree2() {
        var b = BTree<Int, Int>.init()
        b.insert((5,90))
        print(b.offset(forKey: 5)!)
        for i in 6...20 {
            b.insert((i,i))
        }
        //b.insert((5,90))
        let idx = b.offset(forKey: 5)!
        print(b.offset(forKey: 5)!)
        print(b.element(atOffset: idx).1)
        for i in 2...4 {
            b.insert((i,i))
        }
        print(b.element(atOffset: idx).0)
        assert(90 == b.element(atOffset: idx).1)
    }
}
