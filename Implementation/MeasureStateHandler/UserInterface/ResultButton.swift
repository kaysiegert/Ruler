//
//  ResultButton.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit

@available(iOS 11.0, *)
internal final class ResultButton: UIButton {
    
    private final let handler: MeasureState_Handler
    
    internal final var currentDistance: Float = 0.0
    internal final var currentLine: (start: SCNVector3, end: SCNVector3) = (SCNVector3Zero, SCNVector3Zero)
    
    init(frame: CGRect, handler: MeasureState_Handler) {
        self.handler = handler
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override internal final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Maß: \(self.currentDistance) übernommen ==> Laufend von \(self.currentLine.start) nach \(self.currentLine.end)")
        self.handler.currentState = self.handler.endState
    }
}
