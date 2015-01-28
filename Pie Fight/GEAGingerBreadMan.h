//
//  GEAGingerBreadMan.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/19/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GEAGingerBreadMan : SKSpriteNode

-(void) throwMuffinWithDirectionVectorX: (double) x andY: (double) y;
-(id) initGingerManWithMuffinOrNil: (SKSpriteNode*) muffin andImageNamed: (NSString*) imageName;
-(id) initGingerManWithoutMuffinWithImageNamed: (NSString*) imageName;
@property SKSpriteNode* muffin;

@end
