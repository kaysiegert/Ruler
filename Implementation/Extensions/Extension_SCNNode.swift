//
//  Extension_SCNNode.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 02.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import ARKit

extension SCNNode: hasUniqueKey {
    var key: Int {
        return self.hash
    }
}
