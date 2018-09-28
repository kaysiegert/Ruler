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
    
    private var textviewInstruction: UITextView!
    private var labelMeasurement: UILabel!
    private var buttonUseResult: UIButton!
    
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
        
        setupUI()
        
        _ = self.handler.startState.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        _ = self.handler.measuringState.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        _ = self.handler.walkingState.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        _ = self.handler.measuringState2.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        _ = self.handler.settingState.add(view: self.view, sceneView: self.sceneView, handler: self.handler)
        self.handler.currentState = self.handler.startState
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupUI(){
        
        let ui = UIView.init(frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: view.frame.size.height))
        ui.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(ui)
        
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        header.backgroundColor = .black
        ui.addSubview(header)
        
        let btnCancel = UIButton.init(frame: CGRect(x: view.frame.size.width-50, y: 10, width: 40, height: 40))
        btnCancel.setImage(UIImage.init(named: "Images/btnCancel.png"), for: .normal)
        // add callback
        ui.addSubview(btnCancel)
        
        let arrow = UIImageView.init(image: UIImage.init(named: "Images/arrow-top-left.png"))
        arrow.frame = CGRect(x: 5, y: 5, width: arrow.frame.size.width, height: arrow.frame.size.height)
        ui.addSubview(arrow)
        
        let overlay = UIView.init(frame: CGRect(x: 10, y: arrow.frame.origin.y+arrow.frame.size.height, width: view.frame.size.width-20, height: 220))
        overlay.backgroundColor = UIColor.init(red: 1, green: 222/255, blue: 0, alpha: 1)
        overlay.layer.cornerRadius = 5
        overlay.clipsToBounds = true
        ui.addSubview(overlay)
        
        textviewInstruction = UITextView.init(frame: CGRect(x: 10, y: 10, width: overlay.frame.size.width-20, height: 60))
        textviewInstruction.backgroundColor = .clear
        textviewInstruction.textColor = .darkGray
        textviewInstruction.textAlignment = .center
        textviewInstruction.font = UIFont.init(name: "ArialNarrow-Bold", size: 14)
        textviewInstruction.text = "Sie können das Maß jetzt übernehmen. Um eine neue Messung zu starten, tippen Sie erneut auf den unteren Bildschirmbereich."
        overlay.addSubview(textviewInstruction)
        
        labelMeasurement = UILabel.init(frame: CGRect(x: 10, y: 70, width: overlay.frame.size.width-20, height: 40))
        labelMeasurement.backgroundColor = .clear
        labelMeasurement.textColor = .darkGray
        labelMeasurement.textAlignment = .center
        labelMeasurement.font = UIFont.init(name: "ArialNarrow-Bold", size: 30)
        labelMeasurement.text = "123,45 cm"
        overlay.addSubview(labelMeasurement)
        
        buttonUseResult = UIButton.init(frame: CGRect(x: 70, y: 120, width: overlay.frame.size.width-140, height: 50))
        buttonUseResult.backgroundColor = .darkGray
        buttonUseResult.layer.cornerRadius = 5
        buttonUseResult.setTitleColor(overlay.backgroundColor, for: .normal)
        buttonUseResult.setTitleColor(.white, for: .highlighted)
        buttonUseResult.titleLabel?.font = UIFont.init(name: "ArialNarrow-BoldItalic", size: 18)
        buttonUseResult.setTitle("Maß übernehmen", for: .normal)
        overlay.addSubview(buttonUseResult)
        
        let labelInfo = UILabel.init(frame: CGRect(x: 10, y: 185, width: overlay.frame.size.width-20, height: 20))
        labelInfo.backgroundColor = .clear
        labelInfo.textColor = .darkGray
        labelInfo.textAlignment = .center
        labelInfo.font = UIFont.init(name: "ArialNarrow", size: 12)
        labelInfo.text = "Bitte beachten Sie, dass es sich um etwaige Werte handelt."
        overlay.addSubview(labelInfo)
        
        let tapGesture = UIImageView.init(frame: CGRect(x: 0, y: view.frame.size.height/2, width: view.frame.size.width, height: view.frame.size.height/2))
        tapGesture.image = UIImage.init(named: "Images/tapGesture.png")
        tapGesture.contentMode = .center
        ui.addSubview(tapGesture)
        
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
