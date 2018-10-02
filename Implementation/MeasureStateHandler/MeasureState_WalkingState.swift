//
//  MeasureState_WalkingState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class MeasureState_WalkingState: MeasureState_General {
    
    override internal final func appaerState() {
        print("WalkingState")
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        self.interact { (controller) in
            controller.handler.currentState = controller.handler.manualMeasurementState
        }
    }
}
