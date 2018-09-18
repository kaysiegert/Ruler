//
//  MeasureView.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 11.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

internal final class StateHandler {
    
    internal final let startState: StartState
    internal final let measuringState: MeasuringState
    internal final let measuringState2: MeasuringState2
    internal final let walkingState: WalkingState
    internal final let settingState: SettingState
    
    //: World-Model
    internal final let world: World
    
    init() {
        //: Initialize State-Pattern
        self.startState = StartState.init()
        self.measuringState = MeasuringState.init()
        self.measuringState2 = MeasuringState2.init()
        self.walkingState = WalkingState.init()
        self.settingState = SettingState.init()
        self._currentState = self.startState
        
        //: Setup World-Model
        self.world = World.init()
    }
    
    internal final var currentState: State {
        get {
            return self._currentState
        }
        
        set(newState) {
            self._currentState.deinitState()
            self._currentState = newState
            self._currentState.initState()
        }
    }
    
    private final var _currentState: State
    
    internal lazy var bottomLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 250, height: 120))
        label.backgroundColor = UIColor.init(white: 0.0, alpha: 0.6)
        label.textColor = UIColor.white
        _ = self.currentState.execute({ (view, _, _) in
            label.center.x = view.center.x
            switch UIDevice.current.orientation {
            case .faceDown, .faceUp, .portrait, .portraitUpsideDown:
                label.center.y = view.frame.height - label.frame.height / 2 - 20
            case .landscapeLeft, .landscapeRight:
                label.center.y = view.frame.height - label.frame.height / 2 - 10
            case .unknown:
                label.center.y = view.frame.height - label.frame.height / 2 - 20
            }
        })
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 30
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    internal lazy var targetImage: UIImageView = {
        let cross = UIImage.init(named: "Cross") ?? UIImage.init()
        let iView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 150, height: 150))
        iView.image = cross
        _ = self.currentState.execute({ (view, _, _) in
            iView.center = view.center
        })
        iView.backgroundColor = .clear
        return iView
    }()
    
    internal lazy var measuringModeSwitch: SegmentedControl = {
        let control = SegmentedControl.init(frame: CGRect.init(x: 0, y: 0, width: 250, height: 35)
            , text: "Automatic", "Manual")
        control.tintColor = .white
        control.backgroundColor = .clear
        control.layer.masksToBounds = true
        control.layer.cornerRadius = 30
        control.removeBorders()
        _ = self.currentState.execute({ (view, _, _) in
            control.center.x = view.center.x
            control.center.y = view.frame.height - control.frame.height / 2 - 20
        })
        return control
    }()
}
