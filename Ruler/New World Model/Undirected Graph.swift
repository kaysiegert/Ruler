//
//  Undirected Graph.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 26.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal struct UndirectedGraph<BranchValue: Equatable, EdgeValue: Equatable> {
    
    private var branches: [UnsafeMutablePointer<Branch>]
    private var edges = [(first: UnsafeMutablePointer<Edge>, second: UnsafeMutablePointer<Edge>)].init()
    
    private struct Branch {
        
        fileprivate let value: BranchValue
        //: durch BTree oder Pointer ersetzen
        fileprivate var connections = [UnsafeMutablePointer<Edge>].init()
        
        init(with value: BranchValue) {
            self.value = value
        }
        
        fileprivate static func ==(lhs: Branch, rhs: BranchValue) -> Bool {
            return lhs.value == rhs
        }
    }
    
    private struct Edge {
        
        fileprivate let preBranch: UnsafeMutablePointer<Branch>
        fileprivate let value: UnsafeMutablePointer<EdgeValue>
        fileprivate let nextBranch: UnsafeMutablePointer<Branch>
    }
    
    init(for firstValue: BranchValue) {
        let initPoi = UnsafeMutablePointer<Branch>.allocate(capacity: 1)
        initPoi.initialize(to: Branch.init(with: firstValue))
        self.branches = [initPoi]
    }
    
    private func searchForBranch(containing value: BranchValue) -> UnsafeMutablePointer<Branch>? {
        return self.branches.first(where: { (branch) -> Bool in
            return branch.pointee == value
        })
    }
    
    private func searchForEdge(containing value: EdgeValue) -> UnsafeMutablePointer<Edge>? {
        return self.edges.first(where: { (edge) -> Bool in
            return edge.first.pointee.value.pointee == value
        })?.first
    }
    
    //: falls beide Knoten noch nicht im Graph vorkommen wird ein neuer Graph erzeugt und ausgegeben
    internal mutating func insertConnection(from startBranch: BranchValue, with edge: EdgeValue, to endBranch: BranchValue) -> UndirectedGraph<BranchValue, EdgeValue>? {
        if let knownStart = self.searchForBranch(containing: startBranch) {
            //: startBranch kommt bereits im Graph vor
            guard let knownEnd = self.searchForBranch(containing: endBranch) else {
                //: an startGraph anknüpfen
                
                return nil
            }
            //: Connection zwischen den beiden Punkten einfügen
            
            return nil
        } else {
            //: startBranch kommt noch nicht im Graph vor
            guard let knownEnd = self.searchForBranch(containing: endBranch) else {
                //: beide Knoten kommen noch nicht vor --> neuen Graph erzeugen und ausgeben
                var newGraph = UndirectedGraph.init(for: startBranch)
                _ = newGraph.insertConnection(from: startBranch, with: edge, to: endBranch)
                return newGraph
            }
            //: endBranch kommt im Graph bereits vor
            let startPoi = UnsafeMutablePointer<Branch>.allocate(capacity: 1)
            startPoi.initialize(to: Branch.init(with: startBranch))
            self.branches.append(startPoi)
            
            let edgeValuePoi = UnsafeMutablePointer<EdgeValue>.allocate(capacity: 1)
            edgeValuePoi.initialize(to: edge)
            
            let edgeStartToEndPoi = UnsafeMutablePointer<Edge>.allocate(capacity: 1)
            edgeStartToEndPoi.initialize(to: Edge.init(preBranch: startPoi, value: edgeValuePoi, nextBranch: knownEnd))
            let edgeEndToStartPoi = UnsafeMutablePointer<Edge>.allocate(capacity: 1)
            edgeEndToStartPoi.initialize(to: Edge.init(preBranch: knownEnd, value: edgeValuePoi, nextBranch: startPoi))
            self.edges.append((edgeStartToEndPoi, edgeEndToStartPoi))
            
            return nil
        }
    }
}
