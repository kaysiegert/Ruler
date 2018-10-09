//
//  TapGestureView.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
internal final class TapGestureView: UIImageView {
    
    private final let handler: MeasureState_Handler
    
    init(frame: CGRect, handler: MeasureState_Handler) {
        self.handler = handler
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override internal final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else {
            return
        }
        let touchPoint = touchLocation.location(in: self)
        self.handler.currentState.handleTouchesBegan(at: touchPoint)
    }
}
