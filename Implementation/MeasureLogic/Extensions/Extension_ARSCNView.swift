//
//  Extension_ARSCNView.swift
//  Ruler
//
//  Created by Johannes Heinke Business on 09.10.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//

import Foundation
import ARKit

@available(iOS 11.0, *)
internal extension ARSCNView {
    
    internal final func worldPositionWithScreenPosition(_ touchPosition: CGPoint,
                                         objectPos: SCNVector3?,
                                         infinitePlane: Bool = false)
        -> (position: SCNVector3?, planeAnchor: ARPlaneAnchor?, hitAPlane: Bool) {
            let planeHiTestResults = self.hitTest(touchPosition, types: .existingPlaneUsingExtent)
            guard let safeResult = planeHiTestResults.first else {
                
                //: Hier noch Parameter optimieren
                let highQualityFeatureHitTestResults = self.hitTestWithFeatures(touchPosition, coneOpeningAngleInDegrees: 5, minDistance: 0.1, maxDistance: 3.0)
                let featureCloud = self.fliterWithFeatures(highQualityFeatureHitTestResults)
                
                guard featureCloud.count >= 3 else {
                    var featureHitTestPosition: SCNVector3? = nil
                    var highQualityFeautureHitTestResult = false
                    
                    if !featureCloud.isEmpty {
                        featureHitTestPosition = featureCloud.average
                        highQualityFeautureHitTestResult = true
                    } else if !highQualityFeatureHitTestResults.isEmpty {
                        featureHitTestPosition = highQualityFeatureHitTestResults.map { (featureHitTestResult) -> SCNVector3 in
                            return featureHitTestResult.position
                        }.average
                        highQualityFeautureHitTestResult = true
                    }
                    
                    if infinitePlane || !highQualityFeautureHitTestResult {
                        
                        let pointOnPlane = objectPos ?? SCNVector3Zero
                        
                        let pointOnInfinitePlane = self.hitTestWithInfiniteHorizontalPlane(touchPosition, pointOnPlane)
                        if pointOnInfinitePlane != nil {
                            return (pointOnInfinitePlane, nil, true)
                        }
                    }
                    
                    if highQualityFeautureHitTestResult {
                        return (featureHitTestPosition, nil, false)
                    }
                    
                    let unfilteredFeatureHitTestResults = self.hitTestWithFeatures(touchPosition)
                    if !unfilteredFeatureHitTestResults.isEmpty {
                        let result = unfilteredFeatureHitTestResults[0]
                        return (result.position, nil, false)
                    }
                    
                    return (nil, nil, false)
                }
                print("relevant")
                let (detectedPlane, planePosition) = planeDetectWithFeatureCloud(featureCloud: featureCloud)
                let ray = self.hitTestRayFromScreenPos(touchPosition)
                let crossPosition = planeLineIntersectPoint(planeVector: detectedPlane, planePoint: planePosition, lineVector: ray!.direction, linePoint: ray!.origin)
                guard let safeCrossPosition = crossPosition else {
                    return (featureCloud.average!, nil, false)
                }
                return (safeCrossPosition, nil, false)
            }
            let position = SCNVector3.positionFromTransform(safeResult.worldTransform)
            return (position, safeResult.anchor as? ARPlaneAnchor, true)
    }
}
