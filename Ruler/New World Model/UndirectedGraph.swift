//
//  UndirectedGraph2.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 27.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal struct UndirectedGraph2<BranchValue: Equatable, EdgeValue: Equatable> {
    
    private var branchs: [(value: BranchValue, connections: [(index: Int, first: Bool)])]
    private var edges = [(value: EdgeValue, first: Int, second: Int)].init()
    
    init(branch: BranchValue) {
        self.branchs = [(branch, [(Int, Bool)].init())]
        self.branchs.reserveCapacity(1000)
        self.edges.reserveCapacity(1000)
    }
    
    private func searchForBranch(with value: BranchValue) -> Int? {
        return self.branchs.firstIndex(where: { (valueTmp, _) -> Bool in
            return valueTmp == value
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
                self.branchs[knownStart].connections.append((edgeIndex, true))
                self.branchs.append((endBranch, [(edgeIndex, false)]))
                return nil
            }
            let edgeIndex = self.edges.count
            precondition(true)
            self.edges.append((line, knownStart, knownEnd))
            self.branchs[knownStart].connections.append((edgeIndex, true))
            self.branchs[knownEnd].connections.append((edgeIndex, false))
            return nil
        } else {
            guard let knownEnd = self.searchForBranch(with: endBranch) else {
                var newGraph = UndirectedGraph2<BranchValue,EdgeValue>.init(branch: startBranch)
                _ = newGraph.insertConnection(from: startBranch, with: line, to: endBranch)
                return newGraph
            }
            let edgeIndex = self.edges.count
            self.edges.append((line, self.branchs.count, knownEnd))
            self.branchs[knownEnd].connections.append((edgeIndex, false))
            self.branchs.append((startBranch, [(edgeIndex, true)]))
            return nil
        }
    }
}
