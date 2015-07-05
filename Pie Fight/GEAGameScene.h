//
//  GEAMyScene.h
//  Pie Fight
//

//  Copyright (c) 2014 Gregory Azuolas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GEAButtonEnabledScene.h"
#import "GEAHoleNode.h"
#import "GEAMuffinMan.h"

@interface GEAGameScene : GEAButtonEnabledScene

-(GEAMuffinMan*)spawnMuffinManFromHole: (GEAHoleNode*) aHole;

@end
