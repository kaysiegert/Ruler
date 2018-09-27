//
//  UndirectedGraph2.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 27.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal struct UndirectedGraph2<BranchValue: Equatable & AnyObject, EdgeValue: Equatable>: CustomStringConvertible {
    
    private var branches: [(value: BranchValue, connections: [(index: Int, first: Bool)])]
    private var edges = [(value: EdgeValue, first: Int, second: Int)].init()
    
    internal var description: String {
        return "\(self.branches[0].connections.count)"
    }
    
    init(branch: BranchValue) {
        self.branches = [(branch, [(Int, Bool)].init())]
    }
    
    private func searchForBranch(with value: BranchValue) -> Int? {
        return self.branches.firstIndex(where: { (arg) -> Bool in
            let (valueTmp, _) = arg
            return valueTmp === value
        })
    }
    
    private mutating func searchForEdge(with check: (_ value: EdgeValue, _ first: Int, _ second: Int) -> Bool) -> Int? {
        return self.edges.firstIndex(where: { (edge) -> Bool in
            return check(edge.value, edge.first, edge.second)
        })
    }
    
    //: Mittels FastInsert ist hier noch Luft nach oben
    internal mutating func insertConnection(from startBranch: BranchValue, with line: EdgeValue, to endBranch: BranchValue) -> UndirectedGraph2<BranchValue, EdgeValue>? {
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
