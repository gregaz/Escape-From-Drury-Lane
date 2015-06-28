//
//  GEAJoyStick.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/11/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAJoyStick.h"
#import "Math.h"

@interface GEAJoyStick ()

@property (strong, nonatomic) SKSpriteNode *joystick;
@property (nonatomic,strong) UITouch *onlyTouch;
@property float angle;
@property float radiusSquared;
@property float controlRadius;

@end


@implementation GEAJoyStick

-(id)initWithJoystickImage:(NSString *)joystickImage baseImage:(NSString *)baseImage
{
    if((self = [super initWithImageNamed:baseImage]))
    {
        [self setScale:0.16];
        self.joystick = [[SKSpriteNode alloc]initWithImageNamed:joystickImage];
        [self.joystick setScale:0.75];
        [self.joystick setPosition:CGPointMake(self.position.x/2, self.position.y/2)];
        [self addChild:self.joystick];
        self.controlRadius = self.joystick.size.width/5;
        self.radiusSquared = pow(self.controlRadius, 2);
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.onlyTouch) {
        self.onlyTouch = [touches anyObject];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if(!self.onlyTouch){
        return;
    }
    CGPoint location = [self.onlyTouch locationInNode:[self parent]];
    CGFloat newx = location.x;
    CGFloat newy = location.y;
    if((pow(newx-self.position.x,2)+pow(newy-self.position.y,2))>self.radiusSquared){
        self.angle = atan2f (newy - self.position.y,newx - self.position.x);
        newx = (float)(self.position.x + self.controlRadius*cos(self.angle));
        newy = (float)(self.position.y + self.controlRadius*sin(self.angle));
    }
    self.joystick.position=[self convertPoint:CGPointMake(newx, newy) fromNode:[self parent]];
    self.x = (newx-self.position.x)/self.controlRadius;
    self.y = (newy-self.position.y)/self.controlRadius;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self centerInteriorIfNeededGivenTouches: touches];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self centerInteriorIfNeededGivenTouches: touches];

}

-(void)centerInteriorIfNeededGivenTouches: (NSSet *)touches
{
    if ([[touches allObjects] containsObject:self.onlyTouch]) {
        self.onlyTouch = nil;
        self.joystick.position=CGPointMake(0,0);
        self.x = 0;
        self.y = 0;
    }
    
}
@end