//
//  UndirectedGraph.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 28.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal protocol hasUniqueKey {
    var key: Int { get }
}

extension BTree {
    internal func search(for key: Key) -> Value? {
        return self.root.search(for: key)
    }
}

internal final class UndirectedGraph<BranchValue: hasUniqueKey, EdgeValue: hasUniqueKey> {
    
    private typealias Branch = (value: BranchValue, connections: [(index: Int, first: Bool)])
    private typealias Edge = (value: EdgeValue, first: Int, second: Int)
    
    private final var branchesTree = BTree<Int, (listIndex: Int, UnsafeMutablePointer<Branch>)>.init()
    private final var branchesList = Array<UnsafeMutablePointer<Branch>>.init()
    
    private final var edgesTree = BTree<Int, UnsafeMutablePointer<Edge>>.init()
    private final var edgesList = Array<UnsafeMutablePointer<Edge>>.init()
    
    internal static func singleton(from startBranch: BranchValue, with edgeValue: EdgeValue, to endBranch: BranchValue) -> UndirectedGraph<BranchValue, EdgeValue> {
        let newGraph = UndirectedGraph<BranchValue, EdgeValue>.init()
        
        let edge = (edgeValue, 0, 1)
        let edgePointer = UnsafeMutablePointer<Edge>.allocate(capacity: 1)
        edgePointer.initialize(to: edge)
        newGraph.edgesList.append(edgePointer)
        newGraph.edgesTree.insert((edgeValue.key, edgePointer))
        
        let concreteStartBranch = (value: startBranch, [(index: 0, first: true)])
        let startBranchPointer = UnsafeMutablePointer<Branch>.allocate(capacity: 1)
        startBranchPointer.initialize(to: concreteStartBranch)
        let concreteEndBranch = (value: endBranch, [(index: 0, first: false)])
        let endBranchPointer = UnsafeMutablePointer<Branch>.allocate(capacity: 1)
        endBranchPointer.initialize(to: concreteEndBranch)
        newGraph.branchesList.append(contentsOf: [startBranchPointer, endBranchPointer])
        newGraph.branchesTree.insert((startBranch.key, (0, startBranchPointer)))
        newGraph.branchesTree.insert((endBranch.key, (1, endBranchPointer)))
        
        return newGraph
    }
    
    
    internal final func insertConnection(from startBranch: BranchValue, with edgeValue: EdgeValue, to endBranch: BranchValue) -> Bool {
        if let knownStartIndex = self.branchesTree.search(for: startBranch.key) {
            
            return true
        } else {
            guard let knownEndIndex = self.branchesTree.search(for: endBranch.key) else {
                return false
            }
            
            return true
        }
    }
}
