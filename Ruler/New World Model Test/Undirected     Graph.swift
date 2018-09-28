//
//  UndirectedGraph.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 28.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation


internal protocol hasKey {
    var key: Int { get }
}


internal final class UndirectedGraph7<BranchValue: hasKey, EdgeValue: hasKey>: CustomStringConvertible {
    
    private final var branches = BTree<Int, Branch>.init()
    private final var edges = BTree<Int, Edge>.init()
    
    internal var description: String {
        return "\nUndirectedGraph Start ==>" + self.branches.reduce("", { (tmp, arg) -> String in
            let (_, branch) = arg
            return tmp + "\n\t\(branch)"
        }) + "\nUndirectedGraph End ==>\n"
    }
    
    private struct Edge {
        private let first: BTree<Int, Branch>.Index
        private let value: EdgeValue
        private let second: BTree<Int, Branch>.Index
        
        fileprivate init(first: BTree<Int, Branch>.Index, value: EdgeValue, second: BTree<Int, Branch>.Index) {
            self.first = first
            self.value = value
            self.second = second
        }
    }
    
    private struct Branch: CustomStringConvertible {
        private let value: BranchValue
        private var _connections: [(index: BTree<Int, Edge>.Index, first: Bool)]
        
        fileprivate var description: String {
            return "--> Branch: \(self.connections.count) Connections"
        }
        
        fileprivate init(value: BranchValue, connections: [(index: BTree<Int, Edge>.Index, first: Bool)]) {
            self.value = value
            self._connections = connections
        }
        
        fileprivate var connections: [(index: BTree<Int, Edge>.Index, first: Bool)] {
            return self._connections
        }
    }
    
    internal final func insertConnection(from startBranch: BranchValue, with edgeValue: EdgeValue, to endBranch: BranchValue) -> UndirectedGraph7<BranchValue, EdgeValue>? {
        if let knownStart = self.branches.index(forKey: startBranch.key) {
            
            return nil
        } else {
            guard let knownEnd = self.branches.index(forKey: endBranch.key) else {
                //: Singleton
                let newGraph = UndirectedGraph7<BranchValue, EdgeValue>.init()
                let edgeIndex = newGraph.edges.index(forInserting: edgeValue.key)
                let concreteStartBranch = Branch.init(value: startBranch, connections: [(edgeIndex, true)])
                let concreteEndBranch = Branch.init(value: endBranch, connections: [(edgeIndex, false)])
                let startBranchIndex = newGraph.branches.index(forInserting: startBranch.key)
                newGraph.branches.insert((startBranch.key, concreteStartBranch))
                let endBranchIndex = newGraph.branches.index(forInserting: endBranch.key)
                newGraph.branches.insert((endBranch.key, concreteEndBranch))
                let edge = Edge.init(first: startBranchIndex, value: edgeValue, second: endBranchIndex)
                newGraph.edges.insert((edgeValue.key, edge))
                return newGraph
            }
            
            
            let edgeIndex = self.edges.index(forInserting: edgeValue.key)
            let newBranch = Branch.init(value: endBranch, connections: self.branches[knownEnd].1.connections + [(edgeIndex, false)])
            let startBranchIndex = self.branches.index(forInserting: startBranch.key)
            let concreteStartBranch = Branch.init(value: startBranch, connections: [(edgeIndex, true)])
            let edge = Edge.init(first: startBranchIndex, value: edgeValue, second: knownEnd)
            self.edges.insert((edgeValue.key, edge))
            self.branches.insert((startBranch.key, concreteStartBranch))
            _ = self.branches.insertOrReplace((endBranch.key, newBranch))
            return nil
        }
    }
}
