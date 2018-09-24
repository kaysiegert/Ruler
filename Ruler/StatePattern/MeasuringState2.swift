//
//  MeasuringState2.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 17.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import ARKit

internal final class MeasuringState2: State {
    
    private final var timer = Timer.init()
    private final var startNode: SCNNode? = nil
    private final var endNode: SCNNode? = nil
    
    private final func getCurrentPosition() -> SCNVector3? {
        var result: SCNVector3? = nil
        _ = self.execute({ (_, sceneView, _) in
            guard let currentFrame = sceneView.session.currentFrame else {
                return
            }
            /*
            var translation = matrix_identity_float4x4
            // 20cm in front of the camera
            translation.columns.3.z = -0.0
            let transform = simd_mul(currentFrame.camera.transform, translation)
            result = SCNVector3.init(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            */
            let vpWithZ = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
            let worldPoint = sceneView.unprojectPoint(vpWithZ)
            
            result = SCNVector3.init(x: worldPoint.x, y: worldPoint.y, z: worldPoint.z)
            
            
        })
        return result
    }
    
    private final func printDistance(with value: Float) {
        _ = self.execute({ (_, _, handler) in
            handler.bottomLabel.text = "\((roundf(value * 10000)) / 100) cm"
        })
    }
    
    override internal final func initState() {
        print("MeasuringState2")
        self.endNode = nil
        self.startNode = nil
        guard let newPosition = self.getCurrentPosition() else {
            _ = self.execute({ (_, _, handler) in
                handler.bottomLabel.text = "Fehlgeschlagen"
            })
            return
        }
        self.startNode = self.addPoint(at: newPosition)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (_) in
            guard let safeStart = self.startNode, let endValue = self.getCurrentPosition() else {
                return
            }
            
            if let safeEndNode = self.endNode {
                let action = SCNAction.move(to: endValue, duration: 0.1)
                safeEndNode.runAction(action)
            } else {
                _ = self.execute({ (_, sceneView, _) in
                    self.endNode = sceneView.addMeasurepoint(at: endValue, color: .green, type: .dynamic)
                })
            }
            self.printDistance(with: safeStart.position.distanceFromPos(pos: endValue))
        })
    }
    
    private final func addPoint(at vector: SCNVector3) -> SCNNode {
        var result = SCNNode.init()
        _ = self.execute({ (_, sceneView, _) in
            result = sceneView.addMeasurepoint(at: vector, color: .green, type: .static)
        })
        return result
    }
    
    private final func addDistanceNode(at vector: SCNVector3, with distance: Float) {
        let text = SCNBox.init(width: 0.04, height: 0.02, length: 0.001, chamferRadius: 0.009)
        let node = SCNNode.init(geometry: text)
        node.position = vector
        node.position.y += 0.025
        //: Node soll auf Kamera schauen
        func rotateForever(from value: CGFloat) {
            let rotation = SCNAction.rotateTo(x: 0.0, y: value + 1, z: 0.0, duration: 3)
            node.runAction(rotation) {
                rotateForever(from: value + 1)
            }
        }
        
        
        let textLayer = CATextLayer.init()
        
        text.firstMaterial?.diffuse.contents = UIColor.gray
        _ = self.execute({ (_, sceneView, _) in
            sceneView.scene.rootNode.addChildNode(node)
        })
    }
    
    override internal final func deinitState() {
        self.timer.invalidate()
        self.startNode = nil
        self.endNode?.removeFromParentNode()
        self.endNode = nil
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        guard let newPosition = self.getCurrentPosition() else {
            if self.startNode == nil {
                _ = self.execute({ (_, _, handler) in
                    handler.bottomLabel.text = "Fehlgeschlagen"
                })
            }
            return
        }
        
        guard let startValue = self.startNode else {
            self.startNode = self.addPoint(at: newPosition)
            return
        }
        let distance = newPosition.distanceFromPos(pos: startValue.position)
        //self.addDistanceNode(at: newPosition, with: distance)
        _ = self.execute({ (_, sceneView, _) in
            let endPoint = sceneView.addMeasurepoint(at: newPosition, color: .green, type: .static)
            _ = sceneView.addLine(startPoint: startValue, endPoint: endPoint, from: startValue.position, to: newPosition, with: .green)
        })
        self.printDistance(with: distance)
        _ = self.execute({ (_, _, handler) in
            self.endNode?.physicsBody?.type = SCNPhysicsBodyType.static
            handler.currentState = handler.walkingState
        })
    }
}
