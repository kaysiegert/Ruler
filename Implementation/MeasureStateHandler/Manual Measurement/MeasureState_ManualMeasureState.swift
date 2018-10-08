//
//  MeasureState_ManualMeasureState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation

internal final class MeasureState_ManualMeasureState: MeasureState_General {
 
    private final var timer = Timer.init()
    private final var startPosition: SCNVector3? = nil
    
    private final var currentPosition: SCNVector3? {
        var result: SCNVector3? = nil
        self.interact { (controller) in
            guard let currentFrame = controller.handler.sceneView.session.currentFrame else {
                result = controller.handler.sceneView.unprojectPoint(SCNVector3Zero)
                return
            }
            /*
            let transform = simd_mul(currentFrame.camera.transform, matrix_identity_float4x4)
            result = SCNVector3.init(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
             */
            result = controller.handler.sceneView.unprojectPoint(SCNVector3Zero)
        }
        return result
    }

    private final var tmpDifference: Float? = nil
    private final var lastEnd: SCNVector3? = nil
    private final func handleMeasureSituation() {
        guard let startValue = self.startPosition else {
            self.interact { (controller) in
                guard let safeStartValue = self.currentPosition else {
                    return
                }
                self.startPosition = safeStartValue
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (_) in
                    guard let startValue = self.startPosition else {
                        return
                    }
                    self.interact({ (controller) in
                        guard let endValue = self.currentPosition else {
                            return
                        }
                        controller.handler.measurementLabel.text = "\(((endValue.distanceFromPos(pos: startValue) * 10000).rounded() / 100).rounded()) cm"
                        /* Test
                        if let safeEnd = self.lastEnd {
                            guard let safeTmp = self.tmpDifference else {
                                let first = endValue.distanceFromPos(pos: startValue)
                                let second = safeEnd.distanceFromPos(pos: startValue)
                                self.tmpDifference = { () -> Float in
                                    let r = first - second
                                    if r >= 0 {
                                        return r
                                    } else {
                                        return r * -1
                                    }
                                }()
                                self.lastEnd = endValue
                                return
                            }
                            let first = endValue.distanceFromPos(pos: startValue)
                            let second = safeEnd.distanceFromPos(pos: startValue)
                            let currentDistance = { () -> Float in
                                let r = first - second
                                if r >= 0 {
                                    return r
                                } else {
                                    return r * -1
                                }
                            }()
                            self.tmpDifference = currentDistance
                            self.lastEnd = endValue
                            if currentDistance <= safeTmp * 1.05 {
                                print(first)
                            }
                            
                        } else {
                            self.lastEnd = endValue
                        }
                        // Ende Test*/
                    })
                })
            }
            return
        }
        self.interact { (controller) in
            guard let endValue = self.currentPosition else {
                return
            }
            controller.handler.resultButton.currentDistance = endValue.distanceFromPos(pos: startValue)
            controller.handler.resultButton.currentLine = (startValue, endValue)
            controller.handler.currentState = controller.handler.walkingState
        }
    }
    
    override internal final func appaerState() {
        print("ManualMeasureState")
        self.handleMeasureSituation()
    }
    
    override internal final func disappaerState() {
        self.startPosition = nil
        self.timer.invalidate()
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        self.handleMeasureSituation()
    }
}
