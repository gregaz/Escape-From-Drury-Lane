//
//  GEAPointMath.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/10/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GEAPointMath : NSObject

+(double)distanceBetween: (CGPoint) pointA and: (CGPoint) pointB;
+(CGPoint)addPoint:(CGPoint) pointA andPoint: (CGPoint) pointB;
+(CGPoint)scalePoint: (CGPoint) point by: (float) factor;

@end
