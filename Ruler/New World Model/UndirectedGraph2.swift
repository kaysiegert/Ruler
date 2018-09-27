//
//  UndirectedGraph2.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 27.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal struct UndirectedGraph3<BranchValue: Equatable, EdgeValue> {
    
    private var branches: [Branch]
    
    init(firstBranch: BranchValue) {
        self.branches = [Branch.init(value: firstBranch)]
    }
    
    private final class Branch {
        fileprivate final let value: BranchValue
        fileprivate final var connections = [(UnsafeMutablePointer<EdgeValue>, next: Branch)].init()
        
        init(value: BranchValue) {
            self.value = value
        }
    }
    
    private nonmutating func searchForBranch(with value: BranchValue) -> Branch? {
        return self.branches.first { (branch) -> Bool in
            return branch.value == value
        }
    }
    
    internal mutating func insertConnection(from startBranch: BranchValue, with edge: EdgeValue, to endBranch: BranchValue) -> UndirectedGraph3<BranchValue, EdgeValue>? {
        if let knownStart = self.searchForBranch(with: startBranch) {
            guard let knwonEnd = self.searchForBranch(with: endBranch) else {
                
                return nil
            }
            
            return nil
        } else {
            guard let knownEnd = self.searchForBranch(with: endBranch) else {
                var newGraph = UndirectedGraph3<BranchValue, EdgeValue>.init(firstBranch: startBranch)
                _ = newGraph.insertConnection(from: startBranch, with: edge, to: endBranch)
                return newGraph
            }
            
            let newStartBranch = Branch.init(value: startBranch)
            let newEdge = Edge.init(first: newStartBranch, edge: edge, second: knownEnd)
            newStartBranch.connections.append((newEdge, true))
            knownEnd.connections.append((newEdge, false))
            self.branches.append(newStartBranch)
            //self.edges.append(newEdge)
            return nil
        }
    }
}
