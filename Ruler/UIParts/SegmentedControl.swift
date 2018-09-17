//
//  SegmentedControl.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 17.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import UIKit

internal final class SegmentedControl: UISegmentedControl {
    
    private final let text: [String]
    private final var selectedIndex = 0
    
    init(frame: CGRect, text: String ...) {
        self.text = text
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal final func appear() {
        self.text.enumerated().forEach { (idx, name) in
            self.insertSegment(withTitle: name, at: idx, animated: true)
            if idx == self.selectedIndex {
                self.selectedSegmentIndex = idx
            }
        }
    }
    
    internal final func disappear() {
        self.selectedIndex = self.selectedSegmentIndex
        self.removeAllSegments()
    }
}
