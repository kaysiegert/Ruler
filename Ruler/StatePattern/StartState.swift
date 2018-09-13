//
//  StartState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 11.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class StartState: State {
    
    override internal final func initState() {
        print("StartState")
        _ = self.execute({ (view, sceneView, handler) in
            view.addSubview(handler.bottomLabel)
            view.addSubview(handler.targetImage)
            handler.bottomLabel.text = "Tap to start"
            
            let lightNode = SCNNode.init()
            lightNode.light = SCNLight.init()
            lightNode.light?.color = UIColor.white
            lightNode.light?.intensity = 10
            lightNode.light?.temperature = 300
            lightNode.light?.type = SCNLight.LightType.probe
            lightNode.position = SCNVector3Zero
            sceneView.scene.rootNode.addChildNode(lightNode)
        })
    }
    
    override internal final func handleTouchesBegan() {
        _ = self.execute({ (_, _, handler) in
            handler.currentState = handler.measuringState
        })
    }
}
