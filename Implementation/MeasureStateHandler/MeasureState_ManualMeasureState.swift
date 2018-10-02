//
//  MeasureState_ManualMeasureState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal var currentDistance: Float = 0.0

internal final class MeasureState_ManualMeasureState: MeasureState_General {
 
    private final var timer = Timer.init()
    private final var startPosition: SCNVector3? = nil
    
    private final func handleMeasureSituation() {
        guard let startValue = self.startPosition else {
            self.interact { (controller) in
                self.startPosition = controller.handler.sceneView.unprojectPoint(SCNVector3Zero)
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (_) in
                    guard let startValue = self.startPosition else {
                        return
                    }
                    self.interact({ (controller) in
                        let endValue = controller.handler.sceneView.unprojectPoint(SCNVector3Zero)
                        controller.handler.measurementLabel.text = "\((endValue.distanceFromPos(pos: startValue) * 10000).rounded() / 100) cm"
                    })
                })
            }
            return
        }
        self.interact { (controller) in
            let endValue = controller.handler.sceneView.unprojectPoint(SCNVector3Zero)
            currentDistance = endValue.distanceFromPos(pos: startValue)
            controller.handler.currentState = controller.handler.walkingState
        }
    }
    
    override internal final func appaerState() {
        print("ManualMeasureState")
        self.handleMeasureSituation()
    }
    
    override internal final func disappaerState() {
        self.startPosition = nil
        self.timer.invalidate()
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        self.handleMeasureSituation()
    }
}
