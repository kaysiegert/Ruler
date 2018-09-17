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
            view.addSubview(handler.measuringModeSwitch)
            view.addSubview(handler.workingModeSwitch)
            handler.bottomLabel.text = "Tap to start"
            
            handler.currentState = handler.walkingState
        })
    }

}
