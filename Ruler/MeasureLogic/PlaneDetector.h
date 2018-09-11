//
//  PlaneDetector.h
//  Ruler
//
//  Created by Johannes Heinke Business on 11.09.18.
//  Copyright © 2018 Mikavaa. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

@interface PlaneDetector : NSObject

+ (SCNVector4)detectPlaneWithPoints:(NSArray <NSValue* >*)points;


@end
