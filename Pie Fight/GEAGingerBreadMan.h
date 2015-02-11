//
//  GEAGingerBreadMan.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/19/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GEARandomizablePositionNode.h"
#import "GEAMuffinNode.h"
#import "GEAMuffinStackNode.h"
#import "GEAPointMath.h"

@interface GEAGingerBreadMan : GEARandomizablePositionNode

-(void) throwMuffinWithDirectionVectorX: (double) x andY: (double) y;
-(id) initGingerManWithMuffinOrNil: (SKSpriteNode*) muffin andImageNamed: (NSString*) imageName;
-(id) initGingerManWithoutMuffinWithImageNamed: (NSString*) imageName;
-(void) pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) aMuffinStack;
@property GEAMuffinNode* muffin;

@end
