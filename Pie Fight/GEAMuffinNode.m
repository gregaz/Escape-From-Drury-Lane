//
//  GEAMuffinNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/7/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAMuffinNode.h"
#import "GEAConstants.h"

@implementation GEAMuffinNode

-(void)initializeCollisionConfig {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = muffinCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = enemyCategory;
    self.physicsBody.collisionBitMask = 0;
    
}

@end
