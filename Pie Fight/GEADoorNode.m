//
//  GEADoorNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEADoorNode.h"
#import "GEAConstants.h"

@implementation GEADoorNode {
    SKTextureAtlas* doorWalkThroughAtlas;
    NSMutableArray* doorWalkThroughAnimationArray;
}

-(id) initDoor {
    self = [self init];
    doorWalkThroughAtlas = [SKTextureAtlas atlasNamed: @"enterDoor"];
    doorWalkThroughAnimationArray = [NSMutableArray array];
    
    for(int i = 1; i <= doorWalkThroughAtlas.textureNames.count; i++) {
        NSString* fileName = [NSString stringWithFormat: @"enterDoor%i", i];
        SKTexture *temp = [doorWalkThroughAtlas textureNamed:fileName];
        [doorWalkThroughAnimationArray addObject:temp];
    }
    
    [self setTexture: (SKTexture*) doorWalkThroughAnimationArray[5]];
    [self setSize: [(SKTexture*) doorWalkThroughAnimationArray[5] size]];
    [self initializeCollisionConfig];
    return self;

}

-(void)initializeCollisionConfig {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = doorCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = playerCategory;
    self.physicsBody.collisionBitMask = 0;
}

-(void) animateDoorWalkThrough {
    [self removeAllActions];
    
    [self runAction: [SKAction animateWithTextures: doorWalkThroughAnimationArray
                                      timePerFrame:0.2f
                                            resize:YES
                                           restore:YES]];
    [self runAction: [SKAction waitForDuration:1.2] completion:^{[self runAction: [SKAction playSoundFileNamed:@"bye.mp3" waitForCompletion:NO]];} ];
    
}

@end
