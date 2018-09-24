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
    
    private var startNode: SCNNode? = nil
    private final var timer: Timer = Timer.init()
    
    private final func handleMeasureSituation() {
        _ = self.execute({ (view, sceneView, handler) in
            
            guard let startValue = self.startNode else {
                
                //: Funktion welche während der Messung aufgerufen wird
                func initMeasurment(with startValue: SCNNode) {
                    
                    func getCurrentPosition() -> SCNVector3? {
                        guard let knownNode = sceneView.getNode(for: view.center), knownNode.name == "MeasurePoint" else {
                            //: Startpunkt über Hittest finden
                            guard let newVector = sceneView.worldPositionFromScreenPosition(view.center, objectPos: nil).position else {
                                //: kein Wert konnte ermittelt werden --> zurück und fehlschlag anzeigen
                                return nil
                            }
                            //: ein Startpunkt konnte ermittelt werden
                            return newVector
                        }
                        return knownNode.position
                    }
                    
                    self.startNode = startValue
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (_) in
                        _ = self.execute({ (_, _, handler) in
                            guard let startValue = self.startNode, let currentValue = getCurrentPosition() else {
                                return
                            }
                            self.printDistance(with: startValue.position.distanceFromPos(pos: currentValue))
                        })
                    })
                }
                
                //: es wurde kein Startpunkt gesetzt --> es muss zunächst der Startpunkt ermittelt werden
                guard let knownNode = sceneView.getNode(for: view.center), knownNode.name == "MeasurePoint" else {
                    //: Startpunkt über Hittest finden
                    guard let newVector = sceneView.worldPositionFromScreenPosition(view.center, objectPos: nil).position else {
                        //: kein Wert konnte ermittelt werden --> zurück und fehlschlag anzeigen
                        handler.bottomLabel.text = "Fehlgeschlagen\nBitte erneut versuchen"
                        return
                    }
                    //: ein Startpunkt konnte ermittelt werden
                    let startPoint = sceneView.addMeasurepoint(at: newVector, color: .orange, type: .static)
                    initMeasurment(with: startPoint)
                    return
                }
                //: es wurde auf eine bekannte Node gezielt
                initMeasurment(with: knownNode)
                return
            }
            
            //: ein Startpunkt ist bekannt --> Endpunkt ermitteln
            guard let knownNode = sceneView.getNode(for: view.center) else {
                //: Endpunkt über Hittest finden
                guard let newVector = sceneView.worldPositionFromScreenPosition(view.center, objectPos: nil).position else {
                    //: kein Wert konnte ermittelt werden --> zurück
                    return
                }
                //: ein Endpunkt konnte ermittelt werden
                let endPoint = sceneView.addMeasurepoint(at: newVector, color: .orange, type: .static)
                let line = sceneView.addLine(startPoint: startValue, endPoint: endPoint, from: startValue.position, to: newVector, with: .orange)
                world.insertConnection(from: startValue, with: line, to: endPoint)
                self.printDistance(with: startValue.position.distanceFromPos(pos: newVector))
                handler.currentState = handler.walkingState
                return
            }
            //: es wurde auf eine bekannte Node gezielt
            let line = sceneView.addLine(startPoint: startValue, endPoint: knownNode, from: startValue.position, to: knownNode.position, with: .orange)
            world.insertConnection(from: startValue, with: line, to: knownNode)
            self.printDistance(with: startValue.position.distanceFromPos(pos: knownNode.position))
            handler.currentState = handler.walkingState
        })
    }
    
    override func initState() {
        print("MeasuringState")
        self.handleMeasureSituation()
    }
    
    override final func deinitState() {
        self.timer.invalidate()
        self.startNode = nil
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        self.handleMeasureSituation()
    }
    
    private final func printDistance(with value: Float) {
        _ = self.execute({ (_, _, handler) in
            handler.bottomLabel.text = "\((roundf(value * 10000)) / 100) cm"
        })
    }
}
