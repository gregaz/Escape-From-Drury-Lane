//
//  GEAMuffinMan.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/9/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAMuffinMan.h"

static const int speed = 20;

@implementation GEAMuffinMan

-(void)moveTowardsLocation: (CGPoint) destination {
    double duration = [GEAPointMath distanceBetween:destination and:self.position] / speed;
    SKAction* moveAction = [SKAction moveTo:destination duration:duration];
    [self runAction:moveAction];
}

@end
