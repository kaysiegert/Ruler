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
            
            let spotLight = SCNNode()
            spotLight.light = SCNLight()
            spotLight.scale = SCNVector3(1,1,1)
            spotLight.light?.intensity = 100000
            //spotLight.castsShadow = true
            spotLight.position = SCNVector3Zero
            spotLight.light?.type = SCNLight.LightType.directional
            spotLight.light?.color = UIColor.yellow
            sceneView.scene.rootNode.addChildNode(spotLight)
        })
    }
    
    override internal final func handleTouchesBegan() {
        _ = self.execute({ (_, _, handler) in
            handler.currentState = handler.measuringState
        })
    }
}
