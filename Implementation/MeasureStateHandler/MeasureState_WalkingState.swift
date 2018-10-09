//
//  MeasureState_WalkingState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
internal final class MeasureState_WalkingState: MeasureState_General {
    
    override internal final func appaerState() {
        print("WalkingState")
        self.interact { (controller) in
            controller.handler.resultButton.isEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                controller.handler.resultButton.alpha = 1.0
            })
        }
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        self.interact { (controller) in
            controller.handler.currentState = controller.handler.manualMeasurementState
        }
    }
    
    override internal final func disappaerState() {
        self.interact { (controller) in
            controller.handler.resultButton.isEnabled = false
            UIView.animate(withDuration: 0.5, animations: {
                controller.handler.resultButton.alpha = 0.3
            })
        }
    }
}
