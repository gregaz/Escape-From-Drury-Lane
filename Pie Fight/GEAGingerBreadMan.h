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

-(id) initGingerManWithMuffinOrNil: (GEAMuffinNode*) muffin andAtlasImageNamed: (NSString*) imageName;
-(id) initGingerBreadManWithDefaultImage;
-(id) initGingerBreadManWithDefaultSideRunImage;

-(void) throwMuffinWithDirectionVectorX: (double) x andY: (double) y;
-(void) pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) aMuffinStack;

-(void) moveUsingVectorWithX: (double) x andY: (double) y;

-(void) animateSideRunRight;
-(void) animateSideRunLeft;
-(void) animateDownRun;

@property GEAMuffinNode* muffin;

@end
