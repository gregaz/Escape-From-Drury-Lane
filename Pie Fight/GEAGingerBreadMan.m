//
//  GEAGingerBreadMan.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/19/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAGingerBreadMan.h"

static const NSString* withoutMuffinImageName = @"gingerBreadMan.png";
static const NSString* withMuffinImageName = @"gingerBreadManWithMuffin.png";

@implementation GEAGingerBreadMan

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
        [self.muffin initializeCollisionConfig];
        
        [[self parent] addChild: self.muffin];
        
        CGPoint destination = [GEAPointMath addPoint:self.muffin.position
                                            andPoint:([GEAPointMath scalePoint: CGPointMake(x, y) by:1000.0])];
        
        float velocity = 480.0/100.0;
        float duration = self.size.width / velocity;
        
        SKAction* moveAction = [SKAction moveTo:destination duration:duration];
        SKAction* moveDoneAction = [SKAction removeFromParent];
        [self.muffin runAction:[SKAction sequence:@[moveAction, moveDoneAction]]];

        [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed: withoutMuffinImageName] resize:true]];
        [self setScale: 0.1];
    self.muffin = nil;
    //Check if there is a new muffin to pickup (didBeginContact won't be called again unless you leave the stack first
        for (SKPhysicsBody* physicsBody in self.physicsBody.allContactedBodies) {
            if([physicsBody.node isMemberOfClass: [GEAMuffinStackNode class]]){
                [self pickupMuffinFromMuffinStack: (GEAMuffinStackNode*)physicsBody.node];
            }
        }
    }
}

-(void) pickupMuffinFromMuffinStack: (GEAMuffinStackNode*) aMuffinStack {
    if(![self hasMuffin]) {
        self.muffin = [[GEAMuffinNode alloc] initWithImageNamed: @"muffin.png"];
        [self runAction:[SKAction setTexture:[SKTexture textureWithImageNamed: withMuffinImageName] resize:true]];
        [aMuffinStack loseOneMuffin];
        [self setScale: 0.1];
    }
}

-(bool) hasMuffin {
    return self.muffin != nil;
}

@end
