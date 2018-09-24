//
//  SettingState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 18.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class SettingState: State {
    
    override final func initState() {
        print("SettingState")
        globalSettingNode.node.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
    }
    
    private final func getPositionInFront(with point: CGPoint) -> SCNVector3? {
        var result: SCNVector3? = nil
        _ = self.execute({ (view, sceneView, _) in
            let depth = sceneView.projectPoint(globalSettingNode.node.position).z
            let locationWithz = SCNVector3.init(point.x, point.y, CGFloat(depth))
            result = sceneView.unprojectPoint(locationWithz)
        })
        return result
    }
    
    override final func handleTouchesMoved(at point: CGPoint) {
        if let newPosition = self.getPositionInFront(with: point) {
            let action = SCNAction.move(to: newPosition, duration: 0.01)
            globalSettingNode!.node.runAction(action) {
                globalSettingNode!.replaceLines { (start, line, end) -> SCNNode in
                    line.removeFromParentNode()
                    let newLine = createLine(startPoint: start, endPoint: end, from: start.position, to: end.position, with: .blue)
                    _ = self.execute({ (_, sceneView, _) in
                        sceneView.scene.rootNode.addChildNode(newLine)
                    })
                    return newLine
                }
            }

        }
    }
    
    override final func handleTouchesEnded(at point: CGPoint) {
        _ = self.execute({ (_, _, handler) in
            handler.currentState = handler.walkingState
        })
    }
}
