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
            
            handler.header.isHidden = true
            handler.cancelButton.isHidden = true
            handler.arrow.isHidden = true
            handler.overlay.isHidden = true
            handler.tapGestureImageView.isHidden = true
            
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
            
            let fadeTime = 0.5
            UIView.animate(withDuration: fadeTime, animations: {
                handler.header.isHidden = false
                handler.cancelButton.isHidden = false
                handler.arrow.isHidden = false
                handler.overlay.isHidden = false
                handler.tapGestureImageView.isHidden = false
            })
        }
    }
}
