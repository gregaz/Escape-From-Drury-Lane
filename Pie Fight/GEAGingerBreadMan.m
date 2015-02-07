//
//  GEAGingerBreadMan.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/19/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAGingerBreadMan.h"

@implementation GEAGingerBreadMan

static inline CGPoint geaMultiply(CGPoint point, float factor) {
    return CGPointMake(point.x * factor, point.y * factor);
}

-(id) initGingerManWithMuffinOrNil: (GEAMuffinNode*) muffin andImageNamed: (NSString*) imageName {
    self = [super initWithImageNamed: imageName];
    self.muffin = muffin;
    return self;
}

-(id) initGingerManWithoutMuffinWithImageNamed: (NSString*) imageName {
    return [self initGingerManWithMuffinOrNil:nil andImageNamed: imageName];
}

-(void) throwMuffinWithDirectionVectorX:(double)x andY: (double)y {
    if([self hasMuffin] || (x == 0.0 && y == 0.0)) {
        [self.muffin setPosition: self.position];
        [self.muffin setScale: 0.05];
        
        [[self parent] addChild: self.muffin];
        
        CGPoint destination = geaMultiply(CGPointMake(x, y), 1000);
        
        float velocity = 480.0/1.0;
        float duration = self.size.width / velocity;
        
        SKAction* moveAction = [SKAction moveTo:destination duration:duration];
        SKAction* moveDoneAction = [SKAction removeFromParent];
        [self.muffin runAction:[SKAction sequence:@[moveAction, moveDoneAction]]];
    
    self.muffin = nil;
    }
}

-(void) pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) aMuffinStack {
    self.muffin = [[GEAMuffinNode alloc] initWithImageNamed: @"muffin.png"];
    [aMuffinStack loseOneMuffin];
}

-(bool) hasMuffin {
    return self.muffin != nil;
}

@end
