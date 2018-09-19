//
//  WalkingState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 11.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

var settingNode: Int = 0
var world = [(SCNNode, [Branch])].init()

internal final class Branch {
    internal let start: SCNNode
    internal var line: SCNNode
    
    init(start: SCNNode, line: SCNNode) {
        self.start = start
        self.line = line
    }
}

internal final class WalkingState: State {
    
    override final func initState() {
        print("WalkingState")
        _ = self.execute({ (_, _, handler) in
            handler.measuringModeSwitch.appear()
        })
    }
    
    override final func handleTouchesBegan(at point: CGPoint) {
        _ = self.execute({ (_, sceneView, handler) in
            guard let knownNode = sceneView.getNode(for: point), knownNode.name == "MeasurePoint" else {
                switch handler.measuringModeSwitch.selectedSegmentIndex {
                case 0:
                    handler.currentState = handler.measuringState
                case 1:
                    handler.currentState = handler.measuringState2
                default:
                    print("Switch Error")
                }
                return
            }
            //: Go to SettingState
            guard let settingNodeIndex = world.firstIndex(where: { (node,_) -> Bool in
                return node == knownNode
            }) else {
                return
            }
            settingNode = settingNodeIndex
            handler.currentState = handler.settingState
        })
    }
    
    override final func deinitState() {
        _ = self.execute({ (_, _, handler) in
            handler.measuringModeSwitch.disappear()
        })
    }
}
