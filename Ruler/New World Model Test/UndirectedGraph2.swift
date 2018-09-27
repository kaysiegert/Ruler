//
//  UndirectedGraph2.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 27.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit

internal final class UndirectedGraph3: CustomStringConvertible {
    
    private var branches: [Branch]
    
    internal var description: String {
        return "\(self.branches.first!.connections.count)"
    }
    
    init(firstBranch: SCNNode) {
        self.branches = [Branch.init(value: firstBranch)]
    }
    
    private final class Branch {
        fileprivate final let value: SCNNode
        fileprivate final var connections = [(UnsafeMutablePointer<SCNNode>, next: Branch)].init()
        
        init(value: SCNNode) {
            self.value = value
        }
    }
    
    private func searchForBranch(with value: SCNNode) -> Branch? {
        return self.branches.first { (branch) -> Bool in
            return branch.value === value
        }
    }
    
    internal func insertConnection(from startBranch: SCNNode, with edge: SCNNode, to endBranch: SCNNode) -> UndirectedGraph3? {
        if let knownStart = self.searchForBranch(with: startBranch) {
            guard let knwonEnd = self.searchForBranch(with: endBranch) else {
                
                return nil
            }
            
            return nil
        } else {
            guard let knownEnd = self.searchForBranch(with: endBranch) else {
                var newGraph = UndirectedGraph3.init(firstBranch: startBranch)
                _ = newGraph.insertConnection(from: startBranch, with: edge, to: endBranch)
                return newGraph
            }
            
            let newStartBranch = Branch.init(value: startBranch)
            let edgePoi = UnsafeMutablePointer<SCNNode>.allocate(capacity: 1)
            edgePoi.initialize(to: edge)
            newStartBranch.connections.append((edgePoi, knownEnd))
            knownEnd.connections.append((edgePoi, newStartBranch))
            self.branches.append(newStartBranch)
            return nil
        }
    }
}
