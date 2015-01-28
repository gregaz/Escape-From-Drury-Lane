//
//  GEAJoyStick.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/11/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GEAJoyStick : SKSpriteNode

-(id)initWithJoystickImage:(NSString *)joystickImage
                 baseImage:(NSString *)baseImage;
@property float x;
@property float y;

@end