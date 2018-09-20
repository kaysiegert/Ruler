//
//  World.swift
//  Ruler2
//
//  Created by Johannes Heinke Business on 19.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

internal final class World: CustomStringConvertible {
    
    internal var description: String {
        return self.polygons.reduce("==> World-Start", { (tmp, polygon) -> String in
            return tmp + "\n#Polygon:\(polygon)"
        }) + "\n==> World-End"
    }
    
    fileprivate struct Polygon: CustomStringConvertible {
        
        fileprivate var description: String {
            return self.branches.reduce("", { (tmp, branch) -> String in
                return tmp + "\n\t \(branch.node.name ?? "Node") --> Connections: \(branch.connections.count)"
            })
        }
        
        fileprivate final class Branch {
            fileprivate final let node: SCNNode
            fileprivate final var connections: [(line: SCNNode, endPoint: Branch)]
            
            init(node: SCNNode, connections: [(line: SCNNode, endPoint: Branch)] = [(line: SCNNode, endPoint: Branch)].init()) {
                self.node = node
                self.connections = connections
                self.connections.reserveCapacity(1)
            }
        }
        
        private var branches = [Branch].init()
        
        init(branches: [Branch]) {
            self.branches = branches
        }
        
        fileprivate func search(for node: SCNNode) -> Branch? {
            return self.branches.first(where: { (branch) -> Bool in
                return branch.node === node
            })
        }
        
        //: !! Branches müssen korrekt sein
        fileprivate typealias Connection = (line: SCNNode, startBranch: Branch, endBranch: Branch)
        
        fileprivate mutating func union(with otherPolygon: Polygon, and connection: Connection) {
            connection.startBranch.connections.append((connection.line, connection.endBranch))
            connection.endBranch.connections.append((connection.line, connection.startBranch))
            self.branches += otherPolygon.branches
        }
        
        //: Es wird der endBranch angefügt
        fileprivate mutating func insert(_ connection: Connection) {
            connection.startBranch.connections.append((connection.line, connection.endBranch))
            connection.endBranch.connections.append((connection.line, connection.startBranch))
            self.branches.append(connection.endBranch)
        }
    }
    
    private final var polygons = [Polygon].init()
    
    internal final func insertConnection(from startNode: SCNNode, with line: SCNNode, to endNode: SCNNode) {
        let relevantPolygons = self.polygons.enumerated().compactMap { (index, polygon) -> (index: Int, startBranch: Polygon.Branch?, endBranch: Polygon.Branch?)? in
            if let _startBranch = polygon.search(for: startNode) {
                guard let _endBranch = polygon.search(for: endNode) else {
                    return (index, _startBranch, nil)
                }
                return (index, _startBranch, _endBranch)
            } else {
                guard let _endBranch = polygon.search(for: endNode) else {
                    return nil
                }
                return (index, nil, _endBranch)
            }
        }
        
        switch relevantPolygons.count {
        case 0:
            //: neues Polygon erstellen
            let startBranch = Polygon.Branch.init(node: startNode)
            let endBranch = Polygon.Branch.init(node: endNode, connections: [(line, startBranch)])
            startBranch.connections.append((line, endBranch))
            self.polygons.append(Polygon.init(branches: [startBranch, endBranch]))
            
        case 1:
            //: in bekanntes Polygon einfügen
            guard let concreteStartBranch = relevantPolygons[0].startBranch else {
                let concreteEndBranch = relevantPolygons[0].endBranch!
                let startBranch = Polygon.Branch.init(node: startNode)
                self.polygons[relevantPolygons[0].index].insert((line, concreteEndBranch, startBranch))
                return
            }
            let endBranch = Polygon.Branch.init(node: endNode)
            self.polygons[relevantPolygons[0].index].insert((line, concreteStartBranch, endBranch))
            
        case 2:
            //: zwei Polygone miteiander vereinigen
            if let concreteStartNode = relevantPolygons[0].startBranch {
                let concreteEndNode = relevantPolygons[1].endBranch!
                self.polygons.remove(at: relevantPolygons[0].index)
                self.polygons.remove(at: relevantPolygons[1].index)
                self.polygons[relevantPolygons[0].index].union(with: self.polygons[relevantPolygons[1].index], and: (line, concreteStartNode, concreteEndNode))
                
            } else {
                //: logische Konsequenz
                let concreteEndNode = relevantPolygons[0].endBranch!
                let concreteStartNode = relevantPolygons[1].startBranch!
                self.polygons.remove(at: relevantPolygons[1].index)
                self.polygons[relevantPolygons[0].index].union(with: self.polygons[relevantPolygons[1].index], and: (line, concreteStartNode, concreteEndNode))
            }
            
        default:
            //: darf nicht eintreten, da n < 0 unmöglich und n >= 3 nicht geht da eine Node nicht in mehren Polygonen existieren darf
            return
        }
    }
    
    //: für performance boost einfach eine klasse als mover machen und rausgeben
    //: je nachdem wird die alte oder neue line herausgegeben
    internal final func replaceConnection(from startNode: SCNNode, to endNode: SCNNode, with line: SCNNode) -> SCNNode {
        var _branch: Polygon.Branch? = nil
        for polygon in self.polygons {
            guard let branch = polygon.search(for: startNode) else {
                continue
            }
            _branch = branch
            break
        }
        
        guard let branch = _branch else {
            return line
        }
        
        guard let endNodeConnectionIndex = branch.connections.firstIndex(where: { (_, endBranch) -> Bool in
            return endBranch.node == endNode
        }), let endNodeNextConnectionIndex = branch.connections[endNodeConnectionIndex].endPoint.connections.firstIndex(where: { (arg) -> Bool in
            let (_, startBranch) = arg
            return startBranch.node == startNode
        }) else {
            return line
        }
        
        let result = branch.connections[endNodeConnectionIndex].line
        branch.connections[endNodeConnectionIndex].line = line
        branch.connections[endNodeConnectionIndex].endPoint.connections[endNodeNextConnectionIndex].line = line
        return result
    }
    
    internal struct NodeWorker: CustomStringConvertible {
        
        private let branch: Polygon.Branch
        
        internal var description: String {
            return "Worker: \(self.branch.node.name ?? "Node") --> Connections: \(self.branch.connections.count)"
        }
        
        fileprivate init(branch: Polygon.Branch) {
            self.branch = branch
        }
        
        internal func replaceLines(_ replacing: (_ startNode: SCNNode, _ line: SCNNode, _ endNode: SCNNode) -> SCNNode) {
            
            for idx in 0..<branch.connections.count {
                let newLine = replacing(self.branch.node, branch.connections[idx].line, branch.connections[idx].endPoint.node)
                let oldLine = branch.connections[idx].line
                branch.connections[idx].line = newLine
                guard let nextIndex = branch.connections[idx].endPoint.connections.firstIndex(where: { (line, _) -> Bool in
                    return oldLine == line
                }) else {
                    continue
                }
                branch.connections[idx].endPoint.connections[nextIndex].line = newLine
            }
        }
    }
    
    internal final func getNodeWorker(for node: SCNNode) -> NodeWorker? {
        var _branch: Polygon.Branch? = nil
        for polygon in self.polygons {
            guard let branch = polygon.search(for: node) else {
                continue
            }
            _branch = branch
            break
        }
        guard let concreteBranch = _branch else {
            return nil
        }
        return NodeWorker.init(branch: concreteBranch)
    }
}
