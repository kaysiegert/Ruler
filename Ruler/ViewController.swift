//
//  ViewController.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 11.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private final let handler = StateHandler.init()
    
    override func viewDidLoad() {
        testWorld()
        
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Create a new scene
        let scene = SCNScene.init()
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        
        _ = self.handler.startState.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        _ = self.handler.measuringState.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        _ = self.handler.walkingState.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        _ = self.handler.measuringState2.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        _ = self.handler.settingState.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        self.handler.currentState = self.handler.startState
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override final func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.handler.currentState.handleWillRotate()
    }
    
    override final func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else {
            return
        }
        let touchPoint = touchLocation.location(in: self.view)
        self.handler.currentState.handleTouchesBegan(at: touchPoint)
    }
    
    override final func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else {
            return
        }
        let touchPoint = touchLocation.location(in: self.view)
        self.handler.currentState.handleTouchesMoved(at: touchPoint)
    }
    
    override final func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else {
            return
        }
        let touchPoint = touchLocation.location(in: self.view)
        self.handler.currentState.handleTouchesEnded(at: touchPoint)
    }

    override final func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else {
            return
        }
        let touchPoint = touchLocation.location(in: self.view)
        self.handler.currentState.handleTouchesEnded(at: touchPoint)
    }
    // MARK: - ARSCNViewDelegate

}
