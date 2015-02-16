//
//  GEAMuffinMan.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/9/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAMuffinMan.h"
#import "GEAConstants.h"

static const int speed = 100;

@implementation GEAMuffinMan

-(void) initializeCollisionConfig {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = enemyCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = muffinCategory + playerCategory + holeCategory;
    self.physicsBody.collisionBitMask = 0;
    
}

-(void)moveTowardsLocation: (CGPoint) destination {
    double duration = [GEAPointMath distanceBetween:destination and:self.position] / speed;
    SKAction* moveAction = [SKAction moveTo:destination duration:duration];
    [self runAction:moveAction];
}

@end
