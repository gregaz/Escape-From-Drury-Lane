//
//  GEAButton.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/12/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAButton.h"

@implementation GEAButton {
    bool wasPressed;
}

-(id) initWithButtonImageNamed: (NSString *) buttonImage {
    self = [super initWithImageNamed: buttonImage];
    self.isPressed = false;
    [self setUserInteractionEnabled:YES];
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.isPressed = true;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.isPressed = false;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.isPressed = false;
}

//This must be called every time a scene is updated for the button to work properly (at the end of update)
//Make your scene be a subclass of GEAButtonEnabledScene and implement the update method as follows to use these buttons:
//-(void)update:(CFTimeInterval)currentTime {
//  <YOUR UPDATE CODE HERE>
//[super update:currentTime];
//}
-(void) updateButtonStatus {
    wasPressed = self.isPressed;
}

//Call this to check if you should action something based on button input (needs updateButtonStatus to work)
-(bool) shouldActionPress {
    return wasPressed && !self.isPressed;
}

@end
