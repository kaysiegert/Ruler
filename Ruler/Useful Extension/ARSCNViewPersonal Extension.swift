//
//  SCNScene Extension.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 18.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

internal extension ARSCNView {
    
    internal final func getNode(for point: CGPoint) -> SCNNode? {
        let hitResult = self.hitTest(point, options: nil)
        guard let concreteHitResult = hitResult.first else {
            return nil
        }
        return concreteHitResult.node
    }
    
    internal final func addMeasurepoint(at position: SCNVector3, color: UIColor, type: SCNPhysicsBodyType) -> SCNNode {
        let sphereGeo = SCNSphere.init(radius: 0.01)
        sphereGeo.firstMaterial?.diffuse.contents = color
        let sphere = SCNNode.init(geometry: sphereGeo)
        sphere.name = "MeasurePoint"
        sphere.position = position
        
        let sphereShape = SCNPhysicsShape.init(geometry: sphereGeo, options: nil)
        let sphereBody = SCNPhysicsBody.init(type: type, shape: sphereShape)
        sphere.physicsBody = sphereBody
        sphere.physicsBody?.isAffectedByGravity = false
        
        self.scene.rootNode.addChildNode(sphere)
        return sphere
    }
    
    internal final func addLine(startPoint: SCNNode, endPoint: SCNNode, from startPosition: SCNVector3, to endPosition: SCNVector3, with color: UIColor) -> SCNNode {
        let distance = startPosition.distanceFromPos(pos: endPosition)
        let lineGeo = SCNCylinder.init(radius: 0.002, height: CGFloat(distance))
        lineGeo.firstMaterial?.diffuse.contents = color
        let line = SCNNode.init(geometry: lineGeo)
        
        //original vector of cylinder above 0,0,0
        let ov = SCNVector3(0, distance/2.0,0)
        //target vector, in new coordination
        let nv = SCNVector3((endPosition.x - startPosition.x)/2.0, (endPosition.y - startPosition.y)/2.0,
                            (endPosition.z-startPosition.z)/2.0)
        
        // axis between two vector
        let av = SCNVector3( (ov.x + nv.x)/2.0, (ov.y+nv.y)/2.0, (ov.z+nv.z)/2.0)
        
        //normalized axis vector
        let av_normalized = av.normalized()
        let q0 = Float(0.0) //cos(angel/2), angle is always 180 or M_PI
        let q1 = Float(av_normalized.x) // x' * sin(angle/2)
        let q2 = Float(av_normalized.y) // y' * sin(angle/2)
        let q3 = Float(av_normalized.z) // z' * sin(angle/2)
        
        let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
        let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
        let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
        let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
        let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
        let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
        let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
        let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
        let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
        
        line.transform.m11 = r_m11
        line.transform.m12 = r_m12
        line.transform.m13 = r_m13
        line.transform.m14 = 0.0
        
        line.transform.m21 = r_m21
        line.transform.m22 = r_m22
        line.transform.m23 = r_m23
        line.transform.m24 = 0.0
        
        line.transform.m31 = r_m31
        line.transform.m32 = r_m32
        line.transform.m33 = r_m33
        line.transform.m34 = 0.0
        
        line.transform.m41 = (startPosition.x + endPosition.x) / 2.0
        line.transform.m42 = (startPosition.y + endPosition.y) / 2.0
        line.transform.m43 = (startPosition.z + endPosition.z) / 2.0
        line.transform.m44 = 1.0
        
        self.scene.rootNode.addChildNode(line)
        
        /*
        //: Adding Linenodes to the world
        if let concreteStartPoint = world.firstIndex(where: { (node, _) -> Bool in
            return node == startPoint
        }) {
            //: Node kommt vor --> line hinzufügen
            var newConnections = world[concreteStartPoint].1
            newConnections.append(Branch.init(start: endPoint, line: line))
            world[concreteStartPoint] = (world[concreteStartPoint].0, newConnections)
        } else {
            //: Node kommt noch nicht vor
            world.append((startPoint, [Branch.init(start: endPoint, line: line)]))
        }
        
        //: Adding Linenodes to the world
        if let concreteEndPoint = world.firstIndex(where: { (node, _) -> Bool in
            return node == endPoint
        }) {
            //: Node kommt vor --> line hinzufügen
            var newConnections = world[concreteEndPoint].1
            newConnections.append(Branch.init(start: startPoint, line: line))
            world[concreteEndPoint] = (world[concreteEndPoint].0, newConnections)
        } else {
            //: Node kommt noch nicht vor
            world.append((endPoint, [Branch.init(start: startPoint, line: line)]))
        }*/
        
        return line
    }
}

