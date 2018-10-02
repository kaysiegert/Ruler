//
//  MeasureState_General.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import ARKit

internal class MeasureState_General {
    
    private final var view: MeasureController? = nil
    
    internal func appaerState() {}
    internal func disappaerState() {}
    internal func handleTouchesBegan(at point: CGPoint) {}
    
    internal final func register(controller: MeasureController) -> Bool {
        guard self.view != nil else {
            self.view = controller
            return true
        }
        return false
    }
    
    internal final func interact(_ interaction: (_ controller: MeasureController) -> Void) {
        guard let safeView = self.view else {
            return
        }
        interaction(safeView)
    }
}
