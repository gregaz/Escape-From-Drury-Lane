//
//  GEAHoleNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAHoleNode.h"
#import "GEAConstants.h"
#import "GEAGameScene.h"

@implementation GEAHoleNode {
    bool isKillable;
    float respawnWaitTime;
    SKAction *animationAction;
}

-(id) initHoleWithOpeningArray: (NSMutableArray*) openingAnimationArray andCloseTexture: (SKTexture*) holeClosedTexture {
    self = [super init];
    
    [self setTexture: (SKTexture *) openingAnimationArray[0]];
    [self setSize: [(SKTexture*) openingAnimationArray[0] size]];
    [self setScale: 0.6];
    [self initializeCollisionConfig];
    respawnWaitTime = arc4random_uniform(7)+1;

    SKAction *setUnkillableAction = [SKAction runBlock: ^{[self setKillable: false];}];
    SKAction *setClosedHoleAction = [SKAction setTexture: holeClosedTexture];
    SKAction *waitTimeBetweenSpawns = [SKAction waitForDuration: (NSTimeInterval) respawnWaitTime];
    SKAction *setKillableAction = [SKAction runBlock: ^{[self setKillable: true];}];
    SKAction *holeOpening = [SKAction animateWithTextures: openingAnimationArray
                                             timePerFrame:0.1f
                                                   resize:YES
                                                  restore:NO];
    SKAction *spawnMuffinManAction = [SKAction runBlock: ^{
            [(GEAGameScene*) self.parent spawnMuffinManFromHole: self ];}];

    
    animationAction = [SKAction repeatActionForever: [SKAction sequence: @[setUnkillableAction, setClosedHoleAction,  waitTimeBetweenSpawns, setKillableAction, holeOpening, spawnMuffinManAction]]];
    
    [self runAction: animationAction];
    
    return self;
}

-(void) resetSpawnSequenceFromStart {
    [self removeAllActions];
    [self runAction: animationAction];
}

-(void) spawnInitialMuffinManIfRequired {
    if(respawnWaitTime > 4.5) {
        [(GEAGameScene*) self.parent spawnMuffinManFromHole: self ];
    }
}

-(bool)isHoleKillable {
    return isKillable;
}

-(void) setKillable: (bool) isHoleKillable {
    isKillable = isHoleKillable;
}

-(void)initializeCollisionConfig {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = holeCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = muffinCategory;
    self.physicsBody.collisionBitMask = 0;
    [self setZPosition: -1.0];
}


@end
