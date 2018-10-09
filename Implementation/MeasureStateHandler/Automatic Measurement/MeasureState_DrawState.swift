//
//  MeasureState_DrawState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 08.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class MeasureState_DrawState: MeasureState_General {
    
    override func appaerState() {
        print("Draw")
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        self.interact { (controller) in
            let r = controller.handler.sceneView.worldPositionFromScreenPosition(point, objectPos: nil)
            print(r)
        }
    }
}
