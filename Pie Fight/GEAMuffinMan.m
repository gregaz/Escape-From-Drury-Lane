//
//  GEAMuffinMan.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/9/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAMuffinMan.h"
#import "GEAConstants.h"
#import "GEAMuffinNode.h"

static const int speed = 100;

@implementation GEAMuffinMan {
    SKTextureAtlas *muffinManAtlas;
    NSMutableArray *muffinManAnimationArray;
    SKTextureAtlas *eatAnimationAtlas;
    NSMutableArray *eatAnimationArray;
    NSTimeInterval timeBeforeNewTarget;
    CFTimeInterval timeOfLastUpdate;
    SKAction *impactSound;
    bool isDead;
}

-(id) initMuffinManWithPhysicsBody: (SKPhysicsBody*) physicsBody andAnimationArray: (NSMutableArray*) animationArray andImpactSound: (SKAction*) aImpactSound {
    self = [self init];
    muffinManAnimationArray = animationArray;
    [self setTexture: muffinManAnimationArray[0]];
    [self setSize: [((SKTexture*)muffinManAnimationArray[0]) size]];
    [self initializeCollisionConfigWithPhysicsBody: physicsBody];
    isDead = false;
    timeBeforeNewTarget = 1.0;
    timeOfLastUpdate = 0;
    impactSound = aImpactSound;
    return self;
}

-(void) initAtlasAndAnimationArray {
    muffinManAtlas = [SKTextureAtlas atlasNamed: @"muffinMen"];
    muffinManAnimationArray = [NSMutableArray array];
    
    for(int i = 1; i <= muffinManAtlas.textureNames.count; i++) {
        NSString* fileName = [NSString stringWithFormat: @"muffinMan%i", i];
        SKTexture *temp = [muffinManAtlas textureNamed:fileName];
        [muffinManAnimationArray addObject:temp];
    }
}

-(void) initializeCollisionConfigWithPhysicsBody: (SKPhysicsBody*) physicsBody {
    self.physicsBody = physicsBody;
    self.physicsBody.categoryBitMask = enemyCategory;
    self.physicsBody.dynamic = YES;
    self.physicsBody.contactTestBitMask = muffinCategory + playerCategory + holeCategory;
    self.physicsBody.collisionBitMask = 0;
    
}

-(void) animateWalk {
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures: muffinManAnimationArray
                                      timePerFrame:0.1f
                                            resize:YES
                                           restore:YES]] withKey:@"gingerBreadManRunning"];
}

-(void) animateEatGingerBreadMan {
    [self removeAllActions];
    eatAnimationAtlas = [SKTextureAtlas atlasNamed: @"deathAnimation"];
    eatAnimationArray = [NSMutableArray array];
    
    for(int i = 1; i <= eatAnimationAtlas.textureNames.count; i++) {
        NSString* fileName = [NSString stringWithFormat: @"death%i", i];
        SKTexture *temp = [eatAnimationAtlas textureNamed:fileName];
        [eatAnimationArray addObject:temp];
    }
    
    [self runAction: [SKAction animateWithTextures: eatAnimationArray
                                      timePerFrame:0.2f
                                            resize:YES
                                           restore:NO]];
    [self runAction: [SKAction waitForDuration:0.5] completion:^{[self runAction: [SKAction playSoundFileNamed:@"bite.wav" waitForCompletion:NO]];} ];
}

-(void)updateVeolictyIfNeededBasedOnTime: (CFTimeInterval) currentTime towardsPlayer: (SKSpriteNode*) player {
    if (timeOfLastUpdate == 0) {
        timeOfLastUpdate = currentTime - arc4random_uniform(10) * 0.1;
    }
    if([self yScale] > 0.29 && ![self isDead]) {
        if(currentTime - timeOfLastUpdate > timeBeforeNewTarget) {
            timeOfLastUpdate = currentTime;
            [self moveTowardsLocation:player.position];
    }}
}

-(void)moveTowardsLocation: (CGPoint) destination {
    [self removeAllActions];
    
    double duration = [GEAPointMath distanceBetween:destination and:self.position] / speed;
    SKAction* moveAction = [SKAction moveTo:destination duration:duration];
    [self animateWalk];
    if(destination.x > self.position.x) {
        self.xScale = ABS(self.xScale);
    } else {
        self.xScale = -1.0 * ABS(self.xScale);
    }
    
    [self runAction:moveAction];
}

-(bool) isDead {
    return isDead;
}

-(void) wasHitByMuffin: (GEAMuffinNode*) aMuffin {
    [self removeAllActions];
    [self runAction:impactSound];
    aMuffin.physicsBody = nil;
    isDead = true;
    self.physicsBody = nil;
    CGPoint destination = [aMuffin launchDestination];
    float duration = [GEAPointMath distanceBetween:self.position and: destination] / muffinVelocity;
    SKAction* moveAction = [SKAction moveTo: destination duration: duration];
    SKAction* moveDoneAction = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[moveAction, moveDoneAction]]];
}

@end
