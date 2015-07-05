//
//  GEAHoleNode.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GEARandomizablePositionNode.h"

@interface GEAHoleNode : GEARandomizablePositionNode

-(void)initializeCollisionConfig;
-(void) setKillable: (bool) isHoleKillable;
-(id) initHoleWithOpeningArray: (NSMutableArray*) openingAnimationArray andCloseTexture: (SKTexture*) holeClosedTexture;
-(void) resetSpawnSequenceFromStart;
-(bool)isHoleKillable;
-(void) spawnMuffinManFromSelf;
-(void) spawnInitialMuffinManIfRequired;

@end
