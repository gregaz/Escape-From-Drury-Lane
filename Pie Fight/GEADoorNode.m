//
//  GEADoorNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEADoorNode.h"
#import "GEAConstants.h"

@implementation GEADoorNode

-(void)initializeCollisionConfig {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = doorCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = playerCategory;
    self.physicsBody.collisionBitMask = 0;
}

@end
