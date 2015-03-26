//
//  GEAMuffinNode.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 2/7/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GEAMuffinNode : SKSpriteNode

-(void)initializeCollisionConfig;
-(void)launchMuffinTowardsDestination: (CGPoint) aDestination;
-(CGPoint)launchDestination;

@end
