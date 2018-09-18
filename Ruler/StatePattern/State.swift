//
//  State.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 11.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit
import ARKit

internal class State {
    
    private final var view: UIView?
    private final var sceneView: ARSCNView?
    private final var handler: StateHandler?
    
    init(with view: UIView? = nil, sceneView: ARSCNView? = nil, handler: StateHandler? = nil) {
        self.view = view
        self.handler = handler
    }
    
    internal final func add(view: UIView, sceneView: ARSCNView, handler: StateHandler) -> Bool {
        guard self.view != nil && self.handler != nil else {
            self.view = view
            self.sceneView = sceneView
            self.handler = handler
            return true
        }
        return false
    }
    
    internal final func execute(_ closure: (_ view: UIView, _ sceneView: ARSCNView, _ handler: StateHandler) -> Void) -> Bool {
        guard let safeView = self.view
            , let safeHandler = self.handler
            , let safeSceneView = self.sceneView else {
            return false
        }
        closure(safeView, safeSceneView, safeHandler)
        return true
    }
    
    internal func initState() {}
    internal func deinitState() {}
    
    internal func handleUpdate() {}
    internal func handleTouchesBegan(at point: CGPoint) {}
    internal func handleTouchesMoved(at point: CGPoint) {}
    internal func handleTouchesEnded(at point: CGPoint) {}
    
    internal func handleDidRotate() {}
    internal func handleWillRotate() {
        self.locateBottomLabel()
        self.locateTargetImage()
        self.locateMeasureModeSwitch()
    }
    
    private final func locateBottomLabel() {
        _ = self.execute({ (view, _, handler) in
            handler.bottomLabel.center.x = view.center.y
            switch UIDevice.current.orientation {
            case .faceDown, .faceUp, .portrait, .portraitUpsideDown:
                handler.bottomLabel.center.y = view.frame.width - handler.bottomLabel.frame.height / 2 - 20
            case .landscapeLeft, .landscapeRight, .unknown:
                handler.bottomLabel.center.y = view.frame.width - handler.bottomLabel.frame.height / 2 - 10
            }
        })
    }
    
    private final func locateTargetImage() {
        _ = self.execute({ (view, _, handler) in
            handler.targetImage.center.x = view.center.y
            handler.targetImage.center.y = view.center.x
        })
    }
    
    private final func locateMeasureModeSwitch() {
        _ = self.execute({ (view, _, handler) in
            handler.measuringModeSwitch.center.x = view.center.y
            switch UIDevice.current.orientation {
            case .faceDown, .faceUp, .portrait, .portraitUpsideDown:
                handler.measuringModeSwitch.center.y = view.frame.width - handler.measuringModeSwitch.frame.height / 2 - 20
            case .landscapeLeft, .landscapeRight, .unknown:
                handler.measuringModeSwitch.center.y = view.frame.width - handler.measuringModeSwitch.frame.height / 2 - 10
            }
        })
    }
    
    internal final var currentLight: ARLightEstimate? {
        var estimate: ARLightEstimate? = nil
        _ = self.execute({ (_, sceneViewTmp, _) in
            guard let lightEstimate = sceneViewTmp.session.currentFrame?.lightEstimate else {
                return
            }
            estimate = lightEstimate
        })
        return estimate
    }
}

