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
            return "\(self.branches.count)"
            /*
            return self.branches.reduce("", { (tmp, branch) -> String in
                let connectionIndices = String(branch.connections.reduce("[", { (tmp, arg) -> String in
                    let (_, index, _) = arg
                    return tmp + "\(index), "
                }).dropLast(2)) + "]"
                return tmp + "\n\t \(branch.node.name ?? "Node") --> Connections: \(branch.connections.count) \(connectionIndices)"
            })*/
        }
        
        fileprivate final class Branch {
            fileprivate final let node: SCNNode
            fileprivate final var connections: [(line: SCNNode, connectionIndex: Int, endPoint: Branch)]
            
            init(node: SCNNode, connections: [(line: SCNNode, connectionIndex: Int, endPoint: Branch)] = [(line: SCNNode, connectionIndex: Int, endPoint: Branch)].init()) {
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
            let connectionEndIndex = connection.endBranch.connections.count
            let connectionStartIndex = connection.startBranch.connections.count
            connection.startBranch.connections.append((connection.line, connectionStartIndex, connection.endBranch))
            connection.endBranch.connections.append((connection.line, connectionEndIndex, connection.startBranch))
            self.branches += otherPolygon.branches
        }
        
        //: Es wird der endBranch der connection angefügt
        fileprivate mutating func insert(_ connection: Connection) {
            let connectionEndIndex = connection.endBranch.connections.count
            let connectionStartIndex = connection.startBranch.connections.count
            connection.startBranch.connections.append((connection.line, connectionEndIndex, connection.endBranch))
            connection.endBranch.connections.append((connection.line, connectionStartIndex, connection.startBranch))
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
            let endBranch = Polygon.Branch.init(node: endNode, connections: [(line, 0, startBranch)])
            startBranch.connections.append((line, 0, endBranch))
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
                self.polygons[relevantPolygons[0].index].union(with: self.polygons[relevantPolygons[1].index], and: (line, concreteStartNode, concreteEndNode))
                self.polygons.remove(at: relevantPolygons[1].index)
                
            } else {
                //: logische Konsequenz
                let concreteEndNode = relevantPolygons[0].endBranch!
                let concreteStartNode = relevantPolygons[1].startBranch!
                self.polygons[relevantPolygons[0].index].union(with: self.polygons[relevantPolygons[1].index], and: (line, concreteStartNode, concreteEndNode))
                self.polygons.remove(at: relevantPolygons[1].index)
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
        
        guard let endNodeConnectionIndex = branch.connections.firstIndex(where: { (_, _, endBranch) -> Bool in
            return endBranch.node == endNode
        }), let endNodeNextConnectionIndex = branch.connections[endNodeConnectionIndex].endPoint.connections.firstIndex(where: { (arg) -> Bool in
            let (_, _, startBranch) = arg
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
        
        internal var node: SCNNode {
            return self.branch.node
        }
        
        internal func replaceLines(_ replacing: (_ startNode: SCNNode, _ line: SCNNode, _ endNode: SCNNode) -> SCNNode) {
            
            for idx in 0..<branch.connections.count {
                let newLine = replacing(self.branch.node, branch.connections[idx].line, branch.connections[idx].endPoint.node)
                let oldLine = branch.connections[idx].line
                branch.connections[idx].line = newLine
                guard let nextIndex = branch.connections[idx].endPoint.connections.firstIndex(where: { (line, _, _) -> Bool in
                    return oldLine == line
                }) else {
                    continue
                }
                branch.connections[idx].endPoint.connections[branch.connections[idx].connectionIndex].line = newLine
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


func testWorld() {
    let w = World.init()
    let n1 = SCNNode.init()
    let l1 = SCNNode.init()
    let n2 = SCNNode.init()
    let l2 = SCNNode.init()
    let n3 = SCNNode.init()
    
    w.insertConnection(from: n1, with: l1, to: n2)
    w.insertConnection(from: n2, with: l2, to: n3)
    print(w)
    
    let n4 = SCNNode.init()
    let l3 = SCNNode.init()
    l3.name = "first test connection"
    let n5 = SCNNode.init()
    w.insertConnection(from: n4, with: l3, to: n5)
    print(w)
    
    let l4 = SCNNode.init()
    l4.name = "second test connection"
    w.insertConnection(from: n4, with: l4, to: n1)
    print(w)
    
    let r = w.getNodeWorker(for: n4)!
    r.replaceLines { (_, line, _) -> SCNNode in
        print("Replacing \(line.name ?? "connection")")
        return line
    }
    
}
