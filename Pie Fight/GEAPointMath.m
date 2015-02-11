//
//  GEAPointMath.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/10/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAPointMath.h"

@implementation GEAPointMath

+(double)distanceBetween: (CGPoint) pointA and: (CGPoint) pointB {
    return sqrt(pow(pointA.x-pointB.x,2) + pow(pointA.y-pointB.y,2));
}

+(CGPoint)scalePoint: (CGPoint) point by: (float) factor {
    return CGPointMake(point.x * factor, point.y * factor);
}

+(CGPoint)addPoint:(CGPoint) pointA andPoint: (CGPoint) pointB {
    return CGPointMake(pointA.x + pointB.x, pointA.y + pointB.y);
}


@end
