//
//  UndirectedGraph.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 27.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
/*
internal struct UndirectedGraph<BranchValue: Equatable & AnyObject , EdgeValue: Equatable & AnyObject> {
    
    private var branches: [(value: BranchValue, connections: [(Int, Bool)])]
    private var edges = [(value: EdgeValue, first: Int, second: Int)].init()
    
    init(firstBranchValue: BranchValue) {
        self.branches = [(firstBranchValue, [(Int, Bool)].init())]
    }
    
    //: Wird ersetzt wenn branches durch B-Tree ersetzt wird --> B-Tree hat eigene Search Funktion
    private func searchForBranch(with value: BranchValue) -> Int? {
        return self.branches.firstIndex(where: { (branch) -> Bool in
            return branch.value === value
        })
    }
    
    internal mutating func insertConnection(from startValue: BranchValue, with edgeValue: EdgeValue, to endValue: BranchValue) -> UndirectedGraph? {
        if let knownStart = self.searchForBranch(with: startValue) {
            guard let knownEnd = self.searchForBranch(with: endValue) else {
                let edgeIndex = self.edges.count
                self.edges.append((edgeValue, knownStart, self.branches.count))
                self.branches.append((endValue, [(edgeIndex, false)]))
                self.branches[knownStart].connections.append((edgeIndex, true))
                return nil
            }
            let edgeIndex = self.edges.count
            self.branches[knownStart].connections.append((edgeIndex, true))
            self.branches[knownEnd].connections.append((edgeIndex, false))
            self.edges.append((edgeValue, knownStart, knownEnd))
            return nil
        } else {
            guard let knownEnd = self.searchForBranch(with: endValue) else {
                var newGraph = UndirectedGraph.init(firstBranchValue: startValue)
                _ = newGraph.insertConnection(from: startValue, with: edgeValue, to: endValue)
                return newGraph
            }
            /*
            var startBranch = Branch.init(value: startValue)
            let edgeIndex = self.edges.count
            startBranch.connections.append((edgeIndex, true))
            let edge = Edge.init(first: self.branches.count, value: edgeValue, second: knownEnd)
            self.branches.append(startBranch)
            self.edges.append(edge)
            self.branches[knownEnd].connections.append((edgeIndex, false))*/
            return nil
        }
    }
    
    internal mutating func insertConnection2(from startBranch: BranchValue, with line: EdgeValue, to endBranch: BranchValue) -> UndirectedGraph2<BranchValue, EdgeValue>? {
        if let knownStart = self.searchForBranch(with: startBranch) {
            guard let knownEnd = self.searchForBranch(with: endBranch) else {
                let endBranchIndex = self.edges.count
                let edgeIndex = self.edges.count
                precondition(true)
                self.edges.append((line, knownStart, endBranchIndex))
                self.branches[knownStart].connections.append((edgeIndex, true))
                precondition(true)
                self.branches.append((endBranch, [(edgeIndex, false)]))
                return nil
            }
            let edgeIndex = self.edges.count
            precondition(true)
            self.edges.append((line, knownStart, knownEnd))
            self.branches[knownStart].connections.append((edgeIndex, true))
            self.branches[knownEnd].connections.append((edgeIndex, false))
            return nil
        } else {
            guard let knownEnd = self.searchForBranch(with: endBranch) else {
                var newGraph = UndirectedGraph2<BranchValue,EdgeValue>.init(branch: startBranch)
                _ = newGraph.insertConnection(from: startBranch, with: line, to: endBranch)
                return newGraph
            }
            let edgeIndex = self.edges.count
            self.edges.append((line, self.branches.count, knownEnd))
            self.branches[knownEnd].connections.append((edgeIndex, false))
            self.branches.append((startBranch, [(edgeIndex, true)]))
            return nil
        }
    }
    
    internal struct BranchWorker {
        private let branchIndex: Int
    }
    
    private struct Branch {

        private let value: BranchValue
        private var connections = Array<(Int, first: Bool)>.init()
        
        /*
        fileprivate static func << (lhs: Branch, rhs: Branch) -> Bool {
            return lhs.value << rhs.value
        }
        
        fileprivate static func == (lhs: Branch, rhs: Branch) -> Bool {
            return lhs.value === rhs.value
        }*/
        
        init(value: BranchValue) {
            self.value = value
        }
    }
    
    private struct Edge {
        
        fileprivate let first: Int
        fileprivate let value: EdgeValue
        fileprivate let second: Int
        
        /*
        fileprivate static func << (lhs: Edge, rhs: Edge) -> Bool {
            return lhs.value << rhs.value
        }
        
        fileprivate static func == (lhs: Edge, rhs: Edge) -> Bool {
            return lhs.value === rhs.value
        }*/
        
        init(first: Int, value: EdgeValue, second: Int) {
            self.first = first
            self.value = value
            self.second = second
        }
    }
}
*/
internal final class UndirectedGraph4<BranchValue: Equatable & AnyObject, EdgeValue: Equatable>: CustomStringConvertible {
    
