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
        world[settingNode].0.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
        world[settingNode].1.forEach { (node) in
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
        }
    }
    
    private final func getPositionInFront(with point: CGPoint) -> SCNVector3? {
        var result: SCNVector3? = nil
        _ = self.execute({ (view, sceneView, _) in
            let depth = sceneView.projectPoint(world[settingNode].0.position).z
            let locationWithz = SCNVector3.init(point.x, point.y, CGFloat(depth))
            result = sceneView.unprojectPoint(locationWithz)
        })
        return result
    }
    
    override final func handleTouchesMoved(at point: CGPoint) {
        if let newPosition = self.getPositionInFront(with: point) {
            let action = SCNAction.move(to: newPosition, duration: 0.01)
            world[settingNode].0.runAction(action) {
                let lines = world[settingNode].1
                //: Unbedingt Performanter machen und world bereinigen
                let connectedNodes = world.filter { (node, linesTmp) -> Bool in
                    return lines.reduce(false, { (tmp, line) -> Bool in
                        return tmp || linesTmp.contains(line)
                    })
                    }.filter { (node, _) -> Bool in
                        return node != world[settingNode].0
                }
                connectedNodes.forEach { (node,_) in
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                }
                lines.forEach { (line) in
                    line.removeFromParentNode()
                }
                connectedNodes.forEach({ (node, _) in
                    _ = self.execute({ (_, sceneView, _) in
                        sceneView.addLine(startPoint: world[settingNode].0, endPoint: node, from: world[settingNode].0.position, to: node.position, with: UIColor.yellow)
                    })
                })
            }
        }
    }
    
    override final func handleTouchesEnded(at point: CGPoint) {
        _ = self.execute({ (_, _, handler) in
            handler.currentState = handler.walkingState
        })
    }
}
