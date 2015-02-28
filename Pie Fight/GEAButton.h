//
//  GEAButton.h
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/12/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GEAButton : SKSpriteNode

-(id) initWithButtonImageNamed: (NSString *) buttonImage;
-(void) updateButtonStatus;
-(bool) shouldActionPress;

@property bool isPressed;


@end