    private final var branches: [(value: BranchValue, connections: [(index: Int, first: Bool)])]
    private final var edges = [(value: EdgeValue, first: Int, second: Int)].init()
    
    internal var description: String {
        return "\(self.branches[0].connections.count)"
    }
    
    init(branch: BranchValue) {
        self.branches = [(branch, [(Int, Bool)].init())]
    }
    
    private final func searchForBranch(with value: BranchValue) -> Int? {
        return self.branches.firstIndex(where: { (arg) -> Bool in
            let (valueTmp, _) = arg
            return valueTmp === value
        })
    }
    
    private func searchForEdge(with check: (_ value: EdgeValue, _ first: Int, _ second: Int) -> Bool) -> Int? {
        return self.edges.firstIndex(where: { (edge) -> Bool in
            return check(edge.value, edge.first, edge.second)
        })
    }
    
    //: Mittels FastInsert ist hier noch Luft nach oben
    internal final func insertConnection(from startBranch: BranchValue, with line: EdgeValue, to endBranch: BranchValue) -> UndirectedGraph2<BranchValue, EdgeValue>? {
        if let knownStart = self.searchForBranch(with: startBranch) {
            guard let knownEnd = self.searchForBranch(with: endBranch) else {
                let endBranchIndex = self.edges.count
                let edgeIndex = self.edges.count
                precondition(true)
                self.edges.append((line, knownStart, endBranchIndex))
                self.branches[knownStart].connections.append((edgeIndex, true))
                precondition(true)
                self.branches.append((endBranch, [(edgeIndex, false)]))
                return nil
            }
            let edgeIndex = self.edges.count
            precondition(true)
            self.edges.append((line, knownStart, knownEnd))
            self.branches[knownStart].connections.append((edgeIndex, true))
            self.branches[knownEnd].connections.append((edgeIndex, false))
            return nil
        } else {
            guard let knownEnd = self.searchForBranch(with: endBranch) else {
                var newGraph = UndirectedGraph2<BranchValue,EdgeValue>.init(branch: startBranch)
                _ = newGraph.insertConnection(from: startBranch, with: line, to: endBranch)
                return newGraph
            }
            let edgeIndex = self.edges.count
            self.edges.append((line, self.branches.count, knownEnd))
            self.branches[knownEnd].connections.append((edgeIndex, false))
            self.branches.append((startBranch, [(edgeIndex, true)]))
            return nil
        }
    }
}

/*
internal final class UndirectedGraph<BranchValue: FastComparable, EdgeValue: FastComparable>: CustomStringConvertible {
    
    private final var branches: ContiguousArray<(value: BranchValue, connections: ContiguousArray<(index: Int, first: Bool)>)>
    private final var edges = ContiguousArray<(first: Int, value: EdgeValue, second: Int)>.init()
    
    internal var description: String {
        return "\(self.branches.count)"
    }
    
    init(firstBranchValue: BranchValue) {
        self.branches = [(firstBranchValue, connections: ContiguousArray<(index: Int, first: Bool)>.init())]
    }
    
    private final func searchForBranch(with value: BranchValue) -> Int? {
        return self.branches.firstIndex(where: { (branchValue, _) -> Bool in
            return branchValue == value
        })
    }
    
    internal final func insertConnection(from startValue: BranchValue, with edgeValue: EdgeValue, to endValue: BranchValue) -> UndirectedGraph? {
        if let knownStart = self.searchForBranch(with: startValue) {
            guard let knownEnd = self.searchForBranch(with: endValue) else {
                let edgeIndex = self.edges.count
                self.edges.append((knownStart, edgeValue, self.branches.count))
                self.branches.append((endValue, [(edgeIndex, false)]))
                self.branches[knownStart].connections.append((edgeIndex, true))
                return nil
            }
            
            let edgeIndex = self.edges.count
            self.edges.append((knownStart, edgeValue, knownEnd))
            self.branches[knownEnd].connections.append((edgeIndex, false))
            self.branches[knownStart].connections.append((edgeIndex, true))
            return nil
        } else {
            guard let knownEnd = self.searchForBranch(with: endValue) else {
                let newGraph = UndirectedGraph.init(firstBranchValue: startValue)
                _ = newGraph.insertConnection(from: startValue, with: edgeValue, to: endValue)
                return newGraph
            }
            
            let edgeIndex = self.edges.count
            self.edges.append((self.branches.count, edgeValue, knownEnd))
            self.branches.append((startValue, [(edgeIndex, true)]))
            self.branches[knownEnd].connections.append((edgeIndex, false))
            return nil
        }
    }
}
*/
