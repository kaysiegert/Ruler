//
//  ResultButton.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class ResultButton: UIButton {
    
    private final let handler: MeasureState_Handler
    
    init(frame: CGRect, handler: MeasureState_Handler) {
        self.handler = handler
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override internal final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Maß: \(currentDistance) übernommen")
        self.handler.currentState = self.handler.endState
    }
}
