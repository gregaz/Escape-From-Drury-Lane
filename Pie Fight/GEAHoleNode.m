//
//  GEAHoleNode.m
//  Pie Fight
//
//  Created by Gregory Azuolas on 1/28/15.
//  Copyright (c) 2015 Gregory Azuolas. All rights reserved.
//

#import "GEAHoleNode.h"

@implementation GEAHoleNode {
    bool isOpen;
}

-(bool)isHoleOpen {
    return isOpen;
}

-(id)initWithRandomState {
    self = [super initWithImageNamed:@"closedhole.png"];
    isOpen = arc4random_uniform(2) == 0;
    [self updateTextureBasedOnState];
    return self;
}

-(void) flipFlopHole {
    isOpen = !isOpen;
    [self updateTextureBasedOnState];
}

-(void)updateTextureBasedOnState {
    if(isOpen) {
        self.texture = [SKTexture textureWithImageNamed: @"openhole.png"];
    } else {
        self.texture = [SKTexture textureWithImageNamed: @"closedhole.png"];
    }
}


@end
