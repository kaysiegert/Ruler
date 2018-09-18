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
    private final var timer: Timer = Timer.init()
    
    private final func handleMeasureSituation() {
        _ = self.execute({ (view, sceneView, handler) in
            
            guard let startValue = self.startVector else {
                
                //: Funktion welche während der Messung aufgerufen wird
                func initMeasurment(with startValue: SCNVector3) {
                    
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
                    
                    self.startVector = startValue
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (_) in
                        _ = self.execute({ (_, _, handler) in
                            guard let startValue = self.startVector, let currentValue = getCurrentPosition() else {
                                return
                            }
                            self.printDistance(with: startValue.distanceFromPos(pos: currentValue))
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
                    _ = sceneView.addMeasurepoint(at: newVector, color: .orange, type: .static)
                    initMeasurment(with: newVector)
                    return
                }
                //: es wurde auf eine bekannte Node gezielt
                initMeasurment(with: knownNode.position)
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
                _ = sceneView.addMeasurepoint(at: newVector, color: .orange, type: .static)
                _ = sceneView.addLine(from: startValue, to: newVector, with: .orange)
                self.printDistance(with: startValue.distanceFromPos(pos: newVector))
                handler.currentState = handler.walkingState
                return
            }
            //: es wurde auf eine bekannte Node gezielt
            _ = sceneView.addLine(from: startValue, to: knownNode.position, with: .orange)
            self.printDistance(with: startValue.distanceFromPos(pos: knownNode.position))
            handler.currentState = handler.walkingState
        })
    }
    
    override func initState() {
        print("MeasuringState")
        self.handleMeasureSituation()
    }
    
    override final func deinitState() {
        self.timer.invalidate()
        self.startVector = nil
    }
    
    override internal final func handleTouchesBegan(at point: CGPoint) {
        _ = self.execute({ (_, sceneView, _) in
            guard let knownNode = sceneView.getNode(for: point), knownNode.name == "MeasurePoint" else {
                self.handleMeasureSituation()
                return
            }
            knownNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        })
    }
    
    private final func printDistance(with value: Float) {
        _ = self.execute({ (_, _, handler) in
            handler.bottomLabel.text = "\((roundf(value * 10000)) / 100) cm"
        })
    }
}
