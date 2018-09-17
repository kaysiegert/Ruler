//
//  World.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 17.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit

internal final class World {
    
    private var nodes = Array<(node: SCNNode, connections: [SCNNode])>.init()
    
    internal final func registryNode(_ node: SCNNode, relativTo nodes: SCNNode ...) {
        self.nodes.append((node, nodes))
    }
    
    internal final func getNearestNode(to vector: SCNVector3) -> SCNNode? {
        guard let firstNode = self.nodes.first else {
            return nil
        }
        guard self.nodes.count > 1 else {
            return firstNode.node
        }
        return Array(self.nodes.dropFirst()).reduce(firstNode.node) { (tmp, element) -> SCNNode in
            guard tmp.position.distanceFromPos(pos: vector) > element.node.position.distanceFromPos(pos: vector) else {
                return tmp
            }
            return element.node
        }
    }
}

internal struct Polygon {
    internal let nodes: [SCNNode]
    internal let type: Polygon.Formtype
    
    internal enum Formtype {
        case line
        case triangle
        case quad
    }
}
