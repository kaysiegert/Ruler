//
//  MeasureState_EndState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class MeasureState_EndState: MeasureState_General {
    
    override internal final func appaerState() {
        self.interact { (controller) in
            
            let handler = controller.handler
            
            let fadeTime = 1.0
            UIView.animate(withDuration: fadeTime, animations: {
                handler.header.alpha = 0.0
                handler.cancelButton.alpha = 0.0
                handler.arrow.alpha = 0.0
                handler.overlay.alpha = 0.0
                handler.tapGestureImageView.alpha = 0.0
            }, completion: { (_) in
                handler.header.removeFromSuperview()
                handler.cancelButton.removeFromSuperview()
                handler.arrow.removeFromSuperview()
                handler.overlay.removeFromSuperview()
                handler.tapGestureImageView.removeFromSuperview()
            })
        }
    }
}
