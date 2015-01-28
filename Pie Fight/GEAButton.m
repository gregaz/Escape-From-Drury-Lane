//
//  GEAButton.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/12/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAButton.h"

@implementation GEAButton

-(id) initWithButtonImageNamed: (NSString *) buttonImage {
    self = [super initWithImageNamed: buttonImage];
    self.isPressed = false;
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

@end