internal func createLine(startPoint: SCNNode, endPoint: SCNNode, from startPosition: SCNVector3, to endPosition: SCNVector3, with color: UIColor) -> SCNNode {
    let distance = startPosition.distanceFromPos(pos: endPosition)
    let lineGeo = SCNCylinder.init(radius: 0.002, height: CGFloat(distance))
    lineGeo.firstMaterial?.diffuse.contents = color
    let line = SCNNode.init(geometry: lineGeo)
    
    //original vector of cylinder above 0,0,0
    let ov = SCNVector3(0, distance/2.0,0)
    //target vector, in new coordination
    let nv = SCNVector3((endPosition.x - startPosition.x)/2.0, (endPosition.y - startPosition.y)/2.0,
                        (endPosition.z-startPosition.z)/2.0)
    
    // axis between two vector
    let av = SCNVector3( (ov.x + nv.x)/2.0, (ov.y+nv.y)/2.0, (ov.z+nv.z)/2.0)
    
    //normalized axis vector
    let av_normalized = av.normalized()
    let q0 = Float(0.0) //cos(angel/2), angle is always 180 or M_PI
    let q1 = Float(av_normalized.x) // x' * sin(angle/2)
    let q2 = Float(av_normalized.y) // y' * sin(angle/2)
    let q3 = Float(av_normalized.z) // z' * sin(angle/2)
    
    let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
    let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
    let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
    let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
    let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
    let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
    let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
    let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
    let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
    
    line.transform.m11 = r_m11
    line.transform.m12 = r_m12
    line.transform.m13 = r_m13
    line.transform.m14 = 0.0
    
    line.transform.m21 = r_m21
    line.transform.m22 = r_m22
    line.transform.m23 = r_m23
    line.transform.m24 = 0.0
    
    line.transform.m31 = r_m31
    line.transform.m32 = r_m32
    line.transform.m33 = r_m33
    line.transform.m34 = 0.0
    
    line.transform.m41 = (startPosition.x + endPosition.x) / 2.0
    line.transform.m42 = (startPosition.y + endPosition.y) / 2.0
    line.transform.m43 = (startPosition.z + endPosition.z) / 2.0
    line.transform.m44 = 1.0
    
    /*
     //: Adding Linenodes to the world
     if let concreteStartPoint = world.firstIndex(where: { (node, _) -> Bool in
     return node == startPoint
     }) {
     //: Node kommt vor --> line hinzufügen
     var newConnections = world[concreteStartPoint].1
     newConnections.append(Branch.init(start: endPoint, line: line))
     world[concreteStartPoint] = (world[concreteStartPoint].0, newConnections)
     } else {
     //: Node kommt noch nicht vor
     world.append((startPoint, [Branch.init(start: endPoint, line: line)]))
     }
     
     //: Adding Linenodes to the world
     if let concreteEndPoint = world.firstIndex(where: { (node, _) -> Bool in
     return node == endPoint
     }) {
     //: Node kommt vor --> line hinzufügen
     var newConnections = world[concreteEndPoint].1
     newConnections.append(Branch.init(start: startPoint, line: line))
     world[concreteEndPoint] = (world[concreteEndPoint].0, newConnections)
     } else {
     //: Node kommt noch nicht vor
     world.append((endPoint, [Branch.init(start: startPoint, line: line)]))
     }*/
    
    return line
}
