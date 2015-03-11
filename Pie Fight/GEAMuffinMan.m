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

@implementation GEAMuffinMan {
    SKTextureAtlas *muffinManAtlas;
    NSMutableArray *muffinManAnimationArray;
    SKTextureAtlas *eatAnimationAtlas;
    NSMutableArray *eatAnimationArray;
}

-(id) initMuffinManWithPhysicsBody: (SKPhysicsBody*) physicsBody andAnimationArray: (NSMutableArray*) animationArray {
    self = [self init];
    muffinManAnimationArray = animationArray;
    [self setTexture: muffinManAnimationArray[0]];
    [self setSize: [((SKTexture*)muffinManAnimationArray[0]) size]];
    [self initializeCollisionConfigWithPhysicsBody: physicsBody];
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

@end
