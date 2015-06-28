//
//  GEAMuffinMan.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/9/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEARandomizablePositionNode.h"
#import "GEAPointMath.h"
#import "GEAMuffinNode.h"

@interface GEAMuffinMan : GEARandomizablePositionNode

-(void)moveTowardsLocation: (CGPoint) destination;
-(void)updateVeolictyIfNeededBasedOnTime: (CFTimeInterval) currentTime towardsPlayer: (SKSpriteNode*) player;
-(id) initMuffinManWithPhysicsBody: (SKPhysicsBody*) physicsBody andAnimationArray: (NSMutableArray*) animationArray andImpactSound: (SKAction*) aImpactSound;
-(void) animateEatGingerBreadMan;
-(void) initializeCollisionConfigWithPhysicsBody: (SKPhysicsBody*) physicsBody ;
-(void) wasHitByMuffin: (GEAMuffinNode*) aMuffin;
-(bool) isDead;

@end
