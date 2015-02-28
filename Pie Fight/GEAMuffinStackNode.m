//
//  GEAMuffinStackNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAMuffinStackNode.h"
#import "GEAConstants.h"

@implementation GEAMuffinStackNode {
    int _numberOfMuffins;
}

@synthesize numberOfMuffins = _numberOfMuffins;

-(id)initWithRandomNumberOfMuffins {
    self = [super initWithImageNamed:@"muffinStack8.png"];
    [self setMuffinCount: (int) arc4random_uniform(8)+1 ];
    return self;
}

-(void) initializeCollisionConfig {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = muffinStackCategory;
    self.physicsBody.contactTestBitMask = playerCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.collisionBitMask = 0;
}

-(void)setMuffinCount: (int)muffinCount {
    if(muffinCount == 0) {
        [self removeFromParent];
    } else {
        self.numberOfMuffins = muffinCount;
        NSString *imageName = [NSString stringWithFormat:@"muffinStack%i.png", muffinCount];
        [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed: imageName] resize:true]];
        [self setScale:0.05];
    }
}

-(void)loseOneMuffin {
    [self setMuffinCount: self.numberOfMuffins - 1];
}

@end
