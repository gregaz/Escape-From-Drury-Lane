//
//  GEAMuffinNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/7/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAMuffinNode.h"
#import "GEAConstants.h"
#import "GEAPointMath.h"

@implementation GEAMuffinNode {
    CGPoint destination;
}

-(void) launchMuffinTowardsDestination: (CGPoint) aDestination {
    destination = aDestination;
    float duration = [GEAPointMath distanceBetween:self.position and: destination] / muffinVelocity;
    
    SKAction* moveAction = [SKAction moveTo:destination duration:duration];
    SKAction* moveDoneAction = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[moveAction, moveDoneAction]]];
}

-(void)initializeCollisionConfig {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = muffinCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = enemyCategory;
    self.physicsBody.collisionBitMask = 0;
    [self setZPosition: -50.0];
    
}

-(CGPoint)launchDestination {
    return destination;
}

@end
