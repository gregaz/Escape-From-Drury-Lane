//
//  GEARandomizablePositionNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEARandomizablePositionNode.h"

@implementation GEARandomizablePositionNode

-(int)generateRandomXValueForPositionForIncrements: (double)incAmount andSceneWidth: (double) sceneWidth {
    int xInc = sceneWidth / incAmount;
    return (int) ((arc4random_uniform((int) (xInc * 0.7)) + xInc*0.15 ) * incAmount);
}

-(int)generateRandomYValueForPositionForIncrements: (double)incAmount andControlsHeight: (double)controlsHeight andSceneHeight: (double) sceneHeight {
    int yInc = (sceneHeight - controlsHeight) / incAmount;
    return (int) ((arc4random_uniform(((int)yInc * 0.8)) + yInc*0.1 ) * incAmount) + controlsHeight;
}

-(void) randomizePositionForIncrements: (double)incAmount andControlsHeight: (double)controlsHeight andSceneHeight: (double) sceneHeight andSceneWidth: (double) sceneWidth {
    self.position = CGPointMake([self generateRandomXValueForPositionForIncrements: incAmount andSceneWidth:sceneWidth], [self generateRandomYValueForPositionForIncrements: incAmount andControlsHeight: controlsHeight andSceneHeight: sceneHeight]);
}

-(void)randomizeYPositionForIncrements: (double)incAmount andControlsHeight: (double)controlsHeight andSceneHeight: (double) sceneHeight {
    self.position = CGPointMake( self.position.x, [self generateRandomYValueForPositionForIncrements: incAmount andControlsHeight: controlsHeight andSceneHeight: sceneHeight]);
}

-(void)randomizeXPositionForIncrements: (double)incAmount andSceneWidth: (double)sceneWidth {
    self.position = CGPointMake([self generateRandomXValueForPositionForIncrements: incAmount andSceneWidth:sceneWidth], self.position.y);
}

@end
