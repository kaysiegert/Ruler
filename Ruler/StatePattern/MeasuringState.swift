//
//  MeasuringState.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 11.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

internal final class MeasuringState: State {
    
    private var startVector: SCNVector3? = nil
    private final var timer: Timer
    
    override init(with view: UIView? = nil, sceneView: ARSCNView? = nil, handler: StateHandler? = nil) {
        self.timer = Timer.init()
        super.init(with: view, sceneView: sceneView, handler: handler)
    }
    
    private final func getStartValue() {
        _ = self.execute({ (view, sceneView, handler) in
            guard let result = sceneView.worldPositionFromScreenPosition(view.center, objectPos: nil).position else {
                handler.bottomLabel.text = "Fehlgeschlagen\nBitte erneut versuchen"
                return
            }
            self.startVector = result
            self.addPoint(at: result)
        })
    }
    
    private final func addPoint(at vector: SCNVector3) {
        _ = self.execute({ (_, sceneView, _) in
            let boxGeo = SCNSphere.init(radius: 0.02)
            boxGeo.firstMaterial?.diffuse.contents = UIColor.orange
            let box = SCNNode.init(geometry: boxGeo)
            box.position = vector
            sceneView.scene.rootNode.addChildNode(box)
        })
    }
    
    override func initState() {
        print("MeasuringState")
        self.getStartValue()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (_) in
            self.handleUpdate()
        })
    }
    
    override final func deinitState() {
        self.timer.invalidate()
        self.startVector = nil
    }
    
    override final func handleTouchesBegan() {
        _ = self.execute({ (view, sceneView, handler) in
            guard let startValue = self.startVector else {
                //: Es muss zunächst ein Startwert ermittelt werden
                self.getStartValue()
                return
            }
            //: Endwert bestimmen
            guard let endValue = sceneView.worldPositionFromScreenPosition(view.center, objectPos: nil).position else {
                handler.bottomLabel.text = "Fehlgeschlagen\nBitte erneut versuchen"
                return
            }
            self.printDistance(with: startValue.distanceFromPos(pos: endValue))
            //: Linie mit Distanz zeichnen
            self.addPoint(at: endValue)
            handler.currentState = handler.walkingState
        })
    }
    
    private final func printDistance(with value: Float) {
        _ = self.execute({ (_, _, handler) in
            handler.bottomLabel.text = "\((roundf(value * 10000)) / 100) cm"
        })
    }
    
    override func handleUpdate() {
        _ = self.execute({ (view, sceneView, handler) in
            if let startValue = self.startVector {
                if let endValue = sceneView.worldPositionFromScreenPosition(view.center, objectPos: nil).position {
                    let distance = startValue.distanceFromPos(pos: endValue)
                    self.printDistance(with: distance)
                } else {
                    handler.bottomLabel.text = "Keine Werte"
                }
            } else {
                handler.bottomLabel.text = "Fehlgeschlagen\nBitte erneut versuchen"
            }
        })
    }
}
