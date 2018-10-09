//
//  MeasureStateHandler.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit
import ARKit

internal final class MeasureState_Handler {
    
    internal final let startState = MeasureState_StartState.init()
    internal final let walkingState = MeasureState_WalkingState.init()
    internal final let manualMeasurementState = MeasureState_ManualMeasureState.init()
    internal final let automaticMeasurementDrawState = MeasureState_DrawState.init()
    internal final let endState = MeasureState_EndState.init()
    
    internal final var world = UndirectedGraphSet<SCNNode, SCNNode>.init()
    
    private final var _currentState: MeasureState_General = MeasureState_StartState.init()
    
    internal final var currentState: MeasureState_General {
        get {
            return self._currentState
        }
        set(newState) {
            self._currentState.disappaerState()
            self._currentState = newState
            self._currentState.appaerState()
        }
    }
    
    /*
     MARK: UserInterface
     */
    
    internal final lazy var sceneView = { () -> ARSCNView in
        var sceneView = ARSCNView.init()
        self.currentState.interact({ (controller) in
            sceneView = ARSCNView.init(frame: controller.viewController.view.frame)
            sceneView.delegate = controller.viewController
            let scene = SCNScene.init()
            sceneView.scene = scene
            sceneView.isHidden = true
            
            let config = ARWorldTrackingConfiguration.init()
            sceneView.session.run(config)
        })
        return sceneView
    }()
    
    internal final lazy var header = { () -> UIView in
        var header = UIView.init()
        self.currentState.interact({ (controller) in
            header = UIView.init(frame: CGRect(x: 0, y: 0, width: controller.viewController.view.frame.size.width, height: 60))
            header.backgroundColor = .black
        })
        return header
    }()
    
    internal final lazy var cancelButton = { () -> CancelButton in
        var button = CancelButton.init(frame: CGRect.init(), handler: self)
        self.currentState.interact({ (controller) in
            button = CancelButton.init(frame: CGRect(x: controller.viewController.view.frame.size.width-50, y: 10, width: 40, height: 40), handler: self)
            button.setImage(UIImage.init(named: "Images/btnCancel.png"), for: .normal)
        })
        return button
    }()
    
    internal final lazy var arrow = { () -> UIImageView in
        let arrow = UIImageView.init(image: UIImage.init(named: "Images/arrow-top-left.png"))
        arrow.frame = CGRect(x: 5, y: 5, width: arrow.frame.size.width, height: arrow.frame.size.height)
        return arrow
    }()
    
    internal final lazy var overlay = { () -> UIView in
        var overlay = UIView.init()
        self.currentState.interact({ (controller) in
            overlay = UIView.init(frame: CGRect(x: 10, y: self.arrow.frame.origin.y + self.arrow.frame.size.height, width: controller.viewController.view.frame.size.width - 20, height: 220))
            overlay.backgroundColor = UIColor.init(red: 1, green: 222/255, blue: 0, alpha: 1)
            overlay.layer.cornerRadius = 5
            overlay.clipsToBounds = true
        })
        return overlay
    }()
    
    internal final lazy var instructionLabel = { () -> UILabel in
        let label = UILabel.init(frame: CGRect(x: 10, y: 10, width: self.overlay.frame.size.width - 20, height: 60))
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.numberOfLines = 4;
        label.textAlignment = .center
        label.font = UIFont.init(name: "ArialNarrow-Bold", size: 14)
        label.text = "Sie können das Maß jetzt übernehmen. Um eine neue Messung zu starten, tippen Sie erneut auf den unteren Bildschirmbereich."
        return label
    }()
    
    internal final lazy var measurementLabel = { () -> UILabel in
        let label = UILabel.init(frame: CGRect(x: 10, y: 70, width: self.overlay.frame.size.width - 20, height: 40))
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.init(name: "ArialNarrow-Bold", size: 30)
        label.text = "0,00 cm"
        return label
    }()
    
    internal final lazy var resultButton = { () -> ResultButton in
        let button = ResultButton.init(frame: CGRect(x: 70, y: 120, width: self.overlay.frame.size.width-140, height: 50), handler: self)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 5
        button.setTitleColor(self.overlay.backgroundColor, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.titleLabel?.font = UIFont.init(name: "ArialNarrow-BoldItalic", size: 18)
        button.setTitle("Maß übernehmen", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    internal final lazy var infoLabel = { () -> UILabel in
        let label = UILabel.init(frame: CGRect(x: 10, y: 185, width: self.overlay.frame.size.width-20, height: 20))
        label.backgroundColor = .clear
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont.init(name: "ArialNarrow", size: 12)
        label.text = "Bitte beachten Sie, dass es sich um etwaige Werte handelt."
        return label
    }()
    
    internal final lazy var tapGestureImageView = { () -> UIImageView in
        var gesture = UIImageView.init()
        self.currentState.interact({ (controller) in
            gesture = UIImageView.init(frame: CGRect(x: 0, y: controller.viewController.view.frame.size.height / 2, width: controller.viewController.view.frame.size.width, height: controller.viewController.view.frame.size.height / 2))
            gesture.image = UIImage.init(named: "Images/tapGesture.png")
            gesture.contentMode = .center
        })
        return gesture
    }()
}
