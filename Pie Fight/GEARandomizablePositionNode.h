//
//  GEARandomizablePositionNode.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GEARandomizablePositionNode : SKSpriteNode

-(void) randomizePositionForIncrements: (double)incAmount andControlsHeight: (double)controlsHeight andSceneHeight: (double) sceneHeight andSceneWidth: (double) sceneWidth;
-(void)randomizeYPositionForIncrements: (double)incAmount andControlsHeight: (double)controlsHeight andSceneHeight: (double) sceneHeight;
-(void)randomizeXPositionForIncrements: (double)incAmount andSceneWidth: (double)sceneWidth;


@end
