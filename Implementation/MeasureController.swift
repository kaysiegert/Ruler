//
//  MeasureController.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit
import ARKit

internal final class MeasureController: NSObject {
    
    internal final let handler = MeasureState_Handler.init()
    internal final let viewController: UIViewController & ARSCNViewDelegate
    
    private final var firstCall = true
    
    @objc internal final func setupMeasurement() {
        // test
        if self.firstCall {
            _ = self.handler.startState.register(controller: self)
            _ = self.handler.walkingState.register(controller: self)
            _ = self.handler.manualMeasurementState.register(controller: self)
            _ = self.handler.endState.register(controller: self)
            self.firstCall = false
        } else {
            let configuration = ARWorldTrackingConfiguration.init()
            self.handler.sceneView.session.run(configuration)
        }
        self.handler.currentState = self.handler.startState
    }
    
    init(viewController: UIViewController & ARSCNViewDelegate) {
        self.viewController = viewController
    }
}
