//
//  WalkingState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 11.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class WalkingState: State {
    
    override final func initState() {
        print("WalkingState")
    }
    
    override final func handleTouchesBegan() {
        _ = self.execute({ (_, _, handler) in
            handler.currentState = handler.measuringState
        })
    }
}
