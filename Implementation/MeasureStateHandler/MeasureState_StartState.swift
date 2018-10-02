//
//  MeasureState_StartState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class MeasureState_StartState: MeasureState_General {
    
    override internal final func appaerState() {
        self.interact { (controller) in
            
            let handler = controller.handler
            
            handler.header.alpha = 0.0
            handler.cancelButton.alpha = 0.0
            handler.arrow.alpha = 0.0
            handler.overlay.alpha = 0.0
            handler.tapGestureImageView.alpha = 0.0
            
            let view = controller.viewController.view!
            view.addSubview(handler.header)
            view.addSubview(handler.cancelButton)
            view.addSubview(handler.arrow)
            view.addSubview(handler.overlay)
            view.addSubview(handler.tapGestureImageView)
            handler.overlay.addSubview(handler.measurementLabel)
            handler.overlay.addSubview(handler.resultButton)
            handler.overlay.addSubview(handler.instructionLabel)
            handler.overlay.addSubview(handler.infoLabel)
            
            let fadeTime = 1.0
            UIView.animate(withDuration: fadeTime, animations: {
                handler.header.alpha = 1.0
                handler.cancelButton.alpha = 1.0
                handler.arrow.alpha = 1.0
                handler.overlay.alpha = 1.0
                handler.tapGestureImageView.alpha = 1.0
                
            })
        }
    }
}
